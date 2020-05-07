RTSP

RTSP对流媒体提供了诸如暂停，快进等控制，而它本身并不传输数据，RTSP的作用相当于流媒体服务器的远程控制。



RTSP与 HTTP 的区别和联系

- 联系

  两者都用纯文本来发送消息，且rtsp协议的语法也和HTTP类似。Rtsp一开始这样设计，也是为了能够兼容使用以前写的HTTP协议分析代码 。

- 区别

  rtsp是有状态的，不同的是RTSP的命令需要知道现在正处于一个什么状态，也就是说rtsp的命令总是按照顺序来发送，某个命令总在另外一个命令之前要发送。Rtsp不管处于什么状态都不会去断掉连接。，而http则不保存状态，协议在发送一个命令以后，连接就会断开，且命令之间是没有依赖性的。rtsp协议使用554端口，http使用80端口。



RTSP 与 SIP 的区别和联系

- 联系

  sip和rtsp都是应用层的控制协议，负责一次通信过程的建立和控制和结束，不负责中间的传输部分。他们都是基于纯文本的信令协议，穿墙性能良好。支持tcp、udp，支持多方通信。他们都需要服务器支持，都支持会话中重定向。sip和rtsp 都使用sdp协议来传送媒体参数，使用rtp（rtcp）协议来传输媒体流。

- 区别

  rtsp是专门为流媒体制定的协议，在多个媒体流的时间同步方面比sip强大。rtsp还提供网络负载均衡的功能，减轻服务器压力和网络带宽要求。sip一般用来创建一次音频、视频通话（双向），而rtsp一般用来做视频点播、视频监控等（单向）。当然，从原理上讲，rtsp也可以做双向的视频通话。

RTSP消息

请求消息

请求消息格式：

> 方法 URI RTSP版本 CR LF
>        消息头 CR LF CR LF         
>        消息体 CR LF
>
> ​    其中方法包括OPTIONS、SETUP、PLAY、TEARDOWN等待，URI是接收方（服务端）的地址，例如：rtsp://192.168.22.136:5000/v0，每行后面的CR LF表示回车换行，需要接收端有相应的解析，最后一个消息头需要有两个CR LF。



回应消息

回应消息格式：

> RTSP版本 状态码 解释 CR LF
>        消息头 CR LF CR LF
>        消息体 CR LF
>     其中RTSP版本一般都是RTSP/1.0，状态码是一个数值，200表示成功，解释是与状态码对应的文本解释。

状态码由三位数组成，表示方法执行的结果，定义如下：

1XX：保留，将来使用；

2XX：成功，操作被接收、理解、接受（received,understand,accepted）；

3XX：重定向，要完成操作必须进行进一步操作；

4XX：客户端出错，请求有语法错误或无法实现；

5XX：服务器出错，服务器无法实现合法的请求。



RTSP方法

OPTIONS, DESCRIBE, SETUP, TEARDOWN, PLAY, PAUSE, SCALE, GET_PARAMETER ，SET_PARAMETER 



OPTION

目的是得到服务器提供的可用方法:

OPTIONS rtsp://192.168.20.136:5000/xxx666 RTSP/1.0

CSeq: 1         //每个消息都有序号来标记，第一个包通常是option请求消息

User-Agent: VLC media player (LIVE555 Streaming Media v2005.11.10)

服务器的回应信息包括提供的一些方法,例如:

RTSP/1.0 200 OK

Server: UServer 0.9.7_rc1

Cseq: 1         //每个回应消息的cseq数值和请求消息的cseq相对应

Public: OPTIONS, DESCRIBE, SETUP, TEARDOWN, PLAY, PAUSE, SCALE, GET_PARAMETER //服务器提供的可用的方法



DESCRIBE

C向S发起DESCRIBE请求,为了得到会话描述信息(SDP):

DESCRIBE rtsp://192.168.20.136:5000/xxx666 RTSP/1.0

CSeq: 2

token:

Accept: application/sdp

User-Agent: VLC media player (LIVE555 Streaming Media v2005.11.10)

服务器回应一些对此会话的描述信息(sdp):

RTSP/1.0 200 OK

Server: UServer 0.9.7_rc1

Cseq: 2

x-prev-url: rtsp://192.168.20.136:5000

x-next-url: rtsp://192.168.20.136:5000

x-Accept-Retransmit: our-retransmit

x-Accept-Dynamic-Rate: 1

Cache-Control: must-revalidate

Last-Modified: Fri, 10 Nov 2006 12:34:38 GMT

Date: Fri, 10 Nov 2006 12:34:38 GMT

Expires: Fri, 10 Nov 2006 12:34:38 GMT

Content-Base: rtsp://192.168.20.136:5000/xxx666/

Content-Length: 344

Content-Type: application/sdp

v=0        //以下都是sdp信息

o=OnewaveUServerNG 1451516402 1025358037 IN IP4 192.168.20.136

s=/xxx666

u=http:///

e=admin@

c=IN IP4 0.0.0.0

t=0 0

a=isma-compliance:1,1.0,1

a=range:npt=0-

m=video 0 RTP/AVP 96    //m表示媒体描述，下面是对会话中视频通道的媒体描述

a=rtpmap:96 MP4V-ES/90000

a=fmtp:96 profile-level-id=245;config=000001B0F5000001B509000001000000012000C888B0E0E0FA62D089028307

a=control:trackID=0//trackID＝0表示视频流用的是通道0





SETUP

客户端提醒服务器建立会话,并确定传输模式:

SETUP rtsp://192.168.20.136:5000/xxx666/trackID=0 RTSP/1.0    

CSeq: 3

Transport: RTP/AVP/TCP;unicast;interleaved=0-1      

User-Agent: VLC media player (LIVE555 Streaming Media v2005.11.10)

//uri中带有trackID＝0，表示对该通道进行设置。Transport参数设置了传输模式，包的结构。接下来的数据包头部第二个字节位置就是interleaved，它的值是每个通道都不同的，trackID＝0的interleaved值有两个0或1，0表示rtp包，1表示rtcp包，接受端根据interleaved的值来区别是哪种数据包。

服务器回应信息:

RTSP/1.0 200 OK

Server: UServer 0.9.7_rc1

Cseq: 3

Session: 6310936469860791894     //服务器回应的会话标识符

Cache-Control: no-cache

Transport: RTP/AVP/TCP;unicast;interleaved=0-1;ssrc=6B8B4567

 

PLAY

客户端发送播放请求:

PLAY rtsp://192.168.20.136:5000/xxx666 RTSP/1.0

CSeq: 4

Session: 6310936469860791894

Range: npt=0.000-      //设置播放时间的范围

User-Agent: VLC media player (LIVE555 Streaming Media v2005.11.10)

服务器回应信息:

RTSP/1.0 200 OK

Server: UServer 0.9.7_rc1

Cseq: 4

Session: 6310936469860791894

Range: npt=0.000000-

RTP-Info: url=trackID=0;seq=17040;rtptime=1467265309     

//seq和rtptime都是rtp包中的信息





TEARDOWN

客户端发起关闭请求:

TEARDOWN rtsp://192.168.20.136:5000/xxx666 RTSP/1.0

CSeq: 5

Session: 6310936469860791894

User-Agent: VLC media player (LIVE555 Streaming Media v2005.11.10)

服务器回应:

RTSP/1.0 200 OK

Server: UServer 0.9.7_rc1

Cseq: 5

Session: 6310936469860791894

Connection: Close