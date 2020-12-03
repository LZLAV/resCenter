// mediaplayer.cpp (along with other files it needs) : implements
// a C++ media player, which decodes and outputs video and audio.
//
// Copyright (c) 2013 Strongene Ltd. All Right Reserved.
// http://www.strongene.com
//
// Contributors:
// Shengbin Meng <shengbinmeng@gmail.com>
//
// You are free to re-use this as the basis for your own application
// in source and binary forms, with or without modification, provided
// that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright
// notice and this list of conditions.
//  * Redistributions in binary form must reproduce the above
// copyright notice and this list of conditions in the documentation
// and/or other materials provided with the distribution.

#include <sys/types.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include "mediaplayer.h"

extern "C" {
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libavutil/log.h"
}

#define LOG_TAG "MediaPlayer"

#define USE_LENTHEVCDEC 1

#define MAX_AP_QUEUE_SIZE (2 * 128)
#define MAX_VP_QUEUE_SIZE (2 * 128)
#define MAX_FRAME_QUEUE_SIZE 14
#define TIMEOUT_MS 5000

static MediaPlayer* sPlayer;
static MediaPlayerListener* sListener;
static int sWaiting = 0;

// ffmpeg calls this back, used for log
static void ffmpeg_log_callback (void* ptr, int level, const char* fmt, va_list vl) {

	char s[1024];
	vsnprintf(s, 1024, fmt, vl);

	switch (level) {

		case AV_LOG_PANIC:
		case AV_LOG_FATAL:
		case AV_LOG_ERROR:
		case AV_LOG_WARNING:
		LOGE("%s \n", s);
		break;

		case AV_LOG_INFO:
		LOGI("%s \n", s);
		break;

		case AV_LOG_DEBUG:
		//LOGD("%s \n", s);
		break;
	}
}

MediaPlayer::MediaPlayer() {

	mTime = 0;
	mAudioDecoder = NULL;
	mVideoDecoder = NULL;
	mListener = NULL;

	mDuration = 0;
	mCurrentPosition = 0;
	mSeekPosition = 0;
	mCurrentState = MEDIA_PLAYER_IDLE;

	mVideoWidth = mVideoHeight = 0;
	mFrameLastDelay = mFrameLastPTS = 0;
	mAudioClock = 0;

	pthread_mutex_init(&mLock, NULL);
	pthread_cond_init(&mCondition, NULL);

	//initialize ffmpeg
	av_register_all();
	avformat_network_init();
	av_log_set_callback(ffmpeg_log_callback);
	av_init_packet(&mFlushPacket);
	mFlushPacket.data = (uint8_t*) "FLUSH";

	mNeedSeek = 0;
	sWaiting = 0;
	mTimeStart = 0;
	mFrames = 0;
	mTimeLast = 0;
	mThreadNumber = 0;
	mLoopPlay = 0;

	mCurrentState = MEDIA_PLAYER_INITIALIZED;

	sPlayer = this;
}

MediaPlayer::~MediaPlayer() {
	pthread_mutex_destroy(&mLock);
	pthread_cond_destroy(&mCondition);
	avformat_network_deinit();
}

int MediaPlayer::prepareAudio() {
	LOGI("prepareAudio \n");

	// find the first audio stream
	mAudioStreamIndex = -1;
	for (int i = 0; i < mFormatContext->nb_streams; i++) {
		if (mFormatContext->streams[i]->codec->codec_type == AVMEDIA_TYPE_AUDIO) {
			mAudioStreamIndex = i;
			break;
		}
	}

	if (mAudioStreamIndex == -1) {
		return -1;
	}

	// get a pointer to the codec context for the video stream
	AVStream* stream = mFormatContext->streams[mAudioStreamIndex];
	AVCodecContext* codec_ctx = stream->codec;
	LOGI("audio codec id: %d \n", codec_ctx->codec_id);
	char buffer[128];
	av_get_sample_fmt_string(buffer, 128, codec_ctx->sample_fmt);
	LOGI("sample rate: %d, format: %d (%s) \n", codec_ctx->sample_rate, codec_ctx->sample_fmt, buffer);

	AVCodec* codec = avcodec_find_decoder(codec_ctx->codec_id ? codec_ctx->codec_id : CODEC_ID_MP3);
	if (codec == NULL) {
		LOGE("find audio decoder failed \n");
		return -1;
	}

	// open codec
	if (avcodec_open2(codec_ctx, codec, NULL) < 0) {
		LOGE("open audio codec failed \n");
		return -1;
	}

	return 0;
}

