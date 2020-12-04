#ifndef __PACKETQUEUE_H__
#define __PACKETQUEUE_H__

#include <pthread.h>
#include "player_utils.h"
extern "C" {
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
}

class PacketQueue
{
public:
	PacketQueue();
	~PacketQueue();

	void flush();
	int put(AVPacket* pkt);
	int get(AVPacket *pkt, bool block);
	int size();
	void abort();

private:
	AVPacketList* mFirst;
	AVPacketList* mLast;
	int mSize;
	bool mAbortRequest;
	pthread_mutex_t mLock;
	pthread_cond_t mCondition;
};

#endif
