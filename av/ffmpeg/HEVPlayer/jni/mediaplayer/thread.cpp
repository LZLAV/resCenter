#include "thread.h"
#include "player_utils.h"

#define LOG_TAG "Thread"

Thread::Thread() {
	pthread_mutex_init(&mLock, NULL);
	pthread_cond_init(&mCondition, NULL);
}

Thread::~Thread() {
	pthread_mutex_destroy(&mLock);
	pthread_cond_destroy(&mCondition);
}

void Thread::start() {
	run (NULL);
}

void Thread::startAsync() {
	pthread_create(&mThread, NULL, startThread, this);
}

int Thread::join() {
	if (!mRunning) {
		return 0;
	}
	return pthread_join(mThread, NULL);
}

void* Thread::startThread(void* ptr) {
	Thread* thread = (Thread *) ptr;
	thread->mRunning = true;
	thread->run(ptr);
	thread->mRunning = false;
	return NULL;
}

void Thread::waitOnNotify() {
	pthread_mutex_lock(&mLock);
	pthread_cond_wait(&mCondition, &mLock);
	pthread_mutex_unlock(&mLock);
}

void Thread::notify() {
	pthread_mutex_lock(&mLock);
	pthread_cond_signal(&mCondition);
	pthread_mutex_unlock(&mLock);
}