int MediaPlayer::prepareVideo() {

	LOGI("prepareVideo \n");

	// find the first video stream
	mVideoStreamIndex = -1;
	for (int i = 0; i < mFormatContext->nb_streams; i++) {
		if (mFormatContext->streams[i]->codec->codec_type == AVMEDIA_TYPE_VIDEO) {
			mVideoStreamIndex = i;
			break;
		}
	}
	if (mVideoStreamIndex == -1) {
		return -1;
	}

	// get a pointer to the codec context of the video stream
	AVStream* stream = mFormatContext->streams[mVideoStreamIndex];
	AVCodecContext* codec_ctx = stream->codec;
	LOGI("video codec id: %d \n", codec_ctx->codec_id);
	LOGI("frame rate and time base: %d/%d = %f, %d/%d = %f \n", stream->r_frame_rate.num, stream->r_frame_rate.den, (float)stream->r_frame_rate.num / stream->r_frame_rate.den, stream->time_base.num, stream->time_base.den, (float)stream->time_base.num / stream->time_base.den);

	// find and open video decoder
	AVCodec* codec = avcodec_find_decoder(codec_ctx->codec_id);
#if USE_LENTHEVCDEC
	AVCodec* lenthevc_dec = avcodec_find_decoder_by_name("liblenthevc");
	if (codec->id == lenthevc_dec->id) {
		codec = lenthevc_dec;
	}
	LOGI("use lenthevcdec for HEVC decoding \n");
#endif
	if (codec == NULL) {
		LOGE("find video decoder failed \n");
		return -1;
	}
	if (avcodec_open2(codec_ctx, codec, NULL) < 0) {
		LOGE("open video decoder failed \n");
		return -1;
	}

	// set video decoder thread number
	if (mThreadNumber > 1) {
		codec_ctx->thread_count = mThreadNumber;
		codec_ctx->thread_type = FF_THREAD_FRAME;
	}

	mVideoWidth = codec_ctx->width;
	mVideoHeight = codec_ctx->height;
	LOGI("width: %d, height: %d \n", codec_ctx->width, codec_ctx->height);

	return 0;
}

int MediaPlayer::open(char* file) {
	if (mCurrentState < MEDIA_PLAYER_INITIALIZED) {
		LOGE("not initialized \n");
		return -1;
	}

	LOGI("opening \n");

	// open media file
	mFormatContext = NULL;
	int ret = avformat_open_input(&mFormatContext, file, NULL, NULL);
	if (ret != 0) {
		LOGE("avformat_open_input failed: %d, when open: %s \n", ret, file);
		return -1;
	}

	// retrieve stream information
	if (mFormatContext->streams[AVMEDIA_TYPE_VIDEO]) {
		// for HEVC video, we should use lenthevc decoder to find stream info
		AVCodec* lenthevc_dec = avcodec_find_decoder_by_name("liblenthevc");
		AVCodec* codec = avcodec_find_decoder(mFormatContext->streams[AVMEDIA_TYPE_VIDEO]->codec->codec_id);
		if(codec == NULL || codec->id == lenthevc_dec->id) {
			mFormatContext->streams[AVMEDIA_TYPE_VIDEO]->codec->codec = lenthevc_dec;
		}
	}

	if (avformat_find_stream_info(mFormatContext, NULL) < 0) {
		LOGE("av_find_stream_info failed \n");
		return -1;
	}

	mDuration = mFormatContext->duration / AV_TIME_BASE * 1000;
	LOGI("media duration: %lld \n", mDuration);

	int ret1 = prepareAudio();
	int ret2 = prepareVideo();

	// if neither video or audio is prepared, return error
	if (ret1 != 0 && ret2 != 0) {
		mCurrentState = MEDIA_PLAYER_STATE_ERROR;
		return -1;
	}

	mCurrentPosition = 0;
	mCurrentState = MEDIA_PLAYER_PREPARED;

	return 0;
}

int MediaPlayer::close() {
	LOGI("closing \n");
	// close codecs
	if (mAudioStreamIndex != -1) {
		avcodec_close(mFormatContext->streams[mAudioStreamIndex]->codec);
	}
	if (mVideoStreamIndex != -1) {
		avcodec_close(mFormatContext->streams[mVideoStreamIndex]->codec);
	}

	// close the video file
	avformat_close_input(&mFormatContext);

	LOGI("closed \n");
	return 0;
}

