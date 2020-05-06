## socket

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