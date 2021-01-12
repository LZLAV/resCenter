# JNI



### 字符(串)



### extern "C"

见 extern_C.md



### Android Surface通过native方式调用

见 native使用surface.c





### 常见错误

1. SIGSEGV (signal SIGSEGV: invalid address (fault address: 0x9c))

   > art::ScopedCheck::AbortF(char const*, ...) 0x00000000ef5d8eee
   > art::ScopedCheck::CheckThread(_JNIEnv*) 0x00000000ef5d8a0a

   可能是 jni 线程环境的问题：

   1. 当前线程没有 attached
   2. 使用了属于其他线程的 JNIEnv*





### 类型签名

|             类型签名             | 对应的Java类型 |
| :------------------------------: | :------------: |
|                Z                 |    boolean     |
|                B                 |      byte      |
|                C                 |      char      |
|                S                 |     short      |
|                I                 |      int       |
|                J                 |      long      |
|                F                 |     float      |
|                D                 |     double     |
|             L全类名;             |       类       |
|              [ type              |     type[]     |
| (参数类型签名,...)返回值类型签名 |    方法类型    |