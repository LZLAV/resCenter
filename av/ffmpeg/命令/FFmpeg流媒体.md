## FFmpeg流媒体

#### UDP

##### 发送H.264裸流至组播地址

注：组播地址指的范围是224.0.0.0—239.255.255.255

```shell
ffmpeg -re -i chunwan.h264 -vcodec copy -f h264 udp://233.233.233.223:6666
```

注1：-re一定要加，代表按照帧率发送，否则ffmpeg会一股脑地按最高的效率发送数据。

##### 播放承载 H.264 裸流的UDP

```shell
ffplay -f h264 udp://233.233.233.223:6666
```

##### 发送MPEG2裸流至组播地址

```shell
ffmpeg -re -i chunwan.h264 -vcodec mpeg2video -f mpeg2video udp://233.233.233.223:6666
```

##### 播放MPEG2裸流

```shell
ffplay -vcodec mpeg2video udp://233.233.233.223:6666
```

#### RTP

##### 发送H.264裸流至组播地址

```shell
ffmpeg -re -i chunwan.h264 -vcodec copy -f rtp rtp://233.233.233.223:6666>test.sdp
```

注1：最右边的“>test.sdp”用于将ffmpeg的输出信息存储下来形成一个sdp文件。该文件用于RTP的接收。当不加“>test.sdp”的时候，ffmpeg会直接把sdp信息输出到控制台。将该信息复制出来保存成一个后缀是.sdp文本文件，也是可以用来接收该RTP流的。加上“>test.sdp”后，可以直接把这些sdp信息保存成文本。

##### 播放承载H.264裸流的RTP

```shell
ffplay test.sdp
```

## RTMP

##### 发送H.264裸流至RTMP服务器（FlashMedia Server，Red5等）

实现了发送H.264裸流“chunwan.h264”至主机为localhost，Application为oflaDemo，Path为livestream的RTMP URL。

```shell
ffmpeg -re -i chunwan.h264 -vcodec copy -f flv rtmp://localhost/oflaDemo/livestream
```

##### 播放RTMP

```shell
ffplay “rtmp://localhost/oflaDemo/livestream live=1”
```

注：ffplay播放的RTMP URL最好使用双引号括起来，并在后面添加live=1参数，代表实时流。实际上这个参数是传给了ffmpeg的libRTMP的。