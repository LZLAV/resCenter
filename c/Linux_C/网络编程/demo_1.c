#include<stdio.h>
#include<sys/socket.h>
#include<netinet/in.h>
#include<arpa/inet.h>

int main(){
    char ip[] = "192.168.1.101";
    struct in_addr myaddr;

    // inet_aton
    int iRet = inet_aton(ip,&myaddr);
    printf("%x\n",myaddr.s_addr);

    //inet_addr
    printf("%x\n",inet_addr(ip));

    //inet_pton
    iRet = inet_pton(AF_INET,ip,&myaddr);
    printf("%x\n",myaddr.s_addr);

    myaddr.s_addr = 0xac100ac4;
    //inet_ntoa
    printf("%s\n",inet_ntoa(myaddr));

    //inet_ntop
    inet_ntop(AF_INET,&myaddr,ip,16);
    puts(ip);
    return 0;

}