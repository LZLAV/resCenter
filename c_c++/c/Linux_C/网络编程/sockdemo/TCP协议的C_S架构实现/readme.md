### 命令行编译

编译执行

```shell
gcc -o tcp_net_server tcp_net_server.c tcp_net_socket.c
gcc -o tcp_net_client tcp_net_client.c tcp_net_socket.c

./tcp_net_server 192.168.0.164 8888
./tcp_net_client 192.168.0.164 8888
```

### 编译成so

注，可以通过

```shell
gcc -fpic -c tcp_net_socket.c -o tcp_net_socket.o
gcc -shared tcp_net_socket.o -o libtcp_net_socket.so		//生成so库文件
cp lib*.so /lib												//这样以后就可以直接使用该库了
cp tcp_net_socket.h /usr/include/
```

这样头文件包含可以用 include \<tcp_net_socket.h\> 了，以后再用到的时候就可以直接用。

```shell
gcc -o main main.c -ltcp_net_socket
//其中 main.c 要包含头文件：include <tcp_net_socket.h>
//main
```

### 编写 makefile





注：

上面的虽然可以实现多个客户端访问，但是仍然是阻塞模式的（即在一个客户访问时会阻塞其他客户的访问）。要解决这个问题，通常采用并发服务器模型。