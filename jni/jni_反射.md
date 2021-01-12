# JNI  反射



### Class

#### 加载类

我们可以使用下列方法通过类定义去加载一个类。

jclass **DefineClass**(JNIEnv *env, const char *name, jobject loader,
const jbyte *buf, jsize bufLen);

- name：类的全名，必须是被UTF-8编码过的字符串。
- loader：类加载器。
- buf：包含类数据的缓冲区。这个缓冲区包含一个原始类数据，并且要求这个类在调用此方法前没有被JVM所引用。
- bufLen：缓冲区长度。
- **return**：java类对象。发生错误时返回NULL。

其可能抛出如下异常

> ClassFormatError：类格式错误。
> ClassCircularityError：类循环错误。如果一个类或接口继承了自己。
> OutOfMemoryError：内存溢出。
> SecurityException：安全性错误。如果调用者试图在Java包结构上定义一个类。

