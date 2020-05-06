# Swig

SWIG是Simplified Wrapper and Interface Generator的缩写，其官方站点是http://www.swig.org/。SWIG是个帮助使用C或者C++编写的软件能与其它各种高级编程语言进行嵌入联接的开发工具。SWIG能应用于各种不同类型的语言包括常用脚本编译语言例如Perl, PHP, Python, Tcl, Ruby and PHP。支持语言列表中也包括非脚本编译语言，例如C#, Common Lisp (CLISP, Allegro CL, CFFI, UFFI), Java, Modula-3, OCAML以及R，甚至是编译器或者汇编的计划应用（Guile, MzScheme, Chicken）。SWIG普遍应用于创建高级语言解析或汇编程序环境，用户接口，作为一种用来测试C/C++或进行原型设计的工具。SWIG还能够导出 XML或Lisp s-expressions格式的解析树。SWIG可以被自由使用，发布，修改用于商业或非商业中。

### 使用

1. 编写C++代码
2. 写SWIG的 i 文件
3. 使用SWIG将C++包装成JAVA类
4. 编译SO库
5. Android调用 so 库使用

#### 编写c++代码

c++的接口文件(ishapeprovider.h)

```c
//这是一个读写SHAPE数据的接口类;文件名小写测
class IShapeProvider
{
public:
    //打开一个文件或者一个数据库
    virtual void openFile(const std::string& file_name) = 0;
    //添加一个记录到文件中,其中IFeature是一个自定义接口类;
    virtual void addFeatrue(IFeature* feature) = 0;
    //设置一个属性;
    virtual void setProperty(const std::string& key, const Variant& variant) = 0;
    //打开一个图层,ITable也是一个自定义接口类
#ifndef SWIG  //这个宏是SWIG的特有的宏，告诉SWIG在处理的时候不要将此函数暴露给JAVA,对C++代码不受影响
    virtual ITable* table(const std::string& table_name) = 0;
#endif
    //获取一个图层的外包范围
    #ifdef SWIG   //对于传指针的处理方式
    %apply void &OUTPUT{ (int* x,int* y,int*with,int*height};
#endif
    virtual void extent(int* x,int* y,int*with,int*height)=0;

//获取类的信息,由于toString方法在Java中的方法冲突，所以我们需要给该函数改一个名字
#ifdef SWIG
%rename (toJavaString)  toString;//()里面是修改之后的函数名字，toString是在C++的函数名字;
#endif
    virtual std::string toString()=0;

};
```

#### 写SWIG的 i 文件

```c
%module(directors="1") dandelion_swig   //指定模块名 directors="1" 代表可以对C++的类在JAVA中继承
%{
    #include "ishapeprovider.h"   //在后面生成的dandelion_swig.cxx代码中包含的头文件
   #include "classfactory.h"
}%
  %include "ishapeprovider.h"   //将该头文件所有的类、宏定义、以及全局变量包装到JAVA中,生成对应的类
  %include "classfactory.h"  
//添加系统的一些文件，处理一些常用的基本类型，具体可以参考SWIG的帮助文档
%include stdint.i
%include carrays.i
%include windows.i
%include typemaps.i
#ifdef SWIGJAVA   //swig到java的swig预定义宏
%include <enums.swg>
%rename (toDString) toString;
#endif
//对于这种结构的定义，可以理解为改名，不改名在JAVA中是识别不了的，如智能指针
%template(JavaList) std::list<long>;
%template(IShapeProviderPtr) std::shared_ptr<IShapeProvider>;
```

> STL/C++库的转化 swig提供了很多基本类型库的转化。如std::map 可以转成java的map,std::string 转成String
>  可以在C++写接口在JAVA中实现，如要对IShapeProvider接口用java 实现，需要调用
>  `%feature("director") IShapeProvider ;`
>  一般在c++文件中，可通过宏定义加入swig的代码，这样方便管理，当接口文件多了的时候要增加或者删除某些功能可一起删除。

#### 使用SWIG将C++包装成JAVA文件

WIG生成的文件一个是CXX的C文件，以及一些JAVA的类文件，还有就是模块内的全局变量文件

##### swig脚本编写

```shell
swig -c++ -java -package com.simple.dandelion -outdir ./java_simple_wrapper/src/com/simple/dandelion -o ./java_simple_swig/src/java_dandelion_swig.cxx -Iswig_dandelion.i 
```

> -c++ 指定当前语言是C++还是C，默认是C，只有这两种，没有其他的
>
> -java 生成的包装语言,可以使其他任何一种支持的语言 如-python  -csharp
>
> -package 生成的java包名
>
> -outdir java文件的输出目录
>
> -o 输出的CXX文件的路径文件名
>
> -I i文件路径（文件名必须紧跟参数）

swig 命令执行完成之后，将在当前路径下面生成以下几个文件

> dandelion_swig_wrap.cxx  c++文件，包装文件，将C++的类的方法转成C语言的函数
>
> dandelion_swig.java 与SWIG定义中module名字同名的类
>
> dandelion_swigJni.java  c++类中的方法在此文件中转为java的静态方法，就是JAVA中的native方法
>
> 其他的JAVA类为C++中对应的类

#### 编译so

使用android stuido 新建一个包含C++支持的工程，使用CMAKE将dandelion_swig_wrap.cxx 编译为SO文件。

#### android 调用so 库使用

```java
public class JavaNatives {

    public static void init(Context context) {
        System.loadLibrary("simple");//本来模块调用的simple库
        System.loadLibrary("dandelion_swig");//swig包装的CXX文件生成的SO，加载顺序必须先加载其他库。
        ClassFactory class_factory=new ClassFactory(); //c++中的类
        IShapeProvider shape_provider=class_factory.newInstance("ShapeProvider");
        shape_provider.openFile("/sdcard/simple.shp");

    }
}
```





### 备注

#### c代码

```c
#include <time.h>
 double My_variable = 3.0;
 
 int fact(int n) {
     if (n <= 1) return 1;
     else return n*fact(n-1);
 }
 
 int my_mod(int x, int y) {
     return (x%y);
 }
 	
 char *get_time()
 {
     time_t ltime;
     time(<ime);
     return ctime(<ime);
 }
```

#### 写接口文件

```c
/* example.i */
%module example
%{
	/* Put header files here or function declarations like below */
	extern double My_variable;
	extern int fact(int n);
	extern int my_mod(int x, int y);
	extern char *get_time();
%}
     
extern double My_variable;
extern int fact(int n);
extern int my_mod(int x, int y);
extern char *get_time();
```

**或者**

```c

```

