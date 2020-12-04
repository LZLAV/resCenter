#ifndef __VIDEO_DECODER_H__
#define __VIDEO_DECODER_H__

#include "decoder.h"

typedef void (*VideoDecodingHandler)(AVFrame*, double);

class VideoDecoder: public Decoder {
public:
	VideoDecoder(AVStream* stream);
	~VideoDecoder();

	VideoDecodingHandler onDecoded;
	double mVideoClock;

private:
	AVFrame* mFrame;

	int prepare();
	int decode(void* ptr);
	int process(AVPacket *packet);
};

#endif
