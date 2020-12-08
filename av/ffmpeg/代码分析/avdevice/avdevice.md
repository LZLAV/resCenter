## AVDevice

FFmpeg中有一个和多媒体设备交互的类库：Libavdevice。使用这个库可以读取电脑（或者其他设备上）的多媒体设备的数据，或者输出数据到指定的多媒体设备上。

#### 使用libavdevice

- 引入头文件和注册
- 使用

##### 引入头文件和注册

```c
#include "libavdevice/avdevice.h"		//头文件
avdevice_register_all();	//注册
```

##### 使用

使用libavdevice的时候，唯一的不同在于需要首先查找用于输入的设备。在这里使用av_find_input_format()完成：

```c
AVFormatContext *pFormatCtx = avformat_alloc_context();
AVInputFormat *ifmt=av_find_input_format("vfwcap");
avformat_open_input(&pFormatCtx, 0, ifmt,NULL);
```

上述代码首先指定了vfw设备作为输入设备，然后在URL中指定打开第0个设备（在我自己计算机上即是摄像头设备）。
在Windows平台上除了使用vfw设备作为输入设备之外，还可以使用DirectShow作为输入设备：

```shell
AVFormatContext *pFormatCtx = avformat_alloc_context();
AVInputFormat *ifmt=av_find_input_format("dshow");
avformat_open_input(&pFormatCtx,"video=Integrated Camera",ifmt,NULL) ;
```

##### 注意

1. URL的格式是"video={设备名称}"，但是设备名称外面不能加引号。例如在上述例子中URL是"video=Integrated Camera"，而不能写成"video=\"Integrated Camera\""，否则就无法打开设备。这与直接使用ffmpeg.exe打开dshow设备（命令为： ffmpeg -list_options true -f dshow -i video="Integrated Camera"）有很大的不同。

2. Dshow的设备名称必须要提前获取，在这里有两种方法：

   1. 通过FFmpeg编程实现

      ```c
      void show_dshow_device(){
      	AVFormatContext *pFormatCtx = avformat_alloc_context();
      	AVDictionary* options = NULL;
      	av_dict_set(&options,"list_devices","true",0);
      	AVInputFormat *iformat = av_find_input_format("dshow");
      	printf("Device Info=============\n");
      	avformat_open_input(&pFormatCtx,"video=dummy",iformat,&options);
      	printf("========================\n");
      }
      ```

      上述代码实际上相当于输入了下面一条命令：

      ```shell
      ffmpeg -list_devices true -f dshow -i dummy
      ```

   2. 自己去系统中看

      在Linux平台上可以使用video4linux2打开视频设备；在MacOS上，可以使用avfoundation打开视频设备。