int MediaPlayer::setListener(MediaPlayerListener* listener) {
	mListener = listener;
	sListener = mListener;
	return 0;
}

int MediaPlayer::setThreadNumber(int num) {
	LOGI("set thread number: %d \n", num);
	mThreadNumber = num;
	return 0;
}

int MediaPlayer::setLoopPlay(int loop) {
	LOGI("set loop play: %d \n", loop);
	mLoopPlay = loop;
	return 0;
}

// handler for receiving decoded audio buffers
void MediaPlayer::audioOutput(void* buffer, int buffer_size) {
	if (sPlayer->mCurrentState == MEDIA_PLAYER_PAUSED) {
		sPlayer->mAudioDecoder->waitOnNotify();
	}

	// save the audio clock for sync
	sPlayer->mAudioClock = sPlayer->mAudioDecoder->mAudioClock;
	sPlayer->mCurrentPosition = sPlayer->mAudioClock * 1000;

	int written = sListener->audioTrackWrite(buffer, 0, buffer_size);
	if (written < 0) {
		LOGE("Couldn't write samples to audio track \n");
	}
}

// handler for receiving decoded video frames
void MediaPlayer::videoOutput(AVFrame* frame, double pts) {

	// allocate a video frame, copy data to it, and put it in the frame queue
	VideoFrame *vf = (VideoFrame*) malloc(sizeof(VideoFrame));
	if (vf == NULL) {
		LOGE("vf malloc failed \n");
	}
	vf->width = sPlayer->mVideoWidth;
	vf->height = sPlayer->mVideoHeight;
	vf->linesize_y = frame->linesize[0];
	vf->linesize_uv = frame->linesize[1];
	vf->pts = pts;
	vf->next = NULL;
	vf->yuv_data[0] = (uint8_t*) malloc(vf->height * (vf->linesize_y + vf->linesize_uv));
	if (vf->yuv_data[0] == NULL) {
		LOGE("yuv_data malloc failed \n");
	}
	vf->yuv_data[1] = vf->yuv_data[0] + vf->height * vf->linesize_y;
	vf->yuv_data[2] = vf->yuv_data[1] + vf->height / 2 * vf->linesize_uv;

	memcpy(vf->yuv_data[0], frame->data[0], vf->height * vf->linesize_y);
	memcpy(vf->yuv_data[1], frame->data[1], vf->height / 2 * vf->linesize_uv);
	memcpy(vf->yuv_data[2], frame->data[2], vf->height / 2 * vf->linesize_uv);

	sPlayer->mFrameQueue.put(vf);
	int size = sPlayer->mFrameQueue.size();
	LOGD("after put, video frame queue size: %d \n", size);

	pthread_mutex_lock(&sPlayer->mLock);
	if (size >= MAX_FRAME_QUEUE_SIZE && sWaiting == 0) {
		LOGD("video frames too many, pause decoding to wait \n");
		sWaiting = 1;
		pthread_cond_wait(&sPlayer->mCondition, &sPlayer->mLock);
	}
	pthread_mutex_unlock(&sPlayer->mLock);
}

