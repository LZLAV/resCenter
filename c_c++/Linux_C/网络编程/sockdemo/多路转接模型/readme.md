### 多路转接模型



select 函数用于 I/O 多路机制

> \#include<sys/time.h>
>
> \#include<sys/types.h>
>
> \#include<unistd.h>
>
> int select(int n,fd_set *readfds,fd_set *writefds,fd_set\* exceptfds,struct timeval\* timeout )

###### 函数说明

select() 用来等待文件描述词状态的改变。

参数n代表最大的文件描述词加 1；

参数 readfds、writefds 和 exceptfds称为描述词组，用来回传该描述词的读、写或例外的状况。下面的宏提供了处理这三种描述词组的方式。

- FD_CLR(int fd,fd_set* set)：用来清除描述词组 set 中相关的 fd 的位
- FD_ISSET(int fd,fd_set* set)：用来测试描述词组 set 中相关 fd 的位是否为真
- FD_SET(int fd,fd_set *set)：用来设置描述词组 set 中相关 fd 的位
- FD_ZERO(fd_set *set)：用来清除描述词组 set 的全部位

参数timeout 为结构 timeval，用来设置 select() 的等待时间，其结构定义为：

```c
struct timeval
{
	time_t tv_sec;
	time_t tv_usec;
};
```

###### 返回值

如果参数 timeout 设为 NULL，则表示 select() 没有 timeout

###### 错误代码

执行成功则返回文件描述词状态已改变的个数，如果返回 0代表在描述词状态改变前已超过 timeout 时间，当有错误发生时则返回 -1，错误原因存于 errno，此时参数 readfds、writefds、exceptfds和timeout 的值变成不可预测的

- EBADF：文件描述词为无效的或该文件已关闭
- EINTR：此调用被信号中断
- EINVAL：参数 n 为负值
- ENOMEM：核心内存不足

###### 示例

```c
fs_set readset;
FD_ZERO(&readset);
FD_SET(fd,&readset);
select(fd+1,&readset,NULL,NULL,NULL);
if(FD_ISSET(fd,readset){....}
```