```c
//Show Dshow Device
void show_dshow_device(){
	AVFormatContext *pFormatCtx = avformat_alloc_context();
	AVDictionary* options = NULL;
	av_dict_set(&options,"list_devices","true",0);
	AVInputFormat *iformat = av_find_input_format("dshow");
	printf("========Device Info=============\n");
	avformat_open_input(&pFormatCtx,"video=dummy",iformat,&options);
	printf("================================\n");
}
 
//Show Dshow Device Option
void show_dshow_device_option(){
	AVFormatContext *pFormatCtx = avformat_alloc_context();
	AVDictionary* options = NULL;
	av_dict_set(&options,"list_options","true",0);
	AVInputFormat *iformat = av_find_input_format("dshow");
	printf("========Device Option Info======\n");
	avformat_open_input(&pFormatCtx,"video=Integrated Camera",iformat,&options);
	printf("================================\n");
}
 
//Show VFW Device
void show_vfw_device(){
	AVFormatContext *pFormatCtx = avformat_alloc_context();
	AVInputFormat *iformat = av_find_input_format("vfwcap");
	printf("========VFW Device Info======\n");
	avformat_open_input(&pFormatCtx,"list",iformat,NULL);
	printf("=============================\n");
}
 
//Show AVFoundation Device
void show_avfoundation_device(){
    AVFormatContext *pFormatCtx = avformat_alloc_context();
    AVDictionary* options = NULL;
    av_dict_set(&options,"list_devices","true",0);
    AVInputFormat *iformat = av_find_input_format("avfoundation");
    printf("==AVFoundation Device Info===\n");
    avformat_open_input(&pFormatCtx,"",iformat,&options);
    printf("=============================\n");
}


_main(){
    ...
    //Windows
    #ifdef _WIN32

        //Show Dshow Device
        show_dshow_device();
        //Show Device Options
        show_dshow_device_option();
        //Show VFW Options
        show_vfw_device();

    #if USE_DSHOW
        AVInputFormat *ifmt=av_find_input_format("dshow");
        //Set own video device's name
        if(avformat_open_input(&pFormatCtx,"video=Integrated Camera",ifmt,NULL)!=0){
            printf("Couldn't open input stream.\n");
            return -1;
        }
    #else
        AVInputFormat *ifmt=av_find_input_format("vfwcap");
        if(avformat_open_input(&pFormatCtx,"0",ifmt,NULL)!=0){
            printf("Couldn't open input stream.\n");
            return -1;
        }
    #endif
    #elif defined linux
        //Linux
        AVInputFormat *ifmt=av_find_input_format("video4linux2");
        if(avformat_open_input(&pFormatCtx,"/dev/video0",ifmt,NULL)!=0){
            printf("Couldn't open input stream.\n");
            return -1;
        }
    #else
        show_avfoundation_device();
        //Mac
        AVInputFormat *ifmt=av_find_input_format("avfoundation");
        //Avfoundation
        //[video]:[audio]
        if(avformat_open_input(&pFormatCtx,"0",ifmt,NULL)!=0){
            printf("Couldn't open input stream.\n");
            return -1;
        }
    #endif
    ...
}

```

#### 屏幕录制

在Windows系统使用libavdevice抓取屏幕数据有两种方法：gdigrab和dshow。下文分别介绍。
1. gdigrab
  gdigrab是FFmpeg专门用于抓取Windows桌面的设备。非常适合用于屏幕录制。它通过不同的输入URL支持两种方式的抓取：
  （1）“desktop”：抓取整张桌面。或者抓取桌面中的一个特定的区域。
  （2）“title={窗口名称}”：抓取屏幕中特定的一个窗口（目前中文窗口还有乱码问题）。
  gdigrab另外还支持一些参数，用于设定抓屏的位置：
  offset_x：抓屏起始点横坐标。
  offset_y：抓屏起始点纵坐标。
  video_size：抓屏的大小。
  framerate：抓屏的帧率。

  ```c
  //Use gdigrab
  AVDictionary* options = NULL;
  //Set some options
  //grabbing frame rate
  //av_dict_set(&options,"framerate","5",0);
  //The distance from the left edge of the screen or desktop
  //av_dict_set(&options,"offset_x","20",0);
  //The distance from the top edge of the screen or desktop
  //av_dict_set(&options,"offset_y","40",0);
  //Video frame size. The default is to capture the full screen
  //av_dict_set(&options,"video_size","640x480",0);
  AVInputFormat *ifmt=av_find_input_format("gdigrab");
  if(avformat_open_input(&pFormatCtx,"desktop",ifmt,&options)!=0){
  	printf("Couldn't open input stream.（无法打开输入流）\n");
   	return -1;
  }
  ```

2. dshow
  使用dshow抓屏需要安装抓屏软件：screen-capture-recorder

  ```c
  AVInputFormat *ifmt=av_find_input_format("dshow");
  if(avformat_open_input(&pFormatCtx,"video=screen-capture-recorder",ifmt,NULL)!=0){
  	printf("Couldn't open input stream.（无法打开输入流）\n");
  	return -1;
  }
  ```

  