void MediaPlayer::renderVideo(void* ptr) {
	while (mCurrentState != MEDIA_PLAYER_STOPPED && mCurrentState != MEDIA_PLAYER_STATE_ERROR) {
		if (mCurrentState == MEDIA_PLAYER_PAUSED) {
			usleep(200000);
			continue;
		}

		VideoFrame *vf = NULL;
		bool block = true;
		// if video has been decoded, do not block queue, i.e. exit when queue is empty
		if (mCurrentState == MEDIA_PLAYER_VIDEO_DECODED) {
			block = false;
		}
		mFrameQueue.get(&vf, block);
		if (vf == NULL) {
			break;
		}

		int size = sPlayer->mFrameQueue.size();
		LOGD("after get, video frame queue size: %d \n", size);

		pthread_mutex_lock(&mLock);
		if (size < 0.6 * MAX_FRAME_QUEUE_SIZE && sWaiting == 1) {
			LOGD("video frames are consumed, notify to continue decoding \n");
			pthread_cond_signal(&mCondition);
			sWaiting = 0;
		}
		pthread_mutex_unlock(&mLock);

		double delay = vf->pts - mFrameLastPTS;

		mFrameLastPTS = vf->pts;

		double diff = 0;
		if (mAudioClock != 0) {
			double ref_clock = mAudioClock + delay;
			diff = vf->pts - ref_clock;
			LOGD("diff: %lf - %lf = %lf (%lld)", vf->pts, ref_clock, diff, (int64_t)(diff * 1000));
		}

		delay += diff;
		LOGD("delay: %lf (%lld)", delay, (int64_t)(delay*1000));
		if (delay > 0 && delay < 10) {
			usleep(delay*1000000);
		}

		sListener->drawFrame(vf);

		if (mAudioClock == 0) {
			mCurrentPosition += vf->pts * 1000;
		}
		// update information
		struct timeval timeNow;
		gettimeofday(&timeNow, NULL);
		double tnow = timeNow.tv_sec + (timeNow.tv_usec / 1000000.0);
		if (mTimeLast == 0) mTimeLast = tnow;
		if (mTimeStart == 0) mTimeStart = tnow;
		if (tnow > mTimeLast + 1) {
			mFrameCount += mFrames;
			double avg_fps = mFrameCount / (tnow - mTimeStart);
			LOGI("Video Display FPS: %d, average: %.2lf", mFrames, avg_fps);
			sListener->postEvent(900, mFrames, int(avg_fps * 4096));
			mTimeLast = mTimeLast + 1;
			mFrames = 0;
		}
		mFrames++;
	}

	// if decoder is waiting, notify it to give up
	if (sWaiting) {
		LOGD("notify after the while \n");
		pthread_mutex_lock(&mLock);
		pthread_cond_signal(&mCondition);
		sWaiting = 0;
		pthread_mutex_unlock(&mLock);
	}

	mFrameQueue.abort();
	mFrameQueue.flush();

	if (pthread_join(mDecodingThread, NULL) != 0) {
		LOGE("join decoding thread failed \n");
	}
	LOGI("end of rendering thread \n");

	mCurrentState = MEDIA_PLAYER_PLAYBACK_COMPLETE;
}

