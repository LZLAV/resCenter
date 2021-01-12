# JNI 引用

- 局部引用
- 全局引用
- 弱全局引用

### 局部引用

通过 NewLocalRef 和各种 JNI 接口创建（FindClass、NewObject、GetObjectClass和NewCharArray等）。

会阻止 GC 回收所引用的对象，不在本地函数中跨函数使用，不能跨线程使用。

函数返回后局部引用所引用的对象会被JVM 自动释放，或调用 DeleteLocalRef 释放。

##### 错误的局部引用示例

函数返回后局部引用很可能马上就会被释放掉

```c++
/*错误的局部引用*/
extern "C" JNIEXPORT jstring JNICALL Java_com_kun_jni_1callback_MainActivity_newString
        (JNIEnv *env, jobject obj, jcharArray j_char_arr, jint len) {
    jcharArray elemArray;
    jchar *chars = NULL;
    jstring j_str = NULL;
    //静态变量保存，其实不然；函数返回后局部引用很可能马上就会被释放掉
    static jclass cls_string = NULL;
    static jmethodID cid_string = NULL;

    // 注意：错误的引用缓存
    if (cls_string == NULL) {
        cls_string = env->FindClass("java/lang/String");
        if (cls_string == NULL) {
            return NULL;
        }
    }
    return j_str;
}
```



#### 管理全局引用

- EnsureLocalCapacity
- PushLocalFrame、PopLocalFrame
- NewLocalRef

任何实现 JNI 规范的 JVM，必须确保每个本地函数至少可以创建 16 个局部引用（可以理解为虚拟机默认支持创建 16 个局部引用）

##### EnsureLocalCapacity

该函数的作用确保在当前线程中创建指定数量的局部引用，如果创建成功则返回 0，否则创建失败，并抛出 OutOfMemoryError 异常。EnsureLocalCapacity 这个函数是 1.2 以上版本才提供的

为了向下兼容，在编译的时候，如果申请创建的局部引用超过了本地引用的最大容量，在运行时 JVM 会调用 FatalError 函数使程序强制退出。在开发过程当中，可以为 JVM 添加-verbose:jni参数，在编译的时如果发现本地代码在试图申请过多的引用时，会打印警告信息提示我们要注意

```c++
int len = 20;
if (env->EnsureLocalCapacity(len) < 0) {
	// 创建失败，out of memory
}
for (int i = 0; i < len; ++i) {
	jstring  jstr = env->GetObjectArrayElement(arr,i);
	// 处理 字符串
	// 创建了足够多的局部引用，这里就不用删除了，显然占用更多的内存
}
```



#####  PushLocalFrame、PopLocalFrame

PushLocalFrame 为当前函数中需要用到的局部引用创建了一个引用堆栈，（如果之前调用 PushLocalFrame 已经创建了 Frame，在当前的本地引用栈中仍然是有效的)每遍历一次调用(*env)->GetObjectArrayElement(env, arr, i);返回一个局部引用时，JVM 会自动将该引用压入当前局部引用栈中。*              

PopLocalFrame 负责销毁栈中所有的引用。

在调用 PopLocalFrame 销毁当前 frame 中的所有引用前，如果第二个参数 result 不为空，会由 result 生成一个新的局部引用，再把这个新生成的局部引用存储在上一个 frame 中

```c++
#define N_REFS 32
void local_manager(JNIEnv *env)
{
    int len = N_REFS,i;
    jstring other_jstr;
    jobjectArray   arr;

    // Use PushLocalFrame & PopLocalFrame
    for (int i = 0; i < len; ++i) {
        if (env->PushLocalFrame(N_REFS)) { // 创建指定数据的局部引用空间
            //out ot memory
        }
        jstring jstr = env->GetObjectArrayElement(arr, i);
        // 处理字符串
        // 期间创建的局部引用，都会在 PushLocalFrame 创建的局部引用空间中
        // 调用 PopLocalFrame 直接释放这个空间内的所有局部引用
        env->PopLocalFrame(NULL);

        if (i == 2) {
            other_jstr = jstr;
        }
        other_jstr = static_cast<jstring>(env->PopLocalFrame(other_jstr));  // 销毁局部引用栈前返回指定的引用
    }

}
```

使用 NewLocalRef 函数来保证工具类函数返回的总是一个局部引用类型，如下代码：

```c++
static jstring cachedString = NULL;
 if (cachedString == NULL) {
       /* create cachedString for the first time */
       jstring cachedStringLocal = ... ;
       /* cache the result in a global reference */
       cachedString =(*env)->NewGlobalRef(env, cachedStringLocal);
 }
return (*env)->NewLocalRef(env, cachedString);
```



### 全局引用

调用 NewGlobalRef 基于局部引用创建，会阻 GC 回收所引用的对象

可以跨方法、跨线程使用。

JVM 不会自动释放，必须调用 DeleteGlobalRef 手动释放

##### 全局引用示例

```c++
extern "C"
JNIEXPORT jstring JNICALL
Java_com_glumes_cppso_jnioperations_LocalAndGlobalReferenceOps_cacheWithGlobalReference(JNIEnv *env, jobject instance) {
    static jclass stringClass = NULL;
    if (stringClass == NULL) {
        jclass localRefs = env->FindClass("java/lang/String");
        if (localRefs == NULL) {
            return NULL;
        }
        stringClass = (jclass) env->NewGlobalRef(localRefs);
        env->DeleteLocalRef(localRefs);
        if (stringClass == NULL) {
            return NULL;
        }
    } else {
        printf("use stringClass cached\n");
    }
    static jmethodID stringMid = NULL;
    if (stringMid == NULL) {
        stringMid = env->GetMethodID(stringClass, "<init>", "(Ljava/lang/String;)V");
        if (stringMid == NULL) {
            return NULL;
        }
    } else {
        printf("use method cached\n");
    }
    jstring str = env->NewStringUTF("string");
    return (jstring) env->NewObject(stringClass, stringMid, str);
}
```



### 弱全局引用

 调用 NewWeakGlobalRef 基于局部引用或全局引用创建，不会阻止 GC 回收所引用的对象，可以跨方法、跨线程使用。

引用不会自动释放，在 JVM 认为应该回收它的时候（比如内存紧张的时候）进行回收而被释放。或调用DeleteWeakGlobalRef 手动释放

JVM 仍会回收弱引用所指向的对象，但弱引用本身在引用表中所占的内存永远也不会被回收

##### 弱引用使用示例

```c++
extern "C"
JNIEXPORT void JNICALL
Java_com_kun_jni_1callback_MainActivity_weakRefMethod(JNIEnv *env, jobject instance) {

    static jclass clz = NULL;
    if (clz == NULL) {
        jclass clzLocal = env->GetObjectClass(instance);
        if (clzLocal == NULL) {
            return; /* 没有找到这个类 */
        }
        clz = (jclass) env->NewWeakGlobalRef(clzLocal);
        if (clz == NULL) {
            return; /* 内存溢出 */
        }
    }
    //判断这引用是否被回收
    if (env->IsSameObject(clz, NULL)) {
        printf("clz is recycled\n");
    } else {
        printf("clz is not recycled\n");
    }
}
```

