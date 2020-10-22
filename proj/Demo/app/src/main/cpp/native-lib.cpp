#include <jni.h>
#include <string>
#include "str_main.h"

extern "C" JNIEXPORT jstring JNICALL
Java_com_lzlbuilder_demo_natives_NativeString_stringFromJNI(
        JNIEnv* env,
        jclass thiz) {
    std::string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}
extern "C"
JNIEXPORT void JNICALL
Java_com_lzlbuilder_demo_natives_NativeString_stringMain(JNIEnv *env, jclass clazz) {

}