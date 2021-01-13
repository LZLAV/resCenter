#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netinet.h>
#include <unistd.h>

char dns_servers[1][16];    //存放 DNS 服务器的IP
int dns_server_count =0;

/**
 * DNS 报文中查询区域的查询类型
 */
#define A 1 //查询类型，表示由域名获得 IPv4地址

void ngethostbyname(unsigned char* ,int);
void changetoDnsNameFormat(unsigned char*,unsigned char*);

struct DNS_HEADER{
    unsigned short id;  //会话标识
    unsigned char rd:1; //表示期望递归
    unsigned char tc:1; //表示可截断的
    unsigned char aa:1; //表示授权回答
    unsigned char opcpde:4;
    unsigned char qr:1;     //查询/响应标识，0为查询，1为响应
    unsigned char rcode:4;  //应答码
    unsigned char cd:1;
    unsigned char ad:1;
    unsigned char z:1;  //保留值
    unsigned char ra:1; //表示可递归
    unsigned short q_count; //表示查询问题区域节的数量
    unsigned short ans_count;   //表示回答区域的数量
    unsigned short auth_count;  //表示授权区域的数量
    unsigned short add_count;   //表示附加区域的数量
};
/**
 * DNS 报文中查询问题区域
 */
struct QUESTION{
    unsigned short qtype;       //查询类型
    unsigned short qclass;  //查询类
};

typedef struct {
    unsigned char *name;
    struct QUESTION *ques;
} QUERY;

#pragma pack(push,1)        //保存对齐状态，设定为1字节对齐
struct R_DATA{
    unsigned short type;    //表示资源记录的类型
    unsigned short _class;  //类
    unsigned int ttl;       //表示资源记录可以缓存的时间
    unsigned short data_len;    //数据长度
};
#pragma pack(pop)   //恢复对齐状态

struct RES_RECORD{
    unsigned char *name;    //资源记录包含的域名
    struct R_DATA *resource;    //资源数据
    unsigned char *rdata;
};

int main(int argc,char* argv[])
{
    unsigned char hostname[100];
    unsigned char dns_servername[100];
    printf("请输入DNS服务器的IP:");
    scanf("%s",dns_servername);
    strcpy(dns_servers[0],dns_servername);
    printf("请输入要查询IP的主机名:");
    scanf("%s",hostname);

    //由域名获得 IPv4地址，A 是查询类型
    ngethostbyname(hostname,A);
    return 0;
}

/**
 * 实现DNS 查询功能
 * @param host
 * @param query_type
 */
void ngethostbyname(unsigned char *host,int query_type)
{
    unsigned char buf[65536],*qname,*render;
    int i,j,stop,s;

    struct sockaddr_in a;   //地址
    struct RES_RECORD answers[20],auth[20],addit[20];   //回答区域、授权区域、附加区域中的资源数据字段
    struct sockaddr_in dest;    //地址

    struct DNS_HEADER *dns = NULL;
    struct QUESTION *qinfo = NULL;

    printf("\n所需解析域名：%s",host);
    s = socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP); //建立分配UDP 套接字
    dest.sin_family = AF_INET;  //IPv4
    dest.sin_port = htons(53);  //53端口
    dest.sin_addr.s_addr = inet_addr(dns_servers[0]);   //DNS 服务器IP

    dns = (struct DNS_HEADER*) &buf;

    //设置DNS 报文首部
    dns->id = (unsigned short )htons(getpid()); //id设为进程标识符
    dns->qr = 0;    //查询
    dns->opcpde =0; //标准查询
    dns->aa = 0;    //不授权回答
    dns->tc = 0;    //不可截断
    dns->rd = 1;    //期望递归
    dns->ra = 0;    //不可用递归
    dns->z = 0;     //必须为 0
    dns->ad = 0;
    dns->cd = 0;
    dns->rcode = 0;     //没有差错
    dns->q_count = htons(1);    //1个问题
    dns->ans_count = 0;
    dns->auth_count = 0;
    dns->add_count = 0;

    //qname 指向查询问题区域的查询名字段
    qname = (unsigned char*) &buf(sizeof(struct DNS_HEADER));

    changetoDnsNameFormat(qname,host);  //修改域名格式
    qinfo = (struct QUESTION*) &buf[sizeof(struct DNS_HEADER) + (strlen((const char*)qname)+1)];    //qinfo 指向问题查询区域的查询类型字段
    qinfo->qtype = htons(query_type);   //查询类型为A
    qinfo->qclass = htons(1);   //查询类为1

    //向DNS服务器发送 DNS 请求报文
    printf("\n\n 发送报文中...");
    if(sendto(s,(char*) buf,sizeof(struct DNS_HEADER)+(strlen((const char*) qname) +1)+sizeof(struct QUESTION),0,(struct sockaddr*) &dest,sizeof(dest)) <0)
    {
        printf("发送失败!");
    }
    printf("发送成功");

    //从DNS 服务器接受DNS 响应报文
    i = sizeof dest;
    printf("\n 接收报文中...");
    if(recvfrom(s,(char*)buf,65536,0,(struct sockaddr*)&dest,(socklen_t*)&i)<0)
    {
        perror("接收失败!");
    }
    printf("接收成功！");

    dns = (struct DNS_HEADER*)buf;

    //将 reader 指向接收报文的回答区域
    reader = &buf[sizeof(struct DNS_HEADER)+(strlen((const char*)qname)+1)+ sizeof(struct QUESTION)];

    printf("\n\n响应报文包含:");
    printf("\n %d个问题",ntohs(dns->q_count));
    printf("\n %d个回答",ntohs(dns->ans_count));
    printf("\n %d个授权服务",ntohs(dns->auth_count));
    printf("\n %d个附加记录\n\n",ntohs(dns->add_count));

    /**
     * 解析接收报文
     */
     reader = reader + sizeof(short);   //short 类型长度为32,相当于域名字段长度，这时 reader 指向回答区域的查询类型字段
     answers[i].resource = (struct R_DATA*)(render);
     reader = reader + sizeof(struct R_DATA);   //指向回答问题区域的资源数据字段
     if(ntohs(answers[i].resource->type)== A)   //判断资源类型是否为 IPv4 地址
     {
         answers[i].rdata = (unsigned char*)malloc(ntohs(answers[i].resource->data_len));
         for(j=0;j<ntohs(answers[i].resource->data_len);j++)
         {
             answers[i].rdata[j] = reader[j];
         }
         answers[i].rdata[ntohs(answers[i].resource->data_len)]='\0';
         reader = reader +ntohs(answers[i].resource->data_len);
     }

     //显示查询结果
     if(ntohs(answers[i].resource->type) ==A)   //判断查询类型 IPv4地址
     {
         long *p;
         p = (long*)answers[i].rdata;
         a.sin_addr.s_addr = *p;
         printf("IPv4地址:%s\n",inet_ntoa(a.sin_addr));
     }
    return;
}

/*
 * 从www.baidu.com 转换到 3www5baidu3com
 */
void changetoDnsNameFormat(unsigned char* dns,unsigned char* host){
    int lock =0,i;
    strcat((char*)host,".");    //www.baidu.com.

    for(i=0;i<strlen((char*)host);i++)
    {
        if(host[i]=='.'){
            *dns++ =i -lock;
            for(;lock<i;lock++){
                *dns++ = host(lock);
            }
            lock++;
        }
    }
    *dns++ ='\0';
}
