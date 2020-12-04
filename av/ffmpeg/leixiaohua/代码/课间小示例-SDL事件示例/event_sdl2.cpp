/**
 * 最简单的SDL2播放视频的例子（SDL2播放RGB/YUV）
 * Simplest Video Play SDL2 (SDL2 play RGB/YUV) 
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 *
 * 本程序使用SDL2播放RGB/YUV视频像素数据。SDL实际上是对底层绘图
 * API（Direct3D，OpenGL）的封装，使用起来明显简单于直接调用底层
 * API。
 *
 * This software plays RGB/YUV raw video data using SDL2.
 * SDL is a wrapper of low-level API (Direct3D, OpenGL).
 * Use SDL is much easier than directly call these low-level API.  
 */

#include <stdio.h>

extern "C"
{
#include "sdl/SDL.h"
};

//Refresh Event
#define REFRESH_EVENT  (SDL_USEREVENT + 1)

int thread_exit=0;
int thread_pause=0;

int refresh_video(void *opaque){
	while (1) {
		if(thread_pause==0){
		SDL_Event event;
		event.type = REFRESH_EVENT;
		SDL_PushEvent(&event);
		}
		SDL_Delay(1000);
	}
	return 0;
}

int main(int argc, char* argv[])
{
	if(SDL_Init(SDL_INIT_VIDEO)) {  
		printf( "Could not initialize SDL - %s\n", SDL_GetError()); 
		return -1;
	} 

	SDL_Window *screen; 
	//SDL 2.0 Support for multiple windows
	screen = SDL_CreateWindow("Simplest Video Play SDL2", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
		500, 500,SDL_WINDOW_OPENGL|SDL_WINDOW_RESIZABLE);
	if(!screen) {  
		printf("SDL: could not create window - exiting:%s\n",SDL_GetError());  
		return -1;
	}
	SDL_Thread *refresh_thread = SDL_CreateThread(refresh_video,NULL,NULL);
	SDL_Event event;
	
	while(1){
		//Wait
		SDL_WaitEvent(&event);
		//printf("Event trigger!\n");
		if(event.type==REFRESH_EVENT){
			printf("Receiveing REFRESH_EVENT\n");
		}else if(event.type==SDL_KEYDOWN){
			//Pause
			if(event.key.keysym.sym==SDLK_SPACE)
				thread_pause=!thread_pause;
				//printf("Key SPACE has been pressed!!\n");
			/*
			else if(event.key.keysym.sym==SDLK_a)
				printf("Key a has been pressed!!\n");
			else if(event.key.keysym.sym==SDLK_b)
				printf("Key b has been pressed!!\n");
				*/
		}
	}
	SDL_Quit();
	return 0;
}
