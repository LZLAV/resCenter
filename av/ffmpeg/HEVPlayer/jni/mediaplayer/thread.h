#ifndef __THREAD_H__
#define __THREAD_H__

#include <pthread.h>

class Thread {
public:
	Thread();
	virtual ~Thread();

	void start();
	void startAsync();
	int join();

	void waitOnNotify();
	void notify();
	virtual void stop() = 0;

protected:
	bool mRunning;

	virtual void run(void* ptr) = 0;

private:
	pthread_t mThread;
	pthread_mutex_t mLock;
	pthread_cond_t mCondition;

	static void* startThread(void* ptr);
};

#endif //__THREAD_H__
