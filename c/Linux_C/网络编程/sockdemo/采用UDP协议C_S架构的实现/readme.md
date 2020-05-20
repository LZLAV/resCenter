### 采用UDP 协议 C/S 架构的实现

UDP通信流程

服务端：socket -> bind -> recvfrom -> sendto -> close

客户端：socket -> sendto -> recvfrom -> close