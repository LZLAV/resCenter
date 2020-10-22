#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

#ifdef __cplusplus
extern "C" {
#endif

#define  FILE_MODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH)

void test();

#ifdef __cplusplus
}
#endif