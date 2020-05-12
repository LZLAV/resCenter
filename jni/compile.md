compile 



Compile 选项

-fexceptions

​	之前 NDK 并不支持 C++ 异常。CMake 和独立工具链默认启用 C++ 异常。

要在 ndk-build 中针对整个应用启用异常，请将下面这一行代码添加至 Application.mk 文件：

```makefile
APP_CPPFLAGS := -fexceptions
```

要针对单一 ndk-build 模块启用异常，请将下面这一行代码添加至相应模块的 Android.mk中

```makefile
LOCAL_CPP_FEATURES := exceptions
```

或者，您可以使用：

```makefile
LOCAL_CPPFLAGS := -fexceptions
```

