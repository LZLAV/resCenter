#include "tcp_net_socket.h"

int tcp_init(const char* ip,int port)       //用于初始化
{
    int sfd = socket(AF_INET,SOCK_STREAM,0);        //IPv4，TCP
    if(sfd ==-1)
    {
        perror("create socket failed")
        exit(-1);
    }
    struct sockaddr_in serveraddr;
    memset(&serveraddr,0,sizeof(struct sockaddr_in));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_port = htons(port);
    serveraddr.sin_addr.s_addr = inet_addr(ip); //或 INADDR_ANY(自动生成一个)
    //将新的 socket 与指定的 ip、port 绑定
    if(bind(sfd,(struct sockaddr*)&serveraddr,sizeof(struct sockaddr))==-1)
    {
        perror("bind");
        close(sfd);
        exit(-1);
    }
    if(listen(sfd,10) == -1)    //监听它，并设置其允许最大的连接数为 10个
    {
        perror("listen failed");
        close(sfd);
        exit(-1);
    }
    return sfd;

}

int tcp_accept(int sfd)         //用于服务端的接收
{
    struct sockaddr_in clientaddr;
    memset(&clientaddr,0,sizeof(struct sockaddr));
    socklen_t addrlen = sizeof(struct sockaddr);
    int new_fd = accept(sfd,(struct sockaddr*)&clientaddr,&addrlen);
    //sfd 接受客户端连接，并创建新的 socket 为new_fd,将请求连接的客户端的 IP、port保存在结构体 clientaddr 中
    if(new_fd == -1)
    {
        perror("accept");
        close(sfd);
        exit(-1);
    }
    printf("%s %d success connect ....\n",inet_ntoa(clientaddr.sin_addr),ntohs(clientaddr.sin_port));
    return new_fd;
}

int tcp_connect(const char* ip,int port)        //用于客户端的连接
{
    int sfd = socket(AF_INET,SOCK_STREAM,0);    //向系统注册申请新的 socket
    if(sfd == -1){
        perror("create socket failed");
        exit(-1);
    }
    struct sockaddr_in serveraddr;
    memset(&serveraddr,0,sizeof(struct sockaddr_in));
    serveraddr.sin_family = AF_INET;
    serveraddr.sin_port = htons(port);
    serveraddr.sin_addr.s_addr = inet_addr(ip);
    //将 sfd 连接至指定的服务器网络地址 serveraddr
    if(connect(sfd,(struct sockaddr*)&serveraddr,sizeof(struct sockaddr)) == -1)
    {
        perror("connect failed");
        close(sfd);
        exit(-1);
    }
    return sfd;
}

void signalhandler(void)            //用于信号处理，让服务端在按下 Ctrl+c 或 Ctrl+\ 时不会退出
{
    sigset_t sigSet;
    sigemptyset(&sigSet);           //信号集
    sigaddset(&sigSet,SIGINT);
    sigaddset(&sigSet,SIGQUIT);
    sigprocmask(SIG_BLOCK,&sigSet,NULL);        //阻塞信号屏蔽集中的信号
}