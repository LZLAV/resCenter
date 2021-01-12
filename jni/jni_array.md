# JNI ARRAY

### 基本类型对应的本地数组

| 基本数据类型 |   本地数组    |
| :----------: | :-----------: |
|   boolean    | jbooleanArray |
|     byte     |  jbyteArray   |
|     char     |  jcharArray   |
|    short     |  jshortArray  |
|     int      |   jintArray   |
|     long     |  jlongArray   |
|    float     |  jfloatArray  |
|    object    | jobjectArray  |
|    double    | jdoubleArray  |

### 数组操作函数

数组函数分为用于**对象**数组的数组函数和用于**基本数据类型**数组的数组函数。

GetArrayLength函数获取数组长度，可用于任意数组：

```c++
  jsize GetArrayLength(j[Type]array array);//Type用基本类型替换
```

#### 用于对象数组的函数

```c++
/*<1>创建对象数组，下面的函数创建一个长度为length，并且持有类型为elementClass的对象的对象数组，数组中的所有元素都被置为initialElement*/

jobjectArray NewObjectArray(jsize length, jclass elementClass, jobject initialElement );

  /* <2>获取数组元素，下面的函数通过Index指定的索引在array中获取一个对象，如果索引超出边界，会抛出一个IndexOutOfBoundsException*/

jobject GetObjectArrayElement(jobjectArray array, jsize Index);

   /*<3>设置元素值。下面的函数在array中通过index指定的索引处设置元素值为value，如果index超出边界，会抛出一个IndexOutOfBoundException*/

void SetObjectArrayElement(jobjectArray array, jsize index,jobject value);
```

#### 用于基本类型的数组函数

```c++
/*创建数组，下面函数创建一个包含length个元素的Java数组：*/

[ArrayType] New[Type]Array(jsize length);

/* <2>获取数组元素，下面的函数返回一个指向本机类型数组的指针，该类型与Java数据类型相对应。如果存储器从Java代码返回数组的一个副本，则参数isCopy被置为JNI_TRUE,否则置为JNI_FALSE:*/

[NativeType] *Get[Type]ArrayElements([ArrayType] array, jboolean *isCopy);

/*<3>释放数组指针。下面的函数释放从Get[Type]ArrayElements调用中获得的存储器空间。如果本机数组不是一个副本，那么模式（mode）参数可以被用来有选择的从本机数组复制存储器内容  回Java数组。模式的值以及它们的效果如下表：*/

void Release[Type]ArrayElements([ArrayType] array，[NativeType] *elems, jint mode);
```

|    mode    | Effect                                                       |
| :--------: | ------------------------------------------------------------ |
|     0      | 从本机数组复制存储器内容到Java数组，并且回收被本机数组使用的存储器 |
| JNI_COMMIT | 从本机数组复制存储器内容到Java数组,但是不回收被本机数组使用的存储器 |
| JNI_ABORT  | 不从本机数组复制存储器内容到Java数组，但是回收被本机数组使用的存储器 |

```c++
/*
其他操作
	下面的函数功能同 Get[Type]ArrayElements 很相似。但是，它只用于一个数组子集的复制操作。参数start指定了从何处复制的起始索引，参数len则指定了从数组中复制到本机数组的多个位置数量：*/

void Get[Type]ArrayRegion([ArrayType] array, jsize start, jsize len, [NativeType] *buf);

   /* 下面的函数是Get[Type]ArrayRegion的一个副本。这个函数用来复制本机数组的一段内容回Java数组中。元素一般从本机数组起始处（索引为0）开始复制，但是只是从位置start开始将len个元素复制到Java数组中：*/

void Set[Type]ArrayRegion([ArrayType] array, jsize start, jsize len, [NativeType] *buf);

   /* 下面的函数在获得数组上的锁后将返回一个句柄给数组。如果没有建立任何锁，则 isCopy 被置为 JNI_TRUE，否则置为 NULL 或JNI_FALSE*/

void *GetPrimitiveArrayCritical([ArrayType] array, jboolean *isCopy);

  /*下面的函数释放从GetPrimitiveArrayCritical调用中返回的数组*/

void ReleasePrimitiveArrayCritical([ArrayType] array, void *carray, jint mode);
```

|    mode    | Effect                                                   |
| :--------: | -------------------------------------------------------- |
|     0      | 从carray中复制值到数组中，并释放分配给carray的存储器     |
| JNI_COMMIT | 从carray中复制值到数组中，但是不释放分配给carray的存储器 |
| JNI_ABORT  | 不从carray中复制值到数组中                               |