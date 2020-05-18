
//Android  Log 日志
#include <jni.h>
-llog
#define LOGI(...)  __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...)  __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)




//jni  抛java 异常
-fexception
#include <jni.h>
static const char* JAVA_LANG_IOEXCEPTION = "java/lang/IOException";
static const char* JAVA_LANG_OUTOFMEMORYERROR = "java/lang/OutOfMemoryError";
static void ThrowException(JNIEnv* env, const char* className, const char* message) {
	// Get the exception class
	jclass clazz = env->FindClass(className);

	// If exception class is found
	if (0 != clazz) {
		// Throw exception
		env->ThrowNew(clazz, message);

		// Release local class reference
		env->DeleteLocalRef(clazz);
	}
}
