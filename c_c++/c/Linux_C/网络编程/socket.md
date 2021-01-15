# socket

## 套接字

套接字是操作系统内核中的一个数据结构，是网络进程的 ID。在一台计算机中，端口号和进程之间是一一对应的关系，所以，使用端口号和网络地址的组合可以唯一地确定整个网络中的一个网络进程。

Linux 中的网络编程是通过 Socket 接口来进行的。Socket 是一种特殊的 I/O 接口，也是一种文件描述符。它是一种常用的进程之间通信机制，通过它不仅能实现本地机器上的进程之间的通信，而且通过网络能够在不同机器上的进程上的进程之间进行通信。

每一个 Socket 都用一个半相关描述"{协议、本地地址、本地端口}"来表示；一个完整的套接字则用一个相关描述"{协议、本地地址、本地端口、远程地址、远程端口}"来表示。

### 类型

- 流式 Socket (SOCKET_STREAM)用于 TCP 通信。流式套接字提供可靠的、面向连接的通信流；它使用 TCP 协议，从而保证数据传输的正确性和顺序性。
- 数据报 Socket(SOCK_DGRAM) 用于 UDP通信。数据报套接字定义了一种无连接的服务，数据通过相互独立的报文进行传输，是无序的，并且不保证是可靠、无差错的，它使用数据报协议 UDP。
- 原始 Socket（SOCK_RAW）用于新的网络协议实现的测试等。原始套接字允许对底层协议如 IP或 ICMP 进行直接访问，它功能强大但使用较为不便，主要用于一些协议的开发。

### Socket信息数据结构

```c
struct sockaddr{
    unsigned short sa_family;	//地址族
    char sa_data[14];		//14字节的协议地址，包含该 socket 的IP地址和端口号
};
struct sockaddr_in{
    short int sa_family;	//地址族
    unsigned short int sin_port;	//端口号
    struct in_addr sin_addr;		//IP地址
    unsigned char sin_zero[8];		//填充 0 以保持与 struct sockaddr 同样大小
};
struct in_addr{
    unsigned long int s_addr;		//32位IPv4地址，网络字节序
}
```

头文件 <netinet/in.h>中，sa_family:AF_INET 表示 IPv4 协议，sa_family:AF_INET6 表示 IPv6 协议。

### 数据存储优先顺序的转换

网络字节序都是大端模式。要把主机字节序列和网络字节序列相互对应起来，需要对这两个序列存储优先顺序进行相互转化。这里用到四个函数 --- htons()、ntohs()、htonl() 和 ntohl()，这四个函数分别实现网络字节序列和主机序列的转化，这里的 h 代表 host，n 代表 network，s代表 short，l代表 long。通常 16位的 IP 端口号用 s 代表，而  IP地址用 l 来代表。

> \#include<netinet/in.h>
>
> unsigned long int htonl(unsigned long int hostlong)

htonl 函数用于将 32 位主机字符顺序转换成网络字节顺序，返回对应的网络字符顺序

> \#include<netinet/in.h>
>
> unsigned short int htons(unsigned short int hostshort)

htons 函数用于将 16 位主机字符顺序转换成网络字节顺序，返回对应的网络字符顺序

### 地址格式转化

通常用户在表达地址时采用的是点分十进制表示的数值（或者是用冒号分开的十进制 IPv6 地址），而在通常使用的 socket 编程中使用的则是 32位的网络字节序的二进制值，这就需要将这两个数值进行转换。IPv4中用到的函数有 inet_aton()、inet_add() 和 inet_ntoa()，IPv4 和 IPv6 兼容的函数有 inet_pton() 和 inet_ntop()。

> \#include<sys/socket.h>
>
> \#include<netinet/in.h>
>
> \#include<arpa/inet.h>
>
> unsigned long int inet_addr(const char *cp)

inet_addr() 用来将参数 cp 所指的网络地址字符串转换成网络所使用的二进制数字。网络地址字符串是以数字和点组成的字符串，如"163.13.132.68"。返回值：成功则返回对应的网络二进制的数字，失败返回 -1。

> \#include<sys/socket.h>
>
> \#include<netinet/in.h>
>
> \#include<arpa/inet.h>
>
> int inet_aton(const char* cp,struct in_addr *inp)

inet_aton() 用来将参数 cp 所指的**网络地址字符串转换成网络使用的二进制的数字**，然后存于参数 inp 所指的 in_addr 结构中。结构 in_addr 定义为