void MediaPlayer::decodeMedia(void* ptr) {

	av_seek_frame(mFormatContext, mAudioStreamIndex, 0, AVSEEK_FLAG_BACKWARD);
	av_seek_frame(mFormatContext, mVideoStreamIndex, 0, AVSEEK_FLAG_BACKWARD);

	if (mAudioStreamIndex != -1) {
		AVStream* stream_audio = mFormatContext->streams[mAudioStreamIndex];
		mAudioDecoder = new AudioDecoder(stream_audio);
		mAudioDecoder->onDecoded = audioOutput;
		mAudioDecoder->startAsync();
	}
	if (mVideoStreamIndex != -1) {
		AVStream* stream_video = mFormatContext->streams[mVideoStreamIndex];
		mVideoDecoder = new VideoDecoder(stream_video);
		mVideoDecoder->onDecoded = videoOutput;
		mVideoDecoder->startAsync();
	}

	AVPacket p, *packet = &p;
	LOGI("begin parsing...\n");

	while (mCurrentState != MEDIA_PLAYER_STOPPED && mCurrentState != MEDIA_PLAYER_STATE_ERROR) {

		// seek
		if (mNeedSeek) {
			LOGI("seek posotion: %lld \n", mSeekPosition);

			int stream_index = -1;
			if (mAudioStreamIndex >= 0) {
				stream_index = mAudioStreamIndex;
			} else if (mVideoStreamIndex >= 0) {
				stream_index = mVideoStreamIndex;
			}

			int64_t seek_target = mSeekPosition * 1000;
			if (stream_index >= 0) {
				seek_target = av_rescale_q(seek_target, AV_TIME_BASE_Q,
						mFormatContext->streams[stream_index]->time_base);
			}

			LOGI("seek target: %lld \n", seek_target);
			int ret = avformat_seek_file(mFormatContext, stream_index, LONG_LONG_MIN, seek_target, LONG_LONG_MAX, AVSEEK_FLAG_FRAME);
			if (ret < 0) {
				LOGE("error while seeking; return: %d \n", ret);
			} else {
				pthread_mutex_lock(&mLock);
				// flush the packet queue
				if (mAudioDecoder != NULL) {
					mAudioDecoder->flushQueue();
					mAudioDecoder->enqueue(&mFlushPacket);
				}
				if (mVideoDecoder != NULL) {
					mVideoDecoder->flushQueue();
					mVideoDecoder->enqueue(&mFlushPacket);

					// flush the frame queue
					mFrameQueue.flush();
					if (sWaiting == 1) {
						pthread_cond_signal(&mCondition);
						sWaiting = 0;
					}

				}
				mAudioDecoder->mAudioClock = mSeekPosition / 1000.0;
				pthread_mutex_unlock(&mLock);
			}

			mNeedSeek = 0;
			LOGI("queue size (v: %d, a: %d) \n",mVideoDecoder->queueSize(), mAudioDecoder->queueSize());
		}

		// pause
		if (mCurrentState == MEDIA_PLAYER_PAUSED) {
			// can continue decoding, so do nothing here
		}

		int aq_size = -1, vq_size = -1;
		if (mVideoDecoder != NULL) {
			vq_size = mVideoDecoder->queueSize();
		}
		if (mAudioDecoder != NULL) {
			aq_size = mAudioDecoder->queueSize();
		}
		if (vq_size > MAX_VP_QUEUE_SIZE || aq_size > MAX_AP_QUEUE_SIZE) {
			LOGI("two many packets(v: %d, a: %d), have a rest \n", vq_size, aq_size);
			sleep(1);
			continue;
		}

		int ret = av_read_frame(mFormatContext, packet);

		if (ret < 0) {
			LOGE("av_read_frame failed, end of file\n");

			if (mLoopPlay == 1) {
				if (mCurrentState != MEDIA_PLAYER_STOPPED) {
					if (avformat_seek_file(mFormatContext, mVideoStreamIndex, LONG_LONG_MIN, 0, LONG_LONG_MAX, AVSEEK_FLAG_FRAME) < 0) {
						LOGD("avformat_seek_file error, will try av_seek_frame\n");
						if (av_seek_frame(mFormatContext, mVideoStreamIndex, 0, AVSEEK_FLAG_BACKWARD) < 0) {
							LOGE("av_seek_frame error, can not auto-replay\n");
						} else {
							LOGI("automatically play again, after seek frame\n");
							sListener->postEvent(908, 0, 0);
							continue;
						}
					} else {
						LOGI("automatically play again, after seek file\n");
						sListener->postEvent(908, 0, 0);
						continue;
					}
				}
			}

			if (mAudioDecoder != NULL) {
				mAudioDecoder->endQueue();
			}
			if (mVideoDecoder != NULL) {
				mVideoDecoder->endQueue();
			}
			pthread_mutex_lock(&mLock);
			mCurrentState = MEDIA_PLAYER_PARSED;
			pthread_mutex_unlock(&mLock);
			break;
		}

		// a packet from the video stream?
		if (packet->stream_index == mVideoStreamIndex) {
			mVideoDecoder->enqueue(packet);
			LOGD("enqueue a video packet; queue size: %d \n", mVideoDecoder->queueSize());
		} else if (packet->stream_index == mAudioStreamIndex) {
			mAudioDecoder->enqueue(packet);
			LOGD("enqueue an audio packet; queue size: %d \n", mAudioDecoder->queueSize());
		} else {
			LOGE("not video or audio packet \n");
			pthread_mutex_lock(&mLock);
			mCurrentState = MEDIA_PLAYER_STATE_ERROR;
			pthread_mutex_unlock(&mLock);
		}
	}

	// after dispatching all packets, wait for the decoding and output of audio and video (two threads)
	int ret = -1;
	if (mVideoDecoder != NULL) {
		LOGI("waiting for video thread \n");
		ret = mVideoDecoder->join();
		if (ret != 0) {
			LOGE("wait for video thread failed: %i \n", ret);
		}
	}
	pthread_mutex_lock(&mLock);
	mCurrentState = MEDIA_PLAYER_VIDEO_DECODED;
	pthread_mutex_unlock(&mLock);

	if (mAudioDecoder != NULL) {
		LOGI("waiting for audio thread \n");
		ret = mAudioDecoder->join();
		if (ret != 0) {
			LOGE("wait for audio thread failed: %i \n", ret);
		}
	}

	LOGI("end of decoding thread \n");
}

void* MediaPlayer::startDecoding(void* ptr) {
	sPlayer->decodeMedia(ptr);
	//detachJVM();
	return NULL;
}

void* MediaPlayer::startRendering(void* ptr) {
	sPlayer->renderVideo(ptr);
	// tell the play activity to finish
	sListener->postEvent(909, 0, 0);
	detachJVM();
	return NULL;
}

