#ifndef __DECODER_H__
#define __DECODER_H__

#include "thread.h"
#include "packetqueue.h"
#include "player_utils.h"
extern "C" {
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
}

class Decoder: public Thread {
public:
	Decoder(AVStream* stream);
	~Decoder();

	int enqueue(AVPacket* packet);
	int outqueue(AVPacket* packet);
	int queueSize();
	void flushQueue();
	void stop();
	void endQueue();

protected:
	PacketQueue* mQueue;
	AVStream* mStream;
	bool mBlock;

	virtual int prepare() = 0;
	virtual int decode(void* ptr) = 0;
	virtual int process(AVPacket *packet) = 0;

	void run(void* ptr);
};

#endif //DECODER_H
