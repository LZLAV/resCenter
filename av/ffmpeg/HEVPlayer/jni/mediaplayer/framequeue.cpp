#include "framequeue.h"
#include "player_utils.h"

#define LOG_TAG "FrameQueue"

FrameQueue::FrameQueue() {
	pthread_mutex_init(&mLock, NULL);
	pthread_cond_init(&mCondition, NULL);
	mFirst = NULL;
	mLast = NULL;
	mSize = 0;
	mAbortRequest = false;
}

FrameQueue::~FrameQueue() {
	flush();
	pthread_mutex_destroy(&mLock);
	pthread_cond_destroy(&mCondition);
}

int FrameQueue::size() {
	pthread_mutex_lock(&mLock);
	int size = mSize;
	pthread_mutex_unlock(&mLock);
	return size;
}

void FrameQueue::flush() {
	pthread_mutex_lock(&mLock);

	VideoFrame *vf, *vf1;
	for (vf = mFirst; vf != NULL; vf = vf1) {
		vf1 = vf->next;
		free(vf->yuv_data[0]);
		free(vf);
	}

	mLast = NULL;
	mFirst = NULL;
	mSize = 0;

	pthread_mutex_unlock(&mLock);
}

int FrameQueue::put(VideoFrame *vf) {
	pthread_mutex_lock(&mLock);

	if (mLast == NULL) {
		mFirst = vf;
	} else {
		mLast->next = vf;
	}

	vf->next = NULL;
	mLast = vf;
	mSize++;

	pthread_cond_signal(&mCondition);
	pthread_mutex_unlock(&mLock);
	return 0;
}

// return < 0 if aborted, 0 if got and > 0 if empty
int FrameQueue::get(VideoFrame **vf, bool block) {
	int ret = 0;

	pthread_mutex_lock(&mLock);

	for (;;) {
		if (mAbortRequest) {
			ret = -1;
			break;
		}

		*vf = mFirst;
		if (*vf) {
			mFirst = (*vf)->next;
			if (mFirst == NULL) {
				//queue empty
				mLast = NULL;
			}
			mSize--;
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

void FrameQueue::abort() {
	pthread_mutex_lock(&mLock);
	mAbortRequest = true;
	pthread_cond_signal(&mCondition);
	pthread_mutex_unlock(&mLock);
}
