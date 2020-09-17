
#include <unistd.h>
#include <fcntl.h>

/*
    .....
    sockfd = socket(AF_INET,SOCK_STREAM,0);
    iflags = fcntl(sockfd,F_GETFL,0);       //设置为非阻塞模式
    fcntl(sockfd,F_SETFL,O_NONBLOCk | iflags);
*/