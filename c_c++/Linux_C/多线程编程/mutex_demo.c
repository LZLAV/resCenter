#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>

void fun_thread1(char *msg);
void fun_thread2(char *msg);

int g_value = 1;
pthread_mutex_t mutex;

//in the thread individual,the thread reset the g_value to 0,and add to 5 int the thread1,add to 6 in the thread2
int main(int argc,char *argv[])
{
    pthread_t thread1;
    pthread_t thread2;

    if(pthread_mutex_init(&mutex,NULL) != 0)        //互斥量初始化
    {
        printf("Init mutex error\n");
        exit(-1);
    }

    if(pthread_create(&thread1,NULL,(void *)fun_thread1,NULL)!= 0)
    {
        printf("Init thread1 error!");
        exit(-1);
    }
    if(pthread_create(&thread2,NULL,(void *)fun_thread2,NULL)!= 0)
    {
        printf("Init thread2 error.")
        exit(-1);
    }

    sleep(1);
    printf("I am main thread,g_value is %d.\n",g_value);
    return 0;
}

void fun_thread1(char *msg)
{
    int val;
    val = pthread_mutex_lock(&mutex);       //lock the mutex
    if(val!=0)
    {
        printf("lock error!");
    }
    g_value =0; //reset the g_value to 0,after that add it to 5
    printf("thread 1 locked,init the g_value to 0,and add 5.\n");
    g_value +=5;
    printf("the g_value is %d.\n",g_value);
    pthread_mutex_unlock(&mutex);       //unlock the mutex
    printf("thread 1 unlocked.\n");
}


void fun_thread2(char *msg)
{
    int val;
    val = pthread_mutex_lock(&mutex);       //lock the mutex
    if(val!=0)
    {
        printf("lock error!");
    }
    g_value =0; //reset the g_value to 0,after that add it to 5
    printf("thread 1 locked,init the g_value to 0,and add 5.\n");
    g_value +=6;
    printf("the g_value is %d.\n",g_value);
    pthread_mutex_unlock(&mutex);       //unlock the mutex
    printf("thread 1 unlocked.\n");
}