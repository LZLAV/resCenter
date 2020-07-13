/// 服务器的实现

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int main()
{
    int sfd = socket(AF_INET,SOCK_DGRAM,0);     //IPv4 UDP
    if(sfd ==-1)
    {
        perror("socket");
        exit(-1);
    }

    struct sockaddr_in saddr;
    bzero(&saddr,sizeof(saddr));
    saddr.sin_family = AF_INET;
    saddr.sin_port = htons(8888);
    saddr.sin_addr.s_addr = INADDR_ANY;
    if(bind(sfd,(struct sockaddr *)&saddr,sizeof(struct sockaddr))== -1)
    {
        perror("bind");
        close(sfd);
        exit(-1);
    }
    char buf[512] = {0};
    while(1)
    {
        struct sockaddr_in fromaddr;
        bzero(&fromaddr,sizeof(fromaddr));
        socklen_t fromaddrlen = sizeof(struct sockaddr);
        if(recvfrom(sfd,buf,sizeof(buf),0,(struct sockaddr*)&fromaddr,&fromaddrlen)== -1)
        {
            perror("recvfrom");
            close(sfd);
            exit(-1);
        }
        printf("receive from %s %d,the message is :%s\n",inet_ntoa(fromaddr.sin_addr),ntohs(fromaddr.sin_port),buf);
        sendto(sfd,"world",6,0,(struct sockaddr*)&fromaddr,sizeof(struct sockaddr));
    }
    close(sfd);
}