# JNI 缓存

- 使用时缓存
- 初始化时缓存



### 使用时缓存

使用 static 关键字来做使用时缓存，但这种缓存方式显然有弊端，当多个调用者同时调用时，就会出现缓存多次的情况，并且每次调用时都要检查是否缓存过了。

```c++
extern "C"
JNIEXPORT void JNICALL
Java_com_glumes_cppso_jnioperations_CacheFieldAndMethodOps_staticCacheField(JNIEnv *env, jobject instance, jobject animal) {
    static jfieldID fid = NULL; // 声明为 static 变量进行缓存
    // 两种方法都行
//    jclass cls = env->GetObjectClass(animal);
    jclass cls = env->FindClass("com/glumes/cppso/model/Animal");
    jstring jstr;
    const char *c_str;
    // 从缓存中查找
    if (fid == NULL) {
        fid = env->GetFieldID(cls, "name", "Ljava/lang/String;");
        if (fid == NULL) {
            return;
        }
    } else {
        LOGD("field id is cached");
    }
    jstr = (jstring) env->GetObjectField(animal, fid);
    c_str = env->GetStringUTFChars(jstr, NULL);
    if (c_str == NULL) {
        return;
    }
    env->ReleaseStringUTFChars(jstr, c_str);
    jstr = env->NewStringUTF("new name");
    if (jstr == NULL) {
        return;
    }
    env->SetObjectField(animal, fid, jstr);
}
```



### 初始化时缓存

使用全局变量的方式，这样再调用时，就不要再进行一次查找了，并且避免了多个线程同时调用会多次查找的情况

```c++
// 全局变量，作为缓存方法 id
jmethodID InstanceMethodCache;

// 初始化加载时缓存方法 id
extern "C"
JNIEXPORT void JNICALL
Java_com_glumes_cppso_jnioperations_CacheFieldAndMethodOps_initCacheMethodId(JNIEnv *env, jclass type) {
    jclass cls = env->FindClass("com/glumes/cppso/model/Animal");
    InstanceMethodCache = env->GetMethodID(cls, "getName", "()Ljava/lang/String;");
}
```

