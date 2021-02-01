## select

select系统调用的的用途是：在一段指定的时间内，监听用户感兴趣的文件描述符上可读、可写和异常等事件。

### select 机制的优势

```c
int iResult = recv(s, buffer,1024);
```

用来接收数据的，在默认的阻塞模式下的套接字里，recv会阻塞在那里，直到套接字连接上有数据可读，把数据读到buffer里后recv函数才会返回，不然就会一直阻塞在那里。

```c
int iResult = ioctlsocket(s, FIOBIO, (unsigned long *)&ul);
iResult = recv(s, buffer,1024);
```

这一次recv的调用不管套接字连接上有没有数据可以接收都会马上返回。原因就在于我们用ioctlsocket把套接字设置为非阻塞模式了。不过你跟踪一下就会发现，在没有数据的情况下，recv确实是马上返回了，但是也返回了一个错误：WSAEWOULDBLOCK，意思就是请求的操作没有成功完成。

select模型的关键是使用一种有序的方式，对多个套接字进行统一管理与调度 。

用户首先将需要进行IO操作的socket添加到select中，然后阻塞等待select系统调用返回。当数据到达时，socket被激活，select函数返回。用户线程正式发起read请求，读取数据并继续执行。

使用select以后最大的优势是用户可以在一个线程内同时处理多个socket的IO请求。用户可以注册多个socket，然后不断地调用select读取被激活的socket，即可达到在同一个线程内同时处理多个IO请求的目的。

### API 介绍与使用

```c
#include <sys/select.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
int select(int maxfdp, fd_set *readset, fd_set *writeset, fd_set *exceptset,struct timeval *timeout);
```

参数说明：

maxfdp：被监听的文件描述符的总数，它比所有文件描述符集合中的文件描述符的最大值大1，因为文件描述符是从0开始计数的；

readfds、writefds、exceptset：分别指向可读、可写和异常等事件对应的描述符集合。

timeout:用于设置select函数的超时时间，即告诉内核select等待多长时间之后就放弃等待。timeout == NULL 表示等待无限长的时间。

与select 函数相关的常见的几个宏：

```c
#include <sys/select.h>   
int FD_ZERO(int fd, fd_set *fdset);   //一个 fd_set类型变量的所有位都设为 0
int FD_CLR(int fd, fd_set *fdset);  //清除某个位时可以使用
int FD_SET(int fd, fd_set *fd_set);   //设置变量的某个位置位
int FD_ISSET(int fd, fd_set *fdset); //测试某个位是否被置位
```

### select 使用范例

```c
fd_set rset;   
int fd;   
FD_ZERO(&rset);   
FD_SET(fd, &rset);   
FD_SET(stdin, &rset);
```

当声明了一个文件描述符集后，必须用FD_ZERO将所有位置零。之后将我们所感兴趣的描述符所对应的位置位。

```c
select(fd+1, &rset, NULL, NULL,NULL);
```

调用select函数，拥塞等待文件描述符事件的到来；如果超过设定的时间，则不再等待，继续往下执行。

```c
if(FD_ISSET(fd, &rset)   
{ 
    ... 
    //do something  
}
```

select返回后，用FD_ISSET测试给定位是否置位。

### 深入理解 select 模型

理解select模型的关键在于理解fd_set,为说明方便，取fd_set长度为1字节，fd_set中的每一bit可以对应一个文件描述符fd。则1字节长的fd_set最大可以对应8个fd。

（1）执行fd_set set; FD_ZERO(&set); 则set用位表示是0000,0000。

（2）若fd＝5,执行FD_SET(fd,&set);后set变为0001,0000(第5位置为1)

（3）若再加入fd＝2，fd=1,则set变为0001,0011

（4）执行select(6,&set,0,0,0)阻塞等待

（5）若fd=1,fd=2上都发生可读事件，则select返回，此时set变为0000,0011。注意：没有事件发生的fd=5被清空。

基于上面的讨论，可以轻松得出**select模型的特点**：

（1）可监控的文件描述符个数取决与sizeof(fd_set)的值。我这边服务器上sizeof(fd_set)＝512，每bit表示一个文件描述符，则我服务器上支持的最大文件描述符是512*8=4096。据说可调，另有说虽然可调，但调整上限受于编译内核时的变量值。

（2）将fd加入select监控集的同时，还要再使用一个数据结构array保存放到select监控集中的fd，一是用于再select返回后，array作为源数据和fd_set进行FD_ISSET判断。二是select返回后会把以前加入的但并无事件发生的fd清空，则每次开始select前都要重新从array取得fd逐一加入（FD_ZERO最先），扫描array的同时取得fd最大值maxfd，用于select的第一个参数。

（3）可见select模型必须在select前循环加fd，取maxfd，select返回后利用FD_ISSET判断是否有事件发生。

### 缺点

- 单个进程可监视的fd数量被限制，即能监听端口的大小有限。一般来说这个数目和系统内存关系很大，具体数目可以cat/proc/sys/fs/file-max察看。32位机默认是1024个。64位机默认是2048.
-  对socket进行扫描时是线性扫描，即采用轮询的方法，效率较低：当套接字比较多的时候，每次select()都要通过遍历FD_SETSIZE个Socket来完成调度,不管哪个Socket是活跃的,都遍历一遍。这会浪费很多CPU时间。如果能给套接字注册某个回调函数，当他们活跃时，自动完成相关操作，那就避免了轮询，这正是epoll与kqueue做的。
- 需要维护一个用来存放大量fd的数据结构，这样会使得用户空间和内核空间在传递该结构时复制开销大。





### 带外数据

带外数据(out—of—band data)，有时也称为加速数据(expedited data)，
是指连接双方中的一方发生重要事情，想要迅速地通知对方。
这种通知在已经排队等待发送的任何“普通”(有时称为“带内”)数据之前发送。
带外数据设计为比普通数据有更高的优先级。
带外数据是映射到现有的连接中的，而不是在客户机和服务器间再用一个连接。