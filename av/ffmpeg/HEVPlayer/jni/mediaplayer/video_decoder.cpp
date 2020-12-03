#include "video_decoder.h"
#include "player_utils.h"

#define LOG_TAG "VideoDecoder"

VideoDecoder::VideoDecoder(AVStream* stream) : Decoder(stream) {

}

VideoDecoder::~VideoDecoder() {

}

int VideoDecoder::prepare() {
	mVideoClock = 0;
	mFrame = av_frame_alloc();
	if (mFrame == NULL) {
		LOGE("avcodec_alloc_frame failed \n");
		return -1;
	}
	return 0;
}

int VideoDecoder::process(AVPacket *packet) {
	int gotFrame = 0;
	// decode video frame
	int len = avcodec_decode_video2(mStream->codec, mFrame, &gotFrame, packet);
	if (len < 0) {
		LOGE("decode video packet failed \n");
	}

	LOGD("packet dts: %lld = %lld; packet pts: %lld = %lld; frame pts: %lld; codec time base: %lf, stream time base: %lf",
			packet->dts, mFrame->pkt_dts, packet->pts, mFrame->pkt_pts, mFrame->pts, av_q2d(mStream->codec->time_base), av_q2d(mStream->time_base));

	if (gotFrame) {
		mFrame->pts = av_frame_get_best_effort_timestamp(mFrame);
		if (mFrame->pts != AV_NOPTS_VALUE) {
			// Time stamp is meaningful, so we use it.
			mVideoClock = av_q2d(mStream->time_base) * mFrame->pts;
			LOGD("best effort frame pts: %lld", mFrame->pts);
		} else {
			// Actually I don't know what to do.
			mVideoClock += av_q2d(mStream->codec->time_base);
			LOGD("time stamp is AV_NOPTS_VALUE: %lld", mFrame->pts);
		}

		/* if we are repeating a frame, adjust clock accordingly */
    	double frameDelay = mFrame->repeat_pict * (av_q2d(mStream->codec->time_base) * 0.5);
		mVideoClock += frameDelay;

		LOGD("output a video frame, mVideoClock: %lf \n", mVideoClock);

		onDecoded(mFrame, mVideoClock);
	}

	return 0;
}

int VideoDecoder::decode(void* ptr) {
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
		LOGD("out queue a video packet; queue size: %d \n", this->queueSize());
		if (process(&packet) != 0) {
			LOGE("process video packet failed \n");
			mRunning = false;
			continue;
		}

		av_free_packet(&packet);
	}

	// free the frame
	av_frame_free(&mFrame);
	LOGI("end of video decoding \n");
	return 0;
}
