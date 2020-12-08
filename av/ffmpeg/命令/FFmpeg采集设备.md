## FFmpeg采集设备

#### 列设备

```shell
ffmpeg -list_devices true -f dshow -i dummy
```

列表显示设备的名称很重要，输入的时候都是使用“-f dshow -i video="{设备名}"”的方式。

#### 获取摄像头数据（保存为本地文件或者发送实时流）

##### 编码为H.264，保存为本地文件

```shell
ffmpeg -f dshow -i video="Integrated Camera" -vcodec libx264 mycamera.mkv
```

##### 直接播放摄像头的数据

```shell
ffplay -f dshow -i video="Integrated Camera"
```

注：除了使用DirectShow作为输入外，使用VFW也可以读取到摄像头的数据，例如下述命令可以播放摄像头数据：

```shell
ffplay -f vfwcap -i 0
```

此外，可以使用FFmpeg的list_options查看设备的选项：

```shell
ffmpeg -list_options true -f dshow -i video="Integrated Camera"
```

可以通过输出信息设置摄像头的参数。

设置摄像头分辨率为 1280x720

```shell
ffplay -s 1280x720 -f dshow -i video="Integrated Camera"
```

##### 编码为H.264，发布UDP

获取摄像头数据->编码为H.264->封装为UDP并发送至组播地址。

```shell
ffmpeg -f dshow -i video="Integrated Camera" -vcodec libx264 -preset:v ultrafast -tune:v zerolatency -f h264 udp://233.233.233.223:6666
```

注1：考虑到提高libx264的编码速度，添加了-preset:v ultrafast和-tune:v zerolatency两个选项。

注2：高分辨率的情况下，使用UDP可能出现丢包的情况。为了避免这种情况，可以添加–s 参数（例如-s 320x240）调小分辨率。

##### 编码为H.264，发布RTP

获取摄像头数据->编码为H.264->封装为RTP并发送至组播地址。

```shell
ffmpeg -f dshow -i video="Integrated Camera" -vcodec libx264 -preset:v ultrafast -tune:v zerolatency -f rtp rtp://233.233.233.223:6666>test.sdp
```

注2：结尾添加“>test.sdp”可以在发布的同时生成sdp文件。该文件可以用于该视频流的播放。

##### 编码为H.264，发布RTMP

获取摄像头数据->编码为H.264->并发送至RTMP服务器。

```shell
ffmpeg -f dshow -i video="Integrated Camera" -vcodec libx264 -preset:v ultrafast -tune:v zerolatency -f flv rtmp://localhost/oflaDemo/livestream
```

##### 编码为MPEG2，发布UDP

```shell
ffmpeg -f dshow -i video="Integrated Camera" -vcodec mpeg2video -f mpeg2video udp://233.233.233.223:6666
```

播放MPEG2的UDP流如下。指明-vcodec为mpeg2video即可

```shell
ffplay -vcodec mpeg2video udp://233.233.233.223:6666
```

#### 屏幕录制（Windows平台下保存为本地文件或者发送实时流）

##### Linux

Linux下使用FFmpeg进行屏幕录制相对比较方便，可以使用x11grab，使用如下的命令：

```shell
ffmpeg -f x11grab -s 1600x900 -r 50 -vcodec libx264 –preset:v ultrafast –tune:v zerolatency -crf 18 -f mpegts udp://localhost:1234
```

##### Windows

在Windows平台下，使用-dshow取代x11grab。

一句话介绍：注册录屏dshow滤镜（例如screen-capture-recorder），然后通过dshow获取录屏图像然后编码处理。因此，在使用FFmpeg屏幕录像之前，需要先安装dshow滤镜。在这里推荐一个软件：screen capture recorder。安装这个软件之后，就可以通过FFmpeg屏幕录像了。

##### 编码为H.264，保存为本地文件

将屏幕录制后编码为H.264 并保存为本地文件

```shell
ffmpeg -f dshow -i video="screen-capture-recorder" -r 5 -vcodec libx264 -preset:v ultrafast -tune:v zerolatency MyDesktop.mkv
```

录屏，伴随话筒输入的声音

```shell
ffmpeg -f dshow -i video="screen-capture-recorder" -f dshow -i audio="内装麦克风 (Conexant 20672 SmartAudi" -r 5 -vcodec libx264 -preset:v ultrafast -tune:v zerolatency -acodec libmp3lame MyDesktop.mkv
```

录屏，伴随耳机输入的声音

```shell
ffmpeg -f dshow -i video="screen-capture-recorder" -f dshow -i audio="virtual-audio-capturer" -r 5 -vcodec libx264 -preset:v ultrafast -tune:v zerolatency -acodec libmp3lame MyDesktop.mkv
```

##### 编码为H.264，发布UDP

将屏幕录制后编码为H.264并封装成UDP发送到组播地址

```shell
ffmpeg -f dshow -i video="screen-capture-recorder" -r 5 -vcodec libx264 -preset:v ultrafast -tune:v zerolatency -f h264 udp://233.233.233.223:6666
```

##### 编码为H.264，发布RTP

将屏幕录制后编码为H.264并封装成RTP并发送到组播地址

```shell
ffmpeg -f dshow -i video="screen-capture-recorder" -vcodec libx264 -preset:v ultrafast -tune:v zerolatency -f rtp rtp://233.233.233.223:6666>test.sdp
```

注2：结尾添加“>test.sdp”可以在发布的同时生成sdp文件。该文件可以用于该视频流的播放。如下命令即可播放：

```shell
ffplay test.sdp
```

##### 编码为H.264，发布RTMP

```shell
ffmpeg -f dshow -i video="Integrated Camera" -vcodec libx264 -preset:v ultrafast -tune:v zerolatency -f flv rtmp://localhost/oflaDemo/livestream
```

#### 另一种屏幕录制的方式

最简单的抓屏：

```shell
ffmpeg -f gdigrab -i desktop out.mpg
```

从屏幕的（10,20）点处开始，抓取640x480的屏幕，设定帧率为5

```shell
ffmpeg -f gdigrab -framerate 5 -offset_x 10 -offset_y 20 -video_size 640x480 -i desktop out.mpg
```

