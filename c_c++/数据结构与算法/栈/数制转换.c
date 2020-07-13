//数制转换

/* 
算法思想：
    当N>0 时重复1，2
    1. 若 N/= 0,则将 N%r 压入栈s 中，执行2；若 N =0,将栈s 的内容依次出栈，算法结束。
    2. 用N / r 代替N
*/

typedef int datatype;
void conversion(int N,int r)
{
    SeqStack s;
    datatype x;
    Init_SeqStack(&s);
    while(N)
    {
        Push_SeqStack(&s,N%r);
        N = N/r;
    }
    while(Empty_SeqStack(&s))
    {
        Pop_SeqStack(&s,&x);
        printf("%d",x);
    }
}

#define L 10
void conversion(int N,int r)
{
    int s[L],top;   //定义一个顺序栈
    int x;
    top =1;     //初始化栈
    while(N)
    {
        s[++top]  = N %r;       //余数入栈
        N=N/r;    //商作为被除数继续
    }
    while(top!= -1)
    {
        x = s[top--];
        printf("%d",x);
    }
}