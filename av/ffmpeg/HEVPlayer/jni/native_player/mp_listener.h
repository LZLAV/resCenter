#ifndef __MP_LISTENER_H__
#define __MP_LISTENER_H__

#include "framequeue.h"

class MediaPlayerListener {
public:
	MediaPlayerListener();
	~MediaPlayerListener();
	void postEvent(int msg, int ext1, int ext2);
	int audioTrackWrite(void* data, int offset, int size);
	int audioTrackFlush();
	int drawFrame(VideoFrame* vf);
};

#endif
