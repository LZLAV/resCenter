### TLS

线程本地存储（Thread Local Storage）。在多线程模式下，有些变量需要支持每个线程独享一份的功能。这种每线程独享的变量放到每个线程专有的存储区域，所以称为线程本地存储（Thread Local Storage）或者线程私有数据（Thread Specific Data）。

Linux下支持两种方式定义和使用TLS变量，具体如下表：

| 定义方式               | 支持层次   | 访问方式                                                     |
| :--------------------- | ---------- | ------------------------------------------------------------ |
| __thread关键字         | 语言层面   | 与全局变量完全一样                                           |
| pthread_key_create函数 | 运行库层面 | pthread_get_specific和pthread_set_specific对线程变量进行读写 |

_thread关键字是gcc对C语言的扩展，不是C语言标准定义的。





```c++
pthread_key_create(&key, NULL);
pthread_setspecific(index, value);
pthread_getspecific(index);
```

