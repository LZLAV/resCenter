//服务器实现

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <ctype.h>

//定义端口号
#define portnumber 8000
#define MAX_LINE 80


//处理函数，将大写字符转换为小写字符，参数为需要转换的字符串
void my_fun(char *p)
{
    //空串
    if(p ==NULL)
    {
        return;
    }

    //判断字符，并进行转换
    for(;*p != '\0';p++)
    {
        if(*p >= 'A' && *p <= 'Z')
        {
            *p = *p -'A' +'a';
        }

    }
}

int main(void)
{
    int lfd;
    int cfd;
    int sfd;
    int rdy;

    struct sockaddr_in sin;
    struct sockaddr_in cin;

    int client[FD_SETSIZE];     //客户端连接的套接字描述符数组,系统值  1024

    int maxi;           
    int maxfd;          //最大连接数

    fd_set rset;
    fd_set allset;

    socklen_t addr_len;          //地址结构长度

    char buffer[MAX_LINE];

    int i;
    int n;
    int len;
    int opt;            //套接字选项

    char addr_p[20];

    //对 server_addr_in 结构进行赋值
    bzero(&sin,sizeof(struct sockaddr_in));     //先清零
    sin.sin_family = AF_INET;
    sin.sin_port = htons(portnumber);       //将端口号转换成网络字节序
    sin.sin_addr.s_addr = htonl(INADDR_ANY);

    //调用 socket 函数创建一个 TCP 协议套接字
    if((lfd = socket(AF_INET,SOCK_STREAM,0))==-1)
    {
        fprintf(stderr,"Socket error:%s\n\a",strerror(errno));
        exit(-1);
    }
    //设置套接字选项，使用默认选项
    setsockopt(lfd,SOL_SOCKET,SO_REUSEADDR,&opt,sizeof(opt));

    //调用bind 函数，将 serer_addr 结构绑定到 sockfd 上
    if(bind(lfd,(struct sockaddr *)(&sin),sizeof(struct sockaddr))==-1)
    {
        fprintf(stderr,"Bind error:%s\n\a",strerror(errno));
        exit(-1);
    }

    //开始监听端口，等待客户的请求
    if(listen(lfd,20) == -1)
    {
        fprintf(stderr,"Listen error:%s\n\a",strerror(errno));
        exit(-1);
    }

    printf("Acception connections .......\n");

    maxfd = lfd;            //对最大文件描述符进行初始化
    maxi = -1;

    //初始化客户端连接描述符集合
    for(i=0;i<FD_SETSIZE;i++)
    {
        client[i] = -1;
    }
    FD_ZERO(&allset);           //清空文件描述符集合
    FD_SET(lfd,&allset);        //将监听字设置在集合内

    //开始服务程序的死循环
    while(1)
    {
        rset = allset;

        //得到当前可以读的文件描述符数
        rdy = select(maxfd+1,&rset,NULL,NULL,NULL);

        if(FD_ISSET(lfd,&rset))
        {
            addr_len = sizeof(sin);
            //接受客户端的请求
            if((cfd =accept(lfd,(struct sockaddr *)(&cin),&addr_len))== -1)
            {
                fprintf(stderr,"Accept error:%s\n\a",strerror(errno));
                exit(-1);
            }

            //查找一个空闲位置
            for(i = 0;i<FD_SETSIZE;i++)
            {
                if(client[i] <= 0)
                {
                    client[i] = cfd;    //将处理该客户端的连接套接字设置到该位置
                    break;
                }
            }
            
            //太多的客户端连接，服务器拒绝请求，跳出循环
            if(i == FD_SETSIZE)
            {
                printf("too many clents");
                exit(-1);
            }

            FD_SET(cfd,&allset);        //设置连接集合
            if(cfd >maxfd)
            {
                maxfd = cfd;
            }

            if(i> maxi)
            {
                maxi = i;
            }
            if(--rdy <= 0)          //减少一个连接描述符
            {
                continue;
            }
        }
        //对每一个连接描述符做处理
        for(i=0;i<FD_SETSIZE;i++)
        {
            if((sfd = client[i])<0)
            {
                continue;
            }

            if(FD_ISSET(sfd,&rset))
            {
                n = read(sfd,buffer,MAX_LINE);
                printf("%s\n",buffer);
                if(n == 0)
                {
                    printf("the other side has been closed.\n");
                    fflush(stdout);             //刷新输出终端
                    close(sfd);

                    FD_CLR(sfd,&allset);        //清空连接描述符数组
                    client[i] = -1;
                }
                else
                {
                    //将客户端地址转换成字符串
                    inet_ntop(AF_INET,&cin.sin_addr,addr_p,sizeof(addr_p));
                    addr_p[strlen(addr_p)] ='\0';
                    //打印客户端地址和端口号
                    printf("Client Ip is %s,port is %d\n",addr_p,ntohs(cin.sin_port));

                    my_fun(buffer);     //调用大小写转换函数
                    n= write(sfd,buffer,n+1);

                    //写函数出错
                    if(n == 1)
                    {
                        exit(-1);
                    }
                }

                //如果没有可以读的套接字，退出循环
                if(--rdy <= 0)
                {
                    break;
                }
            }
        }
    }
    close(lfd);         //关闭衔接套接字
    return 0;

}
