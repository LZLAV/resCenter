/// 多进程并发模型
#include<stdio.h>
#include<stdlib.h>
#include "tcp_net_socket.h"

int main(int argc,char* argv[])
{
    if(argc < 3)
    {
        printf("usage:./servertcp ip port\n");
        exit(-1);
    }
    int sfd = tcp_init(argv[1],atoi(argv[2]));
    char buf[512] = {0};
    while(1)
    {
        int cfd = tcp_accept(sfd);
        if(fork() == 0)         //fork 一个子进程
        {
            recv(cfd,buf,sizeof(buf),0);
            puts(buf);
            send(cfd,"hello",6,0);
            close(cfd);
        }
        else
        {
            close(cfd);
        }
    }
    close(sfd);
}