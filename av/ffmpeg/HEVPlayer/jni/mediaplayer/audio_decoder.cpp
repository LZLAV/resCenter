#include "audio_decoder.h"
#include "player_utils.h"
extern "C" {
#include "libswresample/swresample.h"
#include "libavutil/opt.h"
}

#define LOG_TAG "AudioDecoder"
#define MAX_AUDIO_FRAME_SIZE 192000

AudioDecoder::AudioDecoder(AVStream* stream) : Decoder(stream) {

}

AudioDecoder::~AudioDecoder() {

}


int AudioDecoder::prepare() {
    mAudioClock = 0;
    mAudioPts = 0;
    mFrame = av_frame_alloc();
	if (mFrame == NULL) {
		LOGE("avcodec_alloc_frame failed \n");
		return -1;
	}
    mSamples = malloc(MAX_AUDIO_FRAME_SIZE);
    if (mSamples == NULL) {
		LOGE("allocate samples failed \n");
		return -1;
    }
    mSwrContext = NULL;
    return 0;
}

int AudioDecoder::process(AVPacket *packet) {
	int gotFrame = 0;
	int len = avcodec_decode_audio4(mStream->codec, mFrame, &gotFrame, packet);
	if (len < 0) {
		LOGE("decode audio packet failed \n");
	}

	LOGD("packet dts: %lld = %lld; packet pts: %lld = %lld; frame pts: %lld", packet->dts, mFrame->pkt_dts, packet->pts, mFrame->pkt_pts, mFrame->pts);

	if (gotFrame) {
		int size = av_samples_get_buffer_size(NULL, mFrame->channels,
				mFrame->nb_samples, AV_SAMPLE_FMT_S16, 1);
		int bps = av_get_bytes_per_sample((AVSampleFormat)mFrame->format);

		if (packet->pts != AV_NOPTS_VALUE) {
			mAudioClock = av_q2d(mStream->time_base) * packet->pts;
		} else {
			double inc = (double)size / (double)(bps * mFrame->sample_rate * mFrame->channels);
			mAudioClock += inc;
		}

		LOGD("output an audio frame, mAudioClock: %lf", mAudioClock);

		// conversion using swresample
		if (mSwrContext == NULL) {
			// Set up SWR context once you've got codec information
			mSwrContext = swr_alloc();
			if (mSwrContext == NULL) {
				LOGE("allocate context failed \n");
			}
			av_opt_set_int(mSwrContext, "in_channel_layout",  mFrame->channel_layout, 0);
			av_opt_set_int(mSwrContext, "out_channel_layout", mFrame->channel_layout, 0);
			av_opt_set_int(mSwrContext, "in_sample_rate",     mFrame->sample_rate, 0);
			av_opt_set_int(mSwrContext, "out_sample_rate",    mFrame->sample_rate, 0);
			av_opt_set_sample_fmt(mSwrContext, "in_sample_fmt", (AVSampleFormat)mFrame->format, 0);
			av_opt_set_sample_fmt(mSwrContext, "out_sample_fmt", AV_SAMPLE_FMT_S16,  0);
			int ret = swr_init(mSwrContext);
			if (ret < 0) {
				LOGE("init context failed \n");
			}
		}
		int ret = swr_convert(mSwrContext, (uint8_t**)&mSamples, mFrame->nb_samples,
		 (const uint8_t **)mFrame->extended_data, mFrame->nb_samples);
		if (ret != mFrame->nb_samples) {
			LOGE("conversion wrong \n");
		}

		// call handler for posting buffer to os audio driver
	    onDecoded(mSamples, size);
	}

    return 0;
}

int AudioDecoder::decode(void* ptr) {
    AVPacket packet;

    while (mRunning) {
        if (outqueue(&packet) != 0) {
        	// aborted
            mRunning = false;
            continue;
        }
        if (memcmp(packet.data, "FLUSH", sizeof("FLUSH")) == 0) {
			avcodec_flush_buffers(mStream->codec);
			LOGD("FLUSH");
			continue;
        }

		LOGD("out queue an audio packet; queue size: %d \n", this->queueSize());
        if (process(&packet) != 0) {
			LOGE("process audio packet failed \n");
			mRunning = false;
			continue;
        }

        // free the packet that was allocated by av_read_frame
        av_free_packet(&packet);
    }

	// free the frame
	av_frame_free(&mFrame);
	free(mSamples);
	if (mSwrContext != NULL) {
		swr_free(&mSwrContext);
	}

	LOGI("end of audio decoding \n");

	detachJVM();
	return 0;
}
