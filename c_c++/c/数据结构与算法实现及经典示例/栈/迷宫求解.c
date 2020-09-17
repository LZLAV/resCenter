#define m 6 /* 迷宫的实际行*/
#define n 8 /* 迷宫的实际列*/
int maze [m+2][n+2] ;       //是否走过

typedef struct
{
    int x , y , d ;/* 横纵坐标及方向*/
}datatype ;     //实际路径

typedef struct
{ 
    int x,y;
} item ;
item move[8] ;  //搜索方向，恒定+- 1

int path(maze,move)
{
    SeqStack s;
    datatype temp;
    int x, y, d, i, j;
    temp.x=1 ; temp.y=1 ; temp.d=-1;
    Push-_SeqStack (s，temp) ;
    while (! Empty_SeqStack (s) )
    {   
        // Pop_SeqStack (s,＆temp) ;
        x=temp.x ; y=temp.y ; d=temp.d+1;
        while (d<8)
        { 
            i=x+move[d].x;  
            j=y+move[d].y;

            if ( maze[i][j]== 0 )       //未走过
            { 
                temp={x, y, d} ;
                Push_SeqStack ( s, temp ) ;
                x=i ; y=j ; maze[x][y]= -1 ;    //表明已经走过
                if (x==m&&y= =n)    //已经走到出口
                    return 1 ; /*迷宫有路*/
                else d=0 ;  //下一个节点
            }
            else 
                d++ ;
        } /*while (d<8)*/
    } /*while */
    return 0 ;/*迷宫无路*/
}