//客户端的实现

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>

#define portnumber 8000

int main(int argc,char *argv[])
{
    int nbytes;
    int sockfd;
    char buffer[80];
    char buffer_2[80];
    struct sockaddr_in server_addr;
    struct hostent *host;

    if(argc != 2)
    {
        fprintf(stderr,"Usage:%s hostname \a\n",argv[0]);
        exit(-1);
    }

    //DNS 解析
    if((host =gethostbyname(argv[1]))== NULL)
    {
        fprintf(stderr,"Gethostname error\n");
        exit(-1);
    }

    //调用socket 函数创建一个 TCP 协议套接字
    if((sockfd = socket(AF_INET,SOCK_STREAM,0))== -1)
    {
        fprintf(stderr,"Socket Error:%s\a\n",strerror(errno));
        exit(-1);
    }

    bzero(&server_addr,sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(portnumber);
    server_addr.sin_addr.s_addr = (in_addr_t)((struct in_addr *)host->h_addr_list[0]);
    
    if(connect(sockfd,(struct sockaddr *)(&server_addr),sizeof(struct sockaddr))== -1)
    {
        fprintf(stderr,"Connect Error:%s\a\n",strerror(errno));
        exit(-1);
    }

    while(1){
        printf("Please input char:\n");
        fgets(buffer,1024,stdin);
        write(sockfd,buffer,strlen(buffer));

        if((nbytes = read(sockfd,buffer_2,81))== -1)
        {
            fprintf(stderr,"Read Error:%s\n",strerror(errno));
            exit(-1);
        }
        buffer_2[nbytes] ='\0';
        printf("Client received from Server %s\n",buffer_2);
    }

    close(sockfd);
    exit(0);

}