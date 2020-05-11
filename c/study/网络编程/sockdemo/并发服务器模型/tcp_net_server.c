/* TCP 文件服务器，演示代码 */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/fcntl.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <sys/wait.h>
#include <pthread.h>
#include<unistd.h>

#define DEFAULT_SVR_PORT 2828
#define FILE_MAX_LEN 64
char filename[FILE_MAX_LEN +1];

static void * handle_client(void *arg)
{
    int sock = (int)arg;
    char buff[1024];
    int len;
    printf("begin send\n");
    FILE* file = fopen(filename,"r");
    if(file == NULL)
    {
        close(sock);
        exit(-1);
    }
    //发文件名
    if(send(sock,filename,FILE_MAX_LEN,0) == -1)
    {
        perror("send file name\n");
        goto EXIT_THREAD;
    }
    printf("begin send file %s......\n",filename);
    //发送文件内容
    while(!feof(file))
    {
        len = fread(buff,1,sizeof(buff),file);
        printf("server read %s,len %d\n",filename,len);
        if(send(sock,buff,len,0) <0)
        {
            perror("send file:");
            goto EXIT_THREAD;
        }
    }

    EXIT_THREAD:
    if(file)
    {
        fclose(file);
    }
    close(sock);
}

int main(int argc,char* argv[])
{
    int sockfd,new_fd;
    //定义两个 IPv4 地址
    struct sockaddr_in my_addr;
    struct sockaddr_in their_addr;
    int numbytes;
    socklen_t sin_size;
    pthread_t cli_thread;
    unsigned short port;
    if(argc < 2)
    {
        printf("need a filename without path\n");
        exit(-1);
    }
    strncpy(filename,argv[1],FILE_MAX_LEN);
    port = DEFAULT_SVR_PORT;
    if(argc >= 3)
    {
        port =(unsigned short)atoi(argv[2]);
    }
    //第一步：建立TCP套接字 Socket
    //AF_INET ---->ip 通信
    //SOCK_STREAM --->TCP
    if((sockfd = socket(AF_INET,SOCK_STREAM,0))==-1)
    {
        perror("socket");
        exit(-1);
    }
    //第二步：设置侦听端口
    //初始化结构体，并绑定 2828 端口
    memset(&my_addr,0,sizeof(struct sockaddr));
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = htons(port);     //设置侦听端口是 2828，用 htons 转成网络序
    my_addr.sin_addr.s_addr = INADDR_ANY;       //表示任意IP地址可能通信
    //bzero(&(my_addr.sin_zero),8);
    //第三步：绑定套接字，把 socket 队列与端口关联起来
    if(bind(sockfd,(struct sockaddr*)&my_addr,sizeof(struct sockaddr))== -1)
    {
        perror("bind failed");
        goto EXIT_MAIN;
    }

    //第四步：开始在 2828端口侦听，是否有客户端发来连接
    if(listen(sockfd,10) == -1)
    {
        perror("listen failed");
        exit(-1);
    }

    printf("#@ listen port %d\n",port);
    //第五步：循环与客户端通信
    while(1)
    {
        sin_size = sizeof(struct sockaddr_in);
        printf("server waiting....\n");
        //如果有客户端建立连接，将产生一个全新的套接字 new_fd，专门用于跟这个客户端通信
        if((new_fd = accept(sockfd,(struct sockaddr *)&their_addr,&sin_size))==-1)
        {
            perror("accept failed");
            goto EXIT_MAIN;
        }
        printf("---client (ip=%s:port=%d) request \n",inet_ntoa(their_addr.sin_addr),ntohs(their_addr.sin_port));
        //生成一个线程来完成和客户端的会话，父进程继续监听
        pthread_create(&cli_thread,NULL,handle_client,&new_fd);
    }
    //第六步：关闭socket
    EXIT_MAIN:
    close(sockfd);
    return 0;
}