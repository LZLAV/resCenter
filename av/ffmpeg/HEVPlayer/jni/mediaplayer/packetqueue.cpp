#include "packetqueue.h"
#include "player_utils.h"

#define LOG_TAG "PacketQueue"

PacketQueue::PacketQueue() {
	pthread_mutex_init(&mLock, NULL);
	pthread_cond_init(&mCondition, NULL);
	mFirst = NULL;
	mLast = NULL;
	mSize = 0;
	mAbortRequest = false;
}

PacketQueue::~PacketQueue() {
	flush();
	pthread_mutex_destroy(&mLock);
	pthread_cond_destroy(&mCondition);
}

int PacketQueue::size() {
	pthread_mutex_lock(&mLock);
	int size = mSize;
	pthread_mutex_unlock(&mLock);
	return size;
}

void PacketQueue::flush() {
	pthread_mutex_lock(&mLock);

	AVPacketList *pl, *pl_next;
	for (pl = mFirst; pl != NULL; pl = pl_next) {
		pl_next = pl->next;
		av_free_packet(&pl->pkt);
		av_freep(&pl);
	}

	mLast = NULL;
	mFirst = NULL;
	mSize = 0;

	pthread_mutex_unlock(&mLock);
}

int PacketQueue::put(AVPacket* pkt) {
	AVPacketList *pl = (AVPacketList *) av_malloc(sizeof(AVPacketList));
	if (pl == NULL) {
		LOGE("malloc AVPacketList failed \n");
		return -1;
	}

	pl->pkt = *pkt;
	pl->next = NULL;

	pthread_mutex_lock(&mLock);

	if (!mLast) {
		mFirst = pl;
	} else {
		mLast->next = pl;
	}

	mLast = pl;
	mSize++;

	pthread_cond_signal(&mCondition);
	pthread_mutex_unlock(&mLock);

	return 0;
}

// return < 0 if aborted, 0 if got and > 0 if empty
int PacketQueue::get(AVPacket *pkt, bool block) {
	AVPacketList *pl;
	int ret = 0;

	pthread_mutex_lock(&mLock);

	for (;;) {
		if (mAbortRequest) {
			ret = -1;
			break;
		}

		pl = mFirst;
		if (pl) {
			mFirst = pl->next;
			if (!mFirst) {
				mLast = NULL;
			}
			mSize--;
			*pkt = pl->pkt;
			av_free(pl);
			ret = 0;
			break;
		} else if (!block) {
			ret = 1;
			break;
		} else {
			pthread_cond_wait(&mCondition, &mLock);
		}
	}

	pthread_mutex_unlock(&mLock);
	return ret;

}

void PacketQueue::abort() {
	pthread_mutex_lock(&mLock);
	mAbortRequest = true;
	pthread_cond_signal(&mCondition);
	pthread_mutex_unlock(&mLock);
}
