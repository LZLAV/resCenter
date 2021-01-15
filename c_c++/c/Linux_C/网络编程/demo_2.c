#include<netdb.h>
#include<sys/socket.h>
#include<stdio.h>

/*
  struct hostent{
      char *h_name;     //主机规范名
      char **h_aliases; //主机的别名
      int h_addrtype;   // ip 地址的类型，ipv4(AF_INET) 该函数处理不了 ipv6
      int h_length;     // ip地址的长度
      char **h_addr_list;   //主机的ip 地址。是网络字节序，需通过 inet_ntop 函数转换
  } 
 * /

int main(int argc,char **argv)
{
    char *ptr,**pptr;
    struct hostent *hptr;
    char str[32] ={'\0'};
    //取得命令后第一个参数，即要解析的域名或主机名
    ptr = argv[1];  //例如 www.baidu.com
    //调用 gethostbyname(），结果存在 hptr 结构中
    if((hptr = gethostbyname(ptr))== NULL)
    {
        printf("gethostnbyname error for host:%s\n",ptr);
        return 0;
    }
    //将主机的规范名打出来
    printf("official hostname:%s\n",hptr->h_name);

    //主机可能有多个别名，将所有别名分别打印出来
    for(pptr = hptr->h_aliases;*pptr != NULL;pptr++)
    {
        printf(" alias:%s\n",*pptr);
    }
    //根据地址类型，将地址打出来
    switch(hptr->h_addrtype)
    {
        case AF_INET:
        case AF_INET6:
            pptr = hptr->h_addr_list;
            //将刚才得到的所有地址都打出来，其中调用了 inet_ntop()函数
            for(;*pptr != NULL;pptr++)
                printf(" address:%s\n",inet_ntop(hptr->h_addrtype,*pptr,str,sizeof(str)));
            
            printf(" first address:%s\n",inet_ntop(hptr->h_addrtype,hptr->h_addr,str,sizeof(str)));
            break;
            default:
            printf("unknown address type\n");
            break;
    }
    return 0;
}