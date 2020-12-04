// native_player.cpp: provides JNI functions for the C++
// media player to be used in Java code.
//
// Copyright (c) 2013 Strongene Ltd. All Right Reserved.
// http://www.strongene.com
//
// Contributors:
// Shengbin Meng <shengbinmeng@gmail.com>
//
// You are free to re-use this as the basis for your own application
// in source and binary forms, with or without modification, provided
// that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright
// notice and this list of conditions.
//  * Redistributions in binary form must reproduce the above
// copyright notice and this list of conditions in the documentation
// and/or other materials provided with the distribution.

#include <jni.h>
#include "jni_utils.h"
#include "mediaplayer.h"
#include "mp_listener.h"

#define LOG_TAG    "native_player"

static MediaPlayer *gMP;

static int MediaPlayer_open(JNIEnv *env, jobject thiz, jstring path, jint threadNum, jfloat loop) {
	const char *pathStr = env->GetStringUTFChars(path, NULL);
	int ret = gMP->open((char *)pathStr);
	env->ReleaseStringUTFChars(path, pathStr);
	gMP->setThreadNumber(threadNum);
	if (loop > 0) {
		gMP->setLoopPlay(1);
	}
	return ret;
}

static int MediaPlayer_close(JNIEnv *env, jobject thiz) {
	int ret = gMP->close();
	return ret;
}

static int MediaPlayer_start(JNIEnv *env, jobject thiz) {
	int ret = gMP->start();
	return ret;
}

static int MediaPlayer_stop(JNIEnv *env, jobject thiz) {
	int ret = gMP->stop();
	return ret;
}

static int MediaPlayer_pause(JNIEnv *env, jobject thiz) {
	int ret = gMP->pause();
	return ret;
}

static int MediaPlayer_go(JNIEnv *env, jobject thiz) {
	int ret = gMP->go();
	return ret;
}

static int MediaPlayer_seekTo(JNIEnv *env, jobject thiz, jint msec) {
	int ret = gMP->seekTo(msec);
	return ret;
}

static bool MediaPlayer_isPlaying(JNIEnv *env, jobject thiz) {
	bool ret = gMP->isPlaying();
	return ret;
}

static int MediaPlayer_getVideoWidth(JNIEnv *env, jobject thiz) {
    int w = 0;
    gMP->getVideoWidth(&w);
    return w;
}

static int MediaPlayer_getVideoHeight(JNIEnv *env, jobject thiz) {
    int h = 0;
    gMP->getVideoHeight(&h);
    return h;
}

static int MediaPlayer_getCurrentPosition(JNIEnv *env, jobject thiz) {
    int msec = 0;
    gMP->getCurrentPosition(&msec);
    return msec;
}

static int MediaPlayer_getDuration(JNIEnv *env, jobject thiz) {
    int msec = 0;
    gMP->getDuration(&msec);
    return msec;
}

static void MediaPlayer_getAudioParams(JNIEnv *env, jobject thiz, jintArray params)
{
	int p[3] = {0, 0, 0};
	gMP->getAudioParams(p);
	LOGD("audio parameters: %d %d %d \n", p[0], p[1], p[2]);
	int *nativeParams;
	nativeParams = (int*)env->GetIntArrayElements(params, NULL);
	nativeParams[0] = p[0];
	nativeParams[1] = p[1];
	nativeParams[2] = p[2];
	env->ReleaseIntArrayElements(params, nativeParams, 0);
}


static void native_init(JNIEnv *env, jobject thiz) {
	MediaPlayer* mp = new MediaPlayer();
	// create new listener and give it to MediaPlayer
	MediaPlayerListener* listener = new MediaPlayerListener();
	mp->setListener(listener);

	gMP = mp;
}


// ----------------------------------------------------------------------------

static JNINativeMethod gMethods[] = {
    {"native_open",               "(Ljava/lang/String;IF)I",          (void *)MediaPlayer_open},
    {"native_close",              "()I",                              (void *)MediaPlayer_close},
    {"native_start",              "()I",                              (void *)MediaPlayer_start},
    {"native_stop",               "()I",                              (void *)MediaPlayer_stop},
    {"native_pause",              "()I",                              (void *)MediaPlayer_pause},
    {"native_go",                 "()I",                              (void *)MediaPlayer_go},
    {"native_seekTo",             "(I)I",                             (void *)MediaPlayer_seekTo},
    {"isPlaying",           "()Z",                              (void *)MediaPlayer_isPlaying},
    {"getVideoWidth",       "()I",                              (void *)MediaPlayer_getVideoWidth},
    {"getVideoHeight",      "()I",                              (void *)MediaPlayer_getVideoHeight},
    {"getCurrentPosition",  "()I",                              (void *)MediaPlayer_getCurrentPosition},
    {"getDuration",         "()I",                              (void *)MediaPlayer_getDuration},
    {"getAudioParams", 		"([I)V",                          	(void *)MediaPlayer_getAudioParams},
    {"native_init",         "()V",            					(void *)native_init},
};

int register_player(JNIEnv *env) {
	return jniRegisterNativeMethods(env, "pku/shengbin/hevplayer/MediaPlayer", gMethods, sizeof(gMethods) / sizeof(gMethods[0]));
}