> struct_addr{
>
> ​	unsigned long int s_addr;
>
> }

成功则返回非0值，失败则返回 0。

> \#include<sys/socket.h>
>
> \#include<netinet/in.h>
>
> \#include<arpa/inet.h>
>
> char* inet_ntoa(struct in_addr in)

inet_ntoa() 用来将参数 in 所指的网络二进制的数字转换成网络地址，然后将指向此网络地址字符串的指针返回

成功则返回字符串指针，失败则返回 NULL。

**见 Demo1**



### 名字地址转化

主机名与域名的区别：主机名通常在局域网里面使用，通过 /etc/hosts 文件，主机名可以解析到对应的IP;域名通常是在 Internet 上使用。

在Linux 中，有一些函数可以实现主机名和地址的转化，最常见的有 gethostbyname()、gethostbyaddr() 等，都可以实现 IPv4 和 IPv6 的地址和主机名之间的转化。

> \#include<netdb.h>
>
> struct hostnet* gethostbyname(const char* hostname)

将主机名转化成 IP地址

> \#include<netdb.h>
>
> struct hostnet* gethostbyaddr(const char* addr,size_t len,int family)

将IP地址转化为主机名



结构体为

```c
struct hostent{
    char *h_name;		//正式主机名
    char **h_aliases;	//主机别名
    int h_addrtype;		//主机ip地址类型，IPv4为 AF_INET
    int h_length;		//主机IP地址字节长度，对于 IPv4是4字节，即32位
    char **h_addr_list;	//主机的IP地址列表
}#define h_addr h_addr_list[0]		//保存的是IP 地址
```

**见demo2**

## 网络编程

使用TCP 的流程

> 服务器端
>
> socket --> bind -->listen-->accept-->recv/recvfrom-->send/sendto-->socket
>
> 客户端
>
> socket-------------------------->connect-->send/sendto-->recv/recvfrom-->socket

##### 建立 socket

> \#include<sys/types.h>
>
> \#include<sys/socket.h>
>
> int socket(int domain,int type,int protocol) 

socket() 用来建立一个新的 socket ，也就是向系统注册，通知系统建立一通信端口。参数 domain 指定使用何种的地址类型，完整的定义在 /usr/include/bits/socket.h 内。

###### domain

- PF_UNIX/PF_LOCAL/AF_UNIX/AF_LOCAL：UNIX进程通信协议
- PF_INET?AF_INET：IPv4网络协议
- PF_INET6/AF_INET6：IPv6网络协议
- PF_IPX/AF_IPX：IPX-Novell 协议
- PF_NETLINK/AF_NETLINK：核心用户接口装置
- PF_X25/AF_X25：ITU-T X.25/ISO-8208 协议
- PF_AX25/AF_AX25：业余无线 AX.25协议
- PF_ATMPVC/AF_ATMPVC：存取原始 ATM PVC
- PF_APPLETALK/AF_APPLETALK：appletalk(DDP)协议
- PF_PACKET/AF_PACKET：初级封包接口

###### type

- SOCK_STREAM：提供双向连续且可信赖的数据流，即 TCP，支持 OOB机制，在所有数据传送前必须使用 connect() 来建立连线状态
- SOCK_DGRAM：使用不连续不可信赖的数据包连接
- SOCK_SEQPACKET：提供连续可信赖的数据包连接
- SOCK_RAW：提供原始网络协议存取
- SOCK_RDM：提供可信赖的数据包连接
- SOCK_PACKET：提供和网络驱动程序直接通信

###### protocol

用来指定 socket 所使用的传输协议编号，通常此参考不用管它，设为 0 即可。

###### 返回值

成功则返回 socket 处理代码，失败返回 -1

###### 错误码

- EPROTONOSUPPORT：参数domain 指定的类型不支持参数 type 或 protocol 指定的协议
- ENFILE：核心内存不足，无法建立新的 Socket 结构
- EMFILE：进程文件表溢出，无法再建立新的 socket
- EACCESS：权限不足，无法建立 type 或 protocol 指定的协议
- ENOBUFS/ENOMEM：内存不足
- EINVAL：参数 domain/type/protocol 不合法

###### 使用示例

```c
int sfd = socket(AF_INET,SOCK_STREAM,0);
if(sfd == -1)
{
    perror("socket");
    exit(-1);
}
```

##### 绑定地址 (bind)

