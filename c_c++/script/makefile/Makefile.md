把源文件编译成中间代码文件，这个动作叫做编译（compile）。然后再把大量的Object File合成执行文件，这个动作叫作链接（link）。

编译时，编译器需要的是语法的正确，函数与变量的声明的正确。对于后者，通常是你需要告诉编译器头文件的所在位置（头文件中应该只是声明，而定义应该放在C/C++文件中），只要所有的语法正确，编译器就可以编译出中间目标文件。



链接时，主要是链接函数和全局变量，所以，我们可以使用这些中间目标文件（O文件或是OBJ文件）来链接我们的应用程序。链接器并不管函数所在的源文件，只管函数的中间目标文件（Object File），在大多数时候，由于源文件太多，编译生成的中间目标文件太多，而在链接时需要明显地指出中间目标文件名，这对于编译很不方便，所以，我们要给中间目标文件打个包，在Windows下这种包叫“库文件”（Library File)，也就是 .lib 文件，在UNIX下，是Archive File，也就是 .a 文件。



源文件首先会生成中间目标文件，再由中间目标文件生成执行文件。在编译时，编译器只检测程序语法，和函数、变量是否被声明。如果函数未被声明，编译器会给出一个警告，但可以生成Object File。而在链接程序时，链接器会在所有的Object File中找寻函数的实现，如果找不到，那到就会报链接错误码（Linker Error）



Makefile里主要包含了五个东西：显式规则、隐晦规则、变量定义、文件指示和注释

- 显示规则

  明显指出，要生成的文件，文件的依赖文件，生成的命令

- 隐晦规则

  make有自动推导的功能

- 变量的定义

  Makefile中我们要定义一系列的变量，变量一般都是字符串，当Makefile被执行时，其中的变量都会被扩展到相应的引用位置上。

- 文件指示

  - 一个是在一个Makefile中引用另一个Makefile
  - 另一个是指根据某些情况指定Makefile中的有效部分，就像C语言中的预编译#if一样
  - 还有就是定义一个多行的命令

- 注释

  使用“#”字符

值得一提的是，在Makefile中的命令，必须要以[Tab]键开始。



Makefile的语法规则

target ... : prerequisites ...

command

...

...

**target** 也就是一个目标文件，可以是Object File，也可以是执行文件。还可以是一个标签（Label），对于标签这种特性，在后续的“伪目标”章节中会有叙述。

**prerequisites** 就是，要生成那个target所需要的文件或是目标。

**command** 也就是make需要执行的命令。（任意的Shell命令）



Makefile编译规则

Makefile来告诉make命令如何编译和链接这几个文件。我们的规则是：

1）如果这个工程没有编译过，那么我们的所有C文件都要编译并被链接。

2）如果这个工程的某几个C文件被修改，那么我们只编译被修改的C文件，并链接目标程序。

3）如果这个工程的头文件被改变了，那么我们需要编译引用了这个头文件的所有C文件，并链接目标程序。



Makefile规则

这是一个文件的依赖关系，也就是说，target这一个或多个的目标文件依赖于prerequisites中的文件，其生成规则定义在command中。说白一点就是说，prerequisites中如果有一个以上的文件比target文件要新的话，command所定义的命令就会被执行。这就是 Makefile的规则。也就是Makefile中最核心的内容。

示例

```makefile
edit : main.o kbd.o command.o display.o insert.o search.o files.o utils.o
		cc -o edit main.o kbd.o command.o display.o insert.o search.o files.o utils.o

main.o : main.c defs.h
	cc -c main.c

kbd.o : kbd.c defs.h command.h
	cc -c kbd.c

command.o : command.c defs.h command.h
	cc -c command.c

display.o : display.c defs.h buffer.h
	cc -c display.c

insert.o : insert.c defs.h buffer.h
	cc -c insert.c

search.o : search.c defs.h buffer.h
	cc -c search.c

files.o : files.c defs.h buffer.h command.h
	cc -c files.c

utils.o : utils.c defs.h
	cc -c utils.c

clean :
	rm edit main.o kbd.o command.o display.o insert.o search.o files.o utils.o
```

clean不是一个文件，它只不过是一个动作名字，其冒号后什么也没有，那么，make就不会自动去找文件的依赖性，也就不会自动执行其后所定义的命令。要执行其后的命令，就要在make命令后明显得指出这个lable的名字。这样的方法非常有用，我们可以在一个makefile中定义不用的编译或是和编译无关的命令，比如程序的打包，程序的备份，等等。



make的依赖性

make会一层又一层地去找文件的依赖关系，直到最终编译出第一个目标文件。在找寻的过程中，如果出现错误，比如最后被依赖的文件找不到，那么make就会直接退出，并报错，而对于所定义的命令的错误，或是编译不成功，make根本不理。





变量

```makefile
objects = main.o kbd.o command.o display.o insert.o search.o files.o utils.o
edit : $(objects)
```

make自动推导

只要make看到一个[.o]文件，它就会自动的把[.c]文件加在依赖关系中，如果make找到一个whatever.o，那么whatever.c，就会是whatever.o的依赖文件。并且 cc -c whatever.c 也会被推导出来。

