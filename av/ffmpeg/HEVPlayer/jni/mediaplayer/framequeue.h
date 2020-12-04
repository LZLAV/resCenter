#ifndef __FRAMEQUEUE_H__
#define __FRAMEQUEUE_H__

#include <pthread.h>

struct VideoFrame {
	int width;
	int height;
	int linesize_y;
	int linesize_uv;
	double pts;
	uint8_t* yuv_data[3];
	VideoFrame *next;
};

class FrameQueue {
public:
	FrameQueue();
	~FrameQueue();

	void flush();
	int put(VideoFrame *vf);

	/* return < 0 if aborted, 0 if no packet and > 0 if packet.  */
	int get(VideoFrame **vf, bool block);

	int size();

	void abort();

private:
	VideoFrame* mFirst;
	VideoFrame* mLast;
	int mSize;
	bool mAbortRequest;
	pthread_mutex_t mLock;
	pthread_cond_t mCondition;
};

#endif
