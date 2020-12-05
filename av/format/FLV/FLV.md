## FLV

FLV封装格式的结构，如下图所示。



![img](https://img-blog.csdn.net/20150312023125560?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGVpeGlhb2h1YTEwMjA=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

从图中可以看出，FLV文件体部分是由一个一个的Tag连接起来的（中间间隔着Previous Tag Size）。每个Tag包含了Tag Header和Tag Data两个部分。Tag Data根据Tag的Type不同而不同：可以分为音频Tag Data，视频Tag Data以及Script Tag Data。下面简述一下音频Tag Data和视频Tag Data。



#### Audio Tag Data

Audio Tag在官方标准中定义如下。
Audio Tag开始的第1个字节包含了音频数据的参数信息，从第2个字节开始为音频流数据。第1个字节的前4位的数值表示了音频数据格式：

> 0 = Linear PCM, platform endian
> 1 = ADPCM
> 2 = MP3
> 3 = Linear PCM, little endian
> 4 = Nellymoser 16-kHz mono
> 5 = Nellymoser 8-kHz mono
> 6 = Nellymoser
> 7 = G.711 A-law logarithmic PCM
> 8 = G.711 mu-law logarithmic PCM
> 9 = reserved
> 10 = AAC
> 14 = MP3 8-Khz
> 15 = Device-specific sound

第1个字节的第5-6位的数值表示采样率：0 = 5.5kHz，1 = 11KHz，2 = 22 kHz，3 = 44 kHz。





#### Video Tag Data

Video Tag在官方标准中的定义如下。
Video Tag也用开始的第1个字节包含视频数据的参数信息，从第2个字节为视频流数据。第1个字节的前4位的数值表示帧类型（FrameType）：

> 1: keyframe (for AVC, a seekableframe)（关键帧）
> 2: inter frame (for AVC, a nonseekableframe)
> 3: disposable inter frame (H.263only)
> 4: generated keyframe (reservedfor server use only)
> 5: video info/command frame

第1个字节的后4位的数值表示视频编码ID（CodecID）：
其中，当音频编码为AVC（H.264）的时候，第一个字节后面存储的是AVCVIDEOPACKET，格式如下所示。

  ![img](https://img-blog.csdn.net/20150312023714268?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvbGVpeGlhb2h1YTEwMjA=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

