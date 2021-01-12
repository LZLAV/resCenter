# JNI String

#### 调用 JNI函数方式

- For C
- For C++

##### For C

(*env)->NewStringUTF(env,"Hello World!");  

//As alternative

(**env).NewStringUTF(env,"Hello World!");

##### For C++

env->NewStringUTF("Hello World!");



### 数据类型

| 基本类型 | 本机类型 |     长度/bit      |
| :------: | :------: | :---------------: |
| boolean  | jboolean | 8,无符号（1Byte） |
|   byte   |  jbyte   |         8         |
|   char   |  jchar   |        16         |
|  short   |  jshort  |        16         |
|   int    |   jint   |        32         |
|   long   |  jlong   |        64         |
|  float   |  jfloat  |        32         |
|  double  | jdouble  |        64         |
|   void   |   void   |        n/a        |

### JNI中的串处理函数

##### 新建jstring

```c++
jstring NewString(const jchar *unicodeChars, jsize len);//创建Unicode格式的jstring串
jstring NewStringUTF(const char *bytes); //创建UTF-8格式的jstring串
```

##### 获取字符串长度

```c++
jsize GetStringLength(jstring string);	//Unicode
jsize GetStringUTFLength(jstring string);	//UTF-8
```

##### jstring转化为C串及释放jstring串

如果生成串的一个副本

```c++
/***如果生成串的一个副本，isCopy参数将被置为JNI_TRUE，否则置为*NULL或者JNI_FALSE*/
const jchar* GetStringChars(jstring string, jboolean *isCopy);
const char* GetStringUTFChars(jstring string, jboolean *isCopy );
```

注：这两个函数返回一个指向特定jstring中字符顺序的指针，该指针保持有效直到下面的函数被调用：

```c++
void ReleaseStringChars(jstring string, const jchar *chars);
void ReleaseStringUTFChars(jstring string, const char *utf);
```

GetStringRegion函数将串str的一个子串**传送到**一个**字符缓存器。**该子串在位置start处开始，在len-1处结束（这样传送的字符数就是len）

```c++
void GetStringRegion(jstring str, jsize start, jsize len, jchar *buf);
void GetStringUTFRegion(jstring str, jsize start, jsize len, char *buf);
```

GetStringCritical函数**返回一个指向特定串中字符的指针**。如果有必要，复制该字符，并且函数返回时将isCopy置为JNI_TRUE，否则置为NULL 或 JNI_FALSE。在调用该函数后，直至调用 ReleaseStringCritical 之前，所使用的所有函数都无法使**当前线程被阻塞**。

```c++
const jchar* GetStringCritical(jstring string, jboolean *isCopy);
void ReleaseStringCritical(jstring string,const jchar *carray);
```