> \#include<sys/types.h>
>
> \#include<sys/socket.h>
>
> int bind(int sockfd,struct sockaddr *my_addr,int addrlen)

###### 函数说明

bind() 用来设置给参数 sockfd 的 Socket 一个名称。此名称由参数 my_addr 指向一 sockaddr 结构，对于不同的 socket domain 定义了一个通用的数据结构

```c
struct sockaddr
{
    unsigned short int sa_family;
    char sa_data[14];
};
```

sa_family：为调用socket() 时的 domain 参数，即 AF_xxx值

sa_data：最多使用14个字符长度

此 sockaddr 结构会因使用不同的 socket domain 而由不同结构定义，例如，使用 AF_INET domain，其 socketaddr 结构定义为

```c
struct socketaddr_in
{
    unsigned short int sin_family;
    uint16_t sin_port;
    struct in_addr sin_addr;
    unsigned char sin_zero[8];
};
struct in_addr
{
    uint32_t s_addr;
}
```

sin_family：sa_family

sin_port：使用的 port 编号

sin_addr.s_addr：IP地址

sin_zero：未使用

参数 addrlen 为 sockaddr 的结构长度

###### 返回值

成功则返回0，失败返回 -1，错误原因存于 errno 中

###### 错误码

- EBADF：参数 sockfd 非合法 Socket 处理代码
- EACCESS：权限不足
- ENOTSOCK：参数 sockfd 为一文件描述词，非 Socket

###### 示例

```c
struct sockaddr_in my_addrl;					//定义结构体变量
memset(&my_addr,0,sizeof(struct sockaddr));		//将结构体清空
//或 bzero(&my_addr,sizeof(struct sockaddr));
my_addr.sin_family = AF_INET;					//表示采用IPv4网络协议
my_addr.sin_port = htons(8888);					//表示端口号 8888，通常是大于1024的一个值
//htons() 用来将参数指定的 16位hostshort 转换成网络字符顺序
//inet_addr() 用来将IP地址字符串转换成网络所使用的二进制数字，如果为 INADDR_ANY，则表示服务器自动填充本机IP地址
my_addr.sin_addr.s_addr= inet_addr("192.168.0.101");
if(bind(sfd,(struct sockaddr*)&my_addr,sizeof(struct sockaddr))==-1)
{
    perror("bind");
    close(sfd);
    exit(-1);
}
```

注：通过将 my_addr.sin_port 置为0，函数会自动选择一个未占用的端口来使用。同样，通过将 my_addr.sin_addrs.addr 置为 INADDR_ANY，系统会自动填入本机IP 地址。

##### 监听 (listen)

listen 函数用于等待连接。

> \#include<sys/socket.h>
>
> int listen(int s,int backlog)

###### 函数说明

listen() 用来等待参数 s 的 socket 连线。参数 backlog 指定同时能处理的最大连接要求，如果连续数目达此上限则client 端将收到 ECONNREFUSED 的错误。 listen() 并未开始接收连线，只是设置 socket 为 listen 模式，真正接收 client 端连线的是 accept()。通常 listen() 会在 socket()，bind() 之后调用，接着才调用 accept()。

###### 返回值

成功则返回 0，失败返回 -1，错误原因存于 errno

###### 附加说明

listen() 只适用 SOCK_STREAM 或 SOCK_SEQPACKET 的 Socket 类型。如果 socket 为 AF_INET参数，backlog 最大值可设至 128。

###### 错误码

- EBADF：参数 sockfd 非合法 socket 处理代码
- EACCESS：权限不足
- EOPNOTSUPP：指定的 socket 并未支援 listen 模式

###### 示例

```c
if(listen(sfd,10) == -1)
{
    perror("listen");
    close(sfd);
    exit(-1);
}
```

##### 接受请求

accept() 函数用于接受 socket 连线

> \#include<sys/types.h>
>
> \#include<sys/socket.h>
>
> int accept(int s,struct sockaddr *addr,int *addrlen)

###### 函数说明

accept() 用来接受参数 s 的 Socket 连线。参数 s 的 socket 必需先经 bind()、listen() 函数处理过，当有连线进来时 accept() 会返回一个新的 socket 处理代码，往后的数据传送与读取就由新的 socket 处理，而原来参数 s 的 socket 能继续使用 accept() 来接受新的连线要求。连线成功时，参数 addr 所指的结构会被系统填入远程主机的地址数据，参数 addrlen 为 sockaddr 的结构长度。

###### 返回值

