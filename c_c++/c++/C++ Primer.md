# C++ Primer

访问main 的返回值的方法依赖于系统。在UNIX 和 Windows系统中，执行完一个程序后,都可以通过echo命令获得其返回值。
在UNIX 系统中,通过如下命令获得状态:

```shell
	$ echo $?
```

在 Windows系统中查看状态可键入:

```shell
$ echo %ERRORLEVEL%
```

**读取数量不定的输入数据**

```c++
#include <iostream>
int main()
{
	int sum = 0,value =0;
	//读取数据直到遇到文件尾，计算所有读入的值的和
	while(std::cin>>value)
	{
		sum +=value;		//等价于 sum = sum+value
	}
	std::cout<< "Sum is: "<<sum<<std::endl;
	return 0;
}
```

while循环条件的求值就是执行表达式：

​	std: :cin >> value

此表达式从标准输入读取下一个数，保存在 value 中。返回其左侧运算对象，在本例中是 std:cin。因此,此循环条件实际上检测的是std.cin。

当我们使用一个istream对象作为条件时,其效果是检测流的状态。如果流是有效的，即流未遇到错误，那么检测成功。当遇到文件结束符（end-of-file)，或遇到一个无效输入时（例如读入的值不是一个整数),，istream对象的状态会变为无效。处于无效状态的istream对象会使条件变为假。

因此，我们的while循环会一直执行直至遇到文件结束符（或输入错误)。while循环体使用复合赋值运算符将当前值加到sum上。一旦条件失败，while循环将会结束。我们将执行下一条语句,打印sum的值和一个endl。

**使用文件重定向**

当你测试程序时，反复从键盘敲入这些销售记录作为程序的输入，是非常乏余做。大多数操作系统支持文件重定向，这种机制允许我们将标准输入和标准输出与命名文你关联起来:

```shell
$ addItems <infile >outfile
```

假定 $ 是操作系统提示符，我们的加法程序已经编译为名为 addItems.exe 的可执行文件(在 UNIX中是 addItems)，则上述命令会从一个名为Anfile的文伻读取销售记录，并将输出结果写入到一个名为outfile的文件中，两个文件都位于当前目录中。

**点运算符 .**

点运算只能用于类类型的对象。

**::运算符**

::运算符(::operator）作用域运算符。其用处之一是访问命名空间中的名字。例如,std::cout 表示命名空间 std中的名字cout。

**缓存区**

缓冲区（buffet一个存储区域,用于保存数据。IO设施通常将输入(或输出）数据保存在一个缓冲区中，读写缓冲区的动作与程序中的动作是无关的。我们可以显式地刷新输出缓冲，以便强制将缓冲区中的数据写入输出设备。默认情况下，读cin会刷新cout；程序非正常终止时也会刷新cout。

**Cerr**

Cerr一个 ostream 对象，关联到标准错误，通常写入到与标准输出相同的设备。默认情况下，写到 cerr的数据是不缓冲的。cerr 通常用于输出错误信息或其他不属于程序正常逻辑的输出内容。

**clog**

clog一个 ostream 对象，关联到标准错误。默认情况下，写到clog的数据是被缓冲的。clog通常用于报告程序的执行信息，存入一个日志文件中。

### 数据类型

数据类型是程序的基础：它告诉我们数据的意义以及我们能在数据上执行的操作。

C++ 定义了，基本数据类型包括：算术类型（arithmetic type） 和 空类型（void）。算术类型包含了字符、整形数、布尔值和浮点数。

|    类型     |      含义      |   最小尺寸   |
| :---------: | :------------: | :----------: |
|    bool     |    布尔类型    |    未定义    |
|    char     |      字符      |     8位      |
|   wchar_t   |     宽字符     |     16位     |
|  char16_t   |  Unicode字符   |     16位     |
|  char32_t   |  Unicode字符   |     32位     |
|    short    |     短整型     |     16位     |
|     int     |      整型      |     16位     |
|    long     |     长整型     |     32位     |
|  long long  |     长整型     |     64位     |
|    float    |  单精度浮点数  | 6位有效数字  |
|   double    |  双精度浮点数  | 10位有效数字 |
| long double | 扩展精度浮点数 | 10位有效数字 |

基本的字符类型是 char，一个 char 的空间应确保可以存放机器基本字符集中任意字符对应的数字值。也就是说，一个char 的大小和一个机器字节一样。

其他字符类型用于扩展字符集，如 wchar_t、char16_t、char32_t、wchar_t 类型用于确保可以存放机器最大扩展字符集中的任意一个字符，类型 char16_t 和 char32_t 则为 Unicode 字符集服务（Unicode 是用于表示所有自然语言中字符的标准）。

​	除字符和布尔类型之外，其他整型用于表示（可能）不同尺寸的整数。C++语言规定一个int至少和一个short 一样大，一个 long 至少和一个 int 一样大，一个 long long 至少和 一个 long 一样大。其中，数据类型  long long 是在 C++11 中新定义的。



浮点型可表示单精度、双精度和扩展精度值。C++标准指定了一个浮点数有效位数的最小值，然而大多数编译器都实现了更高的精度。通常，float 以1个字(32比特)来表示，double 以2个字（64比特）来表示，long double 以3或4个字(96或128比特）来表示。一般来说，类型float和double分别有7和16个有效位；类型longdouble则常常被用于有特殊浮点需求的硬件，它的具体实现不同,精度也各不相同。
