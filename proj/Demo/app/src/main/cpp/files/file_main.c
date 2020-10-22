#include <unistd.h>
#include <my_err.h>
#include "file_main.h"

#ifdef __cplusplus
extern "C" {
#endif

void test() {
    int fd;
    char buf1[] = "abcdefghij";
    char buf2[] = "ABCDEFGHIJ";

    if ((fd = open("file.nohole", O_WRONLY)) < 0) {
        printf("Open Error\n");
    }

    if ((fd = creat("file.nohole", FILE_MODE)) < 0) {
        err_sys("Create Error\n");
    }

    if (write(fd, buf1, 10) != 10) {
        err_sys("buf1 write error\n");
    }

    if (lseek(fd, 16384, SEEK_SET) == -1) {
        err_sys("lseek error\n");
    }

    if (write(fd, buf2, 10) != 10) {
        err_sys("buf2 write error\n");
    }

    if (close(fd) < 0) {
        err_sys("Close Error\n");
    }
}

#ifdef __cplusplus
}
#endif