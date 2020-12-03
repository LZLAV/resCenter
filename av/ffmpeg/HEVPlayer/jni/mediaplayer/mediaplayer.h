#ifndef __MEDIAPLAYER_H__
#define __MEDIAPLAYER_H__

#include <pthread.h>
#include "audio_decoder.h"
#include "video_decoder.h"
#include "framequeue.h"
#include "mp_listener.h"

enum media_player_state {
	MEDIA_PLAYER_STATE_ERROR = 0,
	MEDIA_PLAYER_IDLE,
	MEDIA_PLAYER_INITIALIZED,
	MEDIA_PLAYER_PREPARED,
	MEDIA_PLAYER_PARSED,
	MEDIA_PLAYER_VIDEO_DECODED,
	MEDIA_PLAYER_STARTED,
	MEDIA_PLAYER_PAUSED,
	MEDIA_PLAYER_STOPPED,
	MEDIA_PLAYER_PLAYBACK_COMPLETE
};

class MediaPlayer {
public:
	MediaPlayer();
	~MediaPlayer();
	int setListener(MediaPlayerListener *listener);
	int setThreadNumber(int num);
	int setLoopPlay(int loop);
	int open(char* file);
	int start();
	int pause();
	int go();
	int stop();
	int close();
	bool isPlaying();
	int getVideoWidth(int *w);
	int getVideoHeight(int *h);
	int seekTo(int msec);
	int getCurrentPosition(int *msec);
	int getDuration(int *msec);
	int getAudioParams(int *params);

private:
	int mThreadNumber;
	int mLoopPlay;
	int mNeedSeek;
	int mFrameCount;
	double mTimeStart;
	int mFrames;
	double mTimeLast;
	AVPacket mFlushPacket;

	pthread_mutex_t mLock;
	pthread_cond_t mCondition;

	media_player_state mCurrentState;

	pthread_t mDecodingThread;
	pthread_t mRenderingThread;

	MediaPlayerListener* mListener;
	AVFormatContext* mFormatContext;
	int mAudioStreamIndex;
	int mVideoStreamIndex;
	AudioDecoder* mAudioDecoder;
	VideoDecoder* mVideoDecoder;

	int mVideoWidth;
	int mVideoHeight;
	FrameQueue mFrameQueue;

	// in ms
	int64_t mDuration;
	int64_t mCurrentPosition;
	int64_t mSeekPosition;

	// in seconds
	double mTime;
	double mAudioClock;
	double mFrameLastDelay, mFrameLastPTS;

	int prepareAudio();
	int prepareVideo();

	void decodeMedia(void* ptr);
	void renderVideo(void* ptr);

	static void* startDecoding(void* ptr);
	static void* startRendering(void* ptr);

	static void videoOutput(AVFrame* frame, double pts);
	static void audioOutput(void* buffer, int buffer_size);

};

#endif