成功则返回新的 socket 处理代码，失败返回-1，错误原因存在于 errno 中

###### 错误码

- EBADF：参数 s 非合法 socket 处理代码
- EFAULT：参数 addr 指针指向无法存取的内存空间
- ENOTSOCK：参数 s 为一文件描述词，非 socket
- EOPNOTSUPP：指定的 socket 并非 SOCK_STREAM
- EPERM：防火墙拒绝此连接
- ENOBUFS：系统的缓冲内存不足
- ENOMEM：核心内存不足

accept() 函数：接受远程计算机的连接请求，建立与客户机之间的通信连接。服务器处于监听状态时，如果某时刻获得客户机的连接请求，此时并不是立即处理这个请求，而是将这个请求放在等待队列中，当系统空闲时再处理客户机的连接请求。当 accept() 函数接受一个连接时，会返回一个新的 socket 标识符，以后的数据传输和读取就要通过这个新的 socket 编号来处理，原来参数中的 socket 也可以继续使用，继续监听其他客户机的连接请求。

###### 示例

```c
struct sockaddr_in clientaddr;
memset(&clinetaddr,0,sizeof(struct sockaddr));
int addrlen = sizeof(struct sockaddr);
int new_fd = accept(sfd,(struct sockaddr*)&clientaddr,&addrlen);
if(new_fd == -1)
{
    perror("accept");
    close(sfd);
    exit(-1);
}
printf("%s %d success connect\n",inet_ntoa(clientaddr.sin_addr),ntohs(clientaddr.sin_port));
```

##### 连接服务器

connect 函数用于建立 socket 连线

> \#include<sys/types.h>
>
> \#include<sys/socket.h>
>
> int connect(int sockfd,struct sockaddr *serv_addr,int addrlen)

###### 函数说明

connect() 用来将参数 sockfd 的 socket 连至参数 serv_addr 指定的网络地址。结构 sockaddr 请参考 bind()。参数 addrlen 为 sockaddr 的结构长度

###### 返回值

成功则返回 0，失败返回 -1，错误原因存于 errno 中

###### 错误码

- EBADF：参数 sockfd 非合法 socket 处理代码
- EFAULT：参数 serv_addr 指针指向无法存取的内存空间
- ENOTSOCK：参数 sockfd 为一文件描述词，非 socket
- EISCONN：参数 sockfd 的 socket 已是连线状态
- ECONNREFUSED：连线要求被 server 端拒绝
- ETIMEDOUT：企图连线的操作超过限定时间仍未有响应
- ENETUNREACH：无法传送数据包至指定的主机
- EAFNOSUPPORT：sockaddr 结构的 sa_family 不正确
- EALREADY：socket 为不可阻断且先前的连线操作还未完成

###### 示例

```c
struct sockaddr_in seraddr;		//请求连接服务器
memset(&seraddr,0,sizeof(struct sockaddr));
seraddr.sin_family = AF_INET;
seraddr.sin_port = htons(8888);		//服务器的端口号
seraddr.sin_addr.s_addr = inet_addr("192.168.0.101");	//服务器的 IP
if(connect(sfd,(struct sockaddr*)&seraddr,sizeof(struct sockaddr)) == -1)
{
    perror("connect");
    close(fd);
    exit(-1);
}
```

##### 发送数据

send 函数用于通过 socket 传送数据

> \#include<sys/types.h>
>
> \#include<sys/socket.h>
>
> int send(int s,const void *msg,int len,unsigned int flag)

###### 函数说明

send() 用来将数据由指定的 socket 传给对方主机。参数 s 为已建立好连接的 socket；参数 msg 指向欲连线的数据内容，参数 len 则为数据长度，参数 flags 一般设为 0，其他数值定义如下：

- MSG_OOB：传送的数据以 out-of-band 送出
- MSG_DONTROUTE：取消路由表查询
- MSG_DONTWAIT：设置为不可阻断运作
- MSG_NOSIGNAL：此动作不愿被 SIGPIPE 信号中断

###### 返回值

成功则返回实际传送出去的字符数，失败返回 -1 。错误原因存在于 errno

###### 错误码

- EBADF：参数 s 非合法的 socket 处理代码
- EFAULT：参数中有一指针指向无法存取的内存空间
- ENOTSOCK：参数 s 为一文件描述词，非 socket
- EINTR：被信号中断
- EAGAIN：此操作会令进程阻断，但参数 s 的 socket 为不可阻断
- ENOBUFS：系统的缓冲内存不足
- ENOMEM：核心内存不足
- EINVAL：传给系统调用的参数不正确