int MediaPlayer::start() {
	if (mCurrentState < MEDIA_PLAYER_PREPARED) {
		LOGE("player not prepared \n");
		return -1;
	}

	LOGI("start decoding thread \n");
	pthread_create(&mDecodingThread, NULL, startDecoding, NULL);

	LOGI("start rendering thread \n");
	pthread_create(&mRenderingThread, NULL, startRendering, NULL);

	pthread_mutex_lock(&mLock);
	mCurrentState = MEDIA_PLAYER_STARTED;
	pthread_mutex_unlock(&mLock);

	return 0;
}

int MediaPlayer::pause() {
	if (isPlaying()) {
		pthread_mutex_lock(&mLock);
		mCurrentState = MEDIA_PLAYER_PAUSED;
		pthread_mutex_unlock(&mLock);
		return 0;
	}
	return -1;
}

int MediaPlayer::go() {
	if (mCurrentState == MEDIA_PLAYER_PAUSED) {
		pthread_mutex_lock(&mLock);
		mCurrentState = MEDIA_PLAYER_STARTED;
		pthread_mutex_unlock(&mLock);

		if (mAudioDecoder) {
			mAudioDecoder->notify();
		}
		if (mVideoDecoder) {
			mVideoDecoder->notify();
		}

		// recalculate average FPS
		mTimeStart = 0;
		mFrameCount = 0;
	}
	return 0;
}

// stop and release all the resources
int MediaPlayer::stop() {
	if (mCurrentState == MEDIA_PLAYER_STOPPED || mCurrentState < MEDIA_PLAYER_PREPARED) {
		return 0;
	}
	LOGI("stopping \n");

	if (mCurrentState == MEDIA_PLAYER_PAUSED) {
		// notify the waiting threads
		pthread_mutex_lock(&mLock);
		mCurrentState = MEDIA_PLAYER_STARTED;
		pthread_mutex_unlock(&mLock);

		if (mAudioDecoder) {
			mAudioDecoder->notify();
		}
		if (mVideoDecoder) {
			mVideoDecoder->notify();
		}
	}

	pthread_mutex_lock(&mLock);
	mCurrentState = MEDIA_PLAYER_STOPPED;
	pthread_mutex_unlock(&mLock);

	if (mVideoDecoder != NULL) {
		mVideoDecoder->stop();
	}
	if (mAudioDecoder != NULL) {
		mAudioDecoder->stop();
	}

	mFrameQueue.abort();
	if (pthread_join(mRenderingThread, NULL) != 0) {
		LOGE("join rendering thread failed \n");
	}

	// free the decoders
	free(mAudioDecoder);
	free(mVideoDecoder);

	LOGI("stopped \n");

	return 0;
}

bool MediaPlayer::isPlaying() {
	if (mCurrentState == MEDIA_PLAYER_STARTED) {
		return true;
	} else {
		return false;
	}
}

int MediaPlayer::getVideoWidth(int *width) {
	if (mCurrentState < MEDIA_PLAYER_PREPARED) {
		return -1;
	}
	*width = mVideoWidth;
	return 0;
}

int MediaPlayer::getVideoHeight(int *height) {
	if (mCurrentState < MEDIA_PLAYER_PREPARED) {
		return -1;
	}
	*height = mVideoHeight;
	return 0;
}

int MediaPlayer::getCurrentPosition(int *msec) {
	if (mCurrentState < MEDIA_PLAYER_PREPARED) {
		return -1;
	}
	*msec = mCurrentPosition;
	return 0;
}

int MediaPlayer::getDuration(int *msec) {
	if (mCurrentState < MEDIA_PLAYER_PREPARED) {
		return -1;
	}
	*msec = mDuration;
	return 0;
}

int MediaPlayer::seekTo(int msec) {
	LOGD("will seek to: %d ms \n", msec);

	pthread_mutex_lock(&mLock);
	mSeekPosition = msec;
	mNeedSeek = 1;
	pthread_mutex_unlock(&mLock);
	return 0;
}

int MediaPlayer::getAudioParams(int *params) {
	if (mCurrentState < MEDIA_PLAYER_PREPARED || !params) {
		return -1;
	}
	if (mAudioStreamIndex != -1) {
		params[0] = mFormatContext->streams[mAudioStreamIndex]->codec->sample_rate;
		params[1] = mFormatContext->streams[mAudioStreamIndex]->codec->channels;
		params[2] = 0;
	} else {
		params[0] = params[1] = params[2] = 0;
	}

	return 0;
}
