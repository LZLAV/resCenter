# av

### 时钟频率

通常视频的时钟频率为 90000，音频的时钟频率为 8000。对应时间戳可如下方式计算：

RTP timestamp是用时钟频率（clock rate）计算而来表示时间的。
RTP timestamp表示每帧的时间，由于一个帧（如I帧）可能被分成多个RTP包，所以多个相同帧的RTP timestamp相等。（可以通过每帧最后一个RTP的marker标志区别帧，但最可靠的方法是查看相同RTP timestamp包为同一帧。）

> 两帧之间RTP timestamp的增量 = 时钟频率 / 帧率
>

 其中时钟频率可从SDP中获取，如:

> m=video 2834 RTP/AVP 96
> a=rtpmap:96 H264/90000

其时钟频率为90000（通常视频的时钟频率），若视频帧率为25fps，则相邻帧间RTP timestamp增量值 = 90000/25 = 3600。