sendto 函数用于通过 socket 传送数据

> \#include<sys/types.h>
>
> \#include<sys/sokcet.h>
>
> int sendto(int s,const void *msg,int len,unsigned int flags,const struct sockaddr *to,int tolen)

###### 函数说明

sendto() 用来将数据由指定的 socket 传给对方主机。参数 s 为已建好连线的 socket，如果利用 UDP 协议则不需经过连线操作；参数 msg 指向欲连线的数据内容；参数 flags 一般设为 0，详细描述请参考 send()；参数 to 用来指定欲传送的网络地址，结构 sockaddr 请参考 bind()；参数 tolen 为 sockaddr 的结果长度

###### 返回值

成功则返回实际传送出去的字符数，失败返回 -1，错误原因存在于 errno 中

###### 错误代码

- EBADF：参数 s 非法的 socket 处理代码
- EFAULT：参数中有一指针指向无法存取的内存空间
- WNOTSOCK：参数 s 为一文件描述词，非 socket
- EINTR：被信号中断
- EAGAIN：此动作会令进程阻断，但参数 s 的socket 是不可阻断的
- ENOBUFS：系统的缓冲内存不足
- EINVAL：传给系统调用的参数不正确

###### 示例

```c
if(send(new_fd,"hello",6,0) == -1)
{
    perror("send");
    close(new_fd);
    close(sfd);
    exit(-1);
}
```

##### 接收数据

recv 函数用于通过socket 接收数据

> \#include<sys/types.h>
>
> \#include<sys/socket.h>
>
> int recv(int s,void *buf,int len,unsigned int flags)

###### 函数说明

recv() 用来接收远端主机经指定的 socket 传来的数据，并把数据存到由参数 buf 指向的内存空间，参数 len为可接收数据的最大长度；参数 flags 一般设为 0。其他数值定义如下：

- MSG_OOB：接收以 out-of-band 送出的数据
- MSG_PEEK：返回来的数据并不会在系统内删除，如果再调用 recv() 会返回相同的数据内容
- MSG_WAITALL：强迫接收到 len 大小的数据后才能返回，除非有错误或信号产生
- MSG_NOSIGNAL：此操作不愿被 SIGPIPE 信号中断

###### 返回值

成功则返回接收到的字符数，失败返回 -1，错误原因存在于 errno 中

###### 错误代码

- EBADF：参数 s 非法的 socket 处理代码
- EFAULT：参数中有一指针指向无法存取的内存空间
- ENOTSOCK：参数 s 为一文件描述词，非 socket
- EINTR：被信号中断
- EAGAIN：此动作会令进程阻断，但参数 s 的socket 是不可阻断的
- ENOBUFS：系统的缓冲内存不足
- ENOMEM：核心内存不足
- EINVAL：传给系统调用的参数不正确

recvfrom 函数用于通过 socket 接收数据

> \#include<sys/types.h>
>
> \#include<sys/socket.h>
>
> int recvfrom(int s,void *buf,int len,unsigned int flags,struct sockaddr *from,int *fromlen)

###### 函数说明

recv() 用来接收远程主机经指定的 socket 传来的数据，并把数据保存到由参数 buf 指向的内存空间。参数 len 为可接收数据的最大长度；参数 flags 一般设 0，其他数值定义请参考 recv() ；参数 from 用来指定欲传送的网络地址，结构 sockaddr 请参考 bind()；参数 fromlen 为 sockaddr 的结构长度

###### 返回值

成功则返回接收到的字符数，失败则返回 -1，错误原因在于 errno中

###### 错误码

- EBADF：参数 s 非法的 socket 处理代码
- EFAULT：参数中有一指针指向无法存取的内存空间
- ENOTSOCK：参数 s 为一文件描述词，非 socket
- EINTR：被信号中断
- EAGAIN：此动作会令进程阻断，但参数 s 的socket 是不可阻断的
- ENOBUFS：系统的缓冲内存不足
- ENOMEM：核心内存不足
- EINVAL：传给系统调用的参数不正确

###### 示例

```c
char buf[512] = {0};
if(recv(new_fd,buf,sizeof(buf),0) == -1)
{
    perror("recv");
    close(new_fd);
    close(sfd);
    exit(-1);
}
puts(buf);
```

### 多路复用

select 进行多路复用。

多个套接字或多个文件之间多路复用