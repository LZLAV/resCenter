#include <my_err.h>
#include "str_main.h"

#ifdef __cplusplus
extern "C" {
#endif

void tests() {
    char buf[MAXLINE];
    pid_t pid;
    int status;

    printf("%% ");
    while (fgets(buf, MAXLINE, stdin) != NULL) {
        if (buf[strlen(buf) - 1] == '\n')
            buf[strlen(buf) - 1] = 0;

        if ((pid = fork()) < 0) {
            err_sys("fork error!");
        } else if (0 == pid) {
            execlp(buf, buf, (char *) 0);    //从PATH 环境变量中查找文件并执行
            err_ret("couldn't execute: %s", buf);
            exit(127);
        }

        if (pid = waitpid(pid, &status, 0) < 0)
            /*
				wait等待第一个终止的子进程，而waitpid可以通过pid参数指定等待哪一个子进程。当pid=-1、option=0时，waitpid函数等同于wait，可以把wait看作waitpid实现的特例。

				waitpid函数提供了wait函数没有提供的三个功能：
					1、waitpid等待一个特定的进程，而wait则返回任一终止子进程的状态 。
					2、waitpid提供了一个 wait的非阻塞版本，有时希望取得一个子进程的状态， 但不想进程阻塞。
					3、waitpid支持作业控制。
			*/
            err_sys("waitpid error!");

        printf("%% ");
    }
    exit(0);
}

#ifdef __cplusplus
}
#endif