```makefile
main.o : defs.h
```

自动推导出 main.c  和 命令 cc -c main.c

自动推导合并同 h文件

```makefile
objects = main.o kbd.o command.o display.o insert.o search.o files.o utils.o
edit : $(objects)
	cc -o edit $(objects)

$(objects) : defs.h
kbd.o command.o files.o : command.h
display.o insert.o search.o files.o : buffer.h
.PHONY : clean
clean :
	rm edit $(objects)
```

伪目标文件

```makefile
.PHONY : clean
clean :
```

“.PHONY”表示，clean是个伪目标文件。



清空目标文件的规则

```makefile
clean:
	rm edit $(objects)
```

更为稳健的做法是：

```makefile
.PHONY : clean
clean :
	-rm edit $(objects)
```

在rm命令前面加了一个小减号的意思就是，也许某些文件出现问题，但不要管，继续做后面的事。





Makefile的文件名

大多数的make都支持“makefile”和“Makefile”这两种默认文件名。当然，你可以使用别的文件名来书写Makefile，如果要指定特定的Makefile，你可以使用make的“- f”和“--file”参数，如：make -f Make.Linux或make --file Make.AIX。



引用其它的Makefile

在Makefile使用include关键字可以把别的Makefile包含进来。

```makefile
include <filename>
```

```makefile
include foo.make *.mk $(bar)
```

make 命令开始时，会把找寻include所指出的其它Makefile，并把其内容安置在当前的位置。如果文件都没有指定绝对路径或是相对路径的话，make会在当前目录下首先寻找，如果当前目录下没有找到，那么，make还会在下面的几个目录下找：

- 1、如果make执行时，有“-I”或“--include-dir”参数，那么make就会在这个参数所指定的目录下去寻找。
- 2、如果目录/include（一般是：/usr/local/bin或/usr/include）存在的话，make也会去找。

如果有文件没有找到的话，make会生成一条警告信息，但不会马上出现致命错误。它会继续载入其它的文件，一旦完成makefile的读取，make会再重试这些没有找到，或是不能读取的文件，如果还是不行，make才会出现一条致命信息。如果你想让make不理那些无法读取的文件，而继续执行，你可以在 include前加一个减号“-”。如：

```makefile
-include <filename>
```



make的工作方式

1. 读入所有的Makefile
2. 读入被 include 的其它Makefile
3. 初始化文件中的变量
4. 推导隐晦规则，并分析所有规则
5. 为所有的目标文件创建依赖关系链
6. 根据依赖关系，决定哪些目标要重新生成
7. 执行生成命令



书写规则

规则包含两个部分，一个是依赖关系，一个是生成目标的方法。



规则中使用通配符

make支持三各通配符：“*”，“?”和“[...]”。这是和Unix的B-Shell是相同的。

波浪号（“~”）字符在文件名中也有比较特殊的用途。如果是“~/test”，这就表示当前用户的$HOME目录下的test目录。而“~hchen /test”则表示用户hchen的宿主目录下的test目录。而在Windows或是MS-DOS 下，用户没有宿主目录，那么波浪号所指的目录则根据环境变量“HOME”而定。

```makefile
objects = *.o
```

上面这个例子，表示了，通符同样可以用在变量中。并不是说[*.o]会展开，不！objects的值就是“*.o”。如果你要让通配符在变量中展开，也就是让objects的值是所有[.o]的文件名的集合，那么，你可以这样：

```makefile
objects := $(wildcard *.o)
```

这种用法由关键字“wildcard”指出，关于Makefile的关键字，我们将在后面讨论。



文件搜寻

- VPATH
- vpath

Makefile文件中的特殊变量“VPATH”，如果没有指明这个变量，make只会在当前的目录中去找寻依赖文件和目标文件。如果定义了这个变量，那么make就会在当当前目录找不到的情况下，到所指定的目录中去找寻文件了。

```makefile
VPATH = src:../headers
```

另一个设置文件搜索路径的方法是使用make的“vpath”关键字（注意，它是全小写的），这不是变量，这是一个make的关键字，这和上面提到的那个 VPATH变量很类似，但是它更为灵活。它可以指定不同的文件在不同的搜索目录中。使用方法有三种：

1. vpath 为符合模式的文件指定搜索目录
2. vpath 清楚符合模式的文件的搜索目录
3. vpath 清楚所有已被设置好了的文件搜索目录

vapth 使用方法中的需要包含“%”字符。“%”的意思是匹配零或若干字符，例如，“%.h”表示所有以“.h”结尾的文件。指定了要搜索的文件集，而则指定了的文件集的搜索的目录。例如：

```makefile
vpath %.h ../headers
```

（如果某文件在当前目录没有找到的话）我们可以连续地使用vpath语句，以指定不同搜索策略。如果连续的vpath语句中出现了相同的，或是被重复了的，那么，make会按照vpath语句的先后顺序来执行搜索。

```makefile
vpath %.c foo
vpath % blish
vpath %.c bar
```



伪目标

