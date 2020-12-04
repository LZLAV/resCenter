#ifndef __JNI_UTILS_H__
#define __JNI_UTILS_H__

#include <stdlib.h>
#include <jni.h>
#include <android/log.h>

#define ENABLE_LOGD 0

#if ENABLE_LOGD
#define LOGD(...)  __android_log_print(ANDROID_LOG_DEBUG,LOG_TAG,__VA_ARGS__)
#else
#define LOGD(...)
#endif
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR,LOG_TAG,__VA_ARGS__)

int jniThrowException(JNIEnv* env, const char* className, const char* msg);
int jniRegisterNativeMethods(JNIEnv* env, const char* className, const JNINativeMethod* gMethods, int numMethods);

JNIEnv* getJNIEnv();
void detachJVM();

uint32_t getms();

#endif /* __JNI_UTILS_H__ */
