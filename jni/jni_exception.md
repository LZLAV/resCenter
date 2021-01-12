

# JNI Exception

为了处理以Java代码实现的方法执行中抛出的异常，或者是**以本机代码编写的方法抛出的Java异常**，JNI提供了Java异常机制的钩子程序。该机制与C/C++中常规函数实现的标准错误处理无关。JNI提供一个函数集来在本机代码中检查、分析和处理Java异常。

- ExceptionCheck
- ExceptionOccurred
- ExceptionDescribe
- ExceptionClear
- Throw 
- ThrowNew
- FatalError

### ExceptionCheck

如果一个异常已经抛出，下面的函数返回JNI_TRUE，否则返回JNI_FALSE

```c++
jboolean ExceptionCheck();/*如：当异常发生时，清理并抛出自定义异常*/
if(env->ExceptionCheck()){   
    env->ExceptionClear();//清除异常   
    env->ThrowNew(env->FindClass("java/lang/Exception"),"xx异常");
}
```



### ExceptionOccurred

ExceptionOccurred函数获取正在被抛出异常的一个本地引用。本机代码或者Java代码必须处理该异常：

```c++
jthrowable ExceptionOccurred();
```

### ExceptionDescribe

ExceptionDescribe函数打印有关刚刚被抛出到标准错误输出中的异常信息。该信息包括一个栈追踪信息：

```c++
void ExceptionDescribe();
```

### ExceptionClear

ExceptionClear函数清理一个刚刚抛出的异常：

```c++
void ExceptionClear();
```

### Throw 

Throw 函数抛出一个已经创建的异常。如果异常成功抛出，返回0；否则返回一个负值：

```c++
jint Throw(jthrowable obj);/*可以这样使用：手动抛出异常，然后在本机或Java代码中处理*/
jthrowable mException = NULL;
mException = env->ExceptionOccurred();    
if (mException != NULL) {        
	env->Throw(mException);        
    /*
    	或抛出自定义异常        
		env->ThrowNew(env->FindClass("java/lang/Exception"),"xxx异常"); 
	*/        
    //最后别忘了清除异常，不然还是会导致VM崩溃        
    env->ExceptionClear();        
    return -1;    
}
```

### ThrowNew

ThrowNew函数基于clazz创建一个异常，它应该是继承自Throwable，并且异常文本是由 msg(按照UTF-8)指定。如果异常的构造以及抛出成功，返回0；否则返回一个负值。

```c++
jint ThrowNew(jclass clazz,const char *msg);
/*如：在可能出错的地方抛出自定义异常,然后在本机代码或者Java代码中处理*/
env->ThrowNew(env->FindClass("java/lang/Exception"),"xxx异常");
```

### FatalError

FatalError函数会生成致命错误信号。一个致命错误是特指无法恢复的情况。VM在调用该函数之后将会关闭：

```c++
void FatalError(const char *msg);
```

