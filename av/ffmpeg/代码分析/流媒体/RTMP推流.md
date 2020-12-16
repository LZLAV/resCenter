## RTMP推流

RTMP推流器（Streamer）。首先将视频数据以RTMP的形式发送到流媒体服务器端（Server，比如FMS，Red5，Wowza等），然后客户端（一般为Flash Player）通过访问流媒体服务器就可以收看实时流了。

#### 封装格式

RTMP采用的封装格式是FLV。因此在指定输出流媒体的时候需要指定其封装格式为“flv”。同理，其他流媒体协议也需要指定其封装格式。例如采用UDP推送流媒体的时候，可以指定其封装格式为“mpegts”。

#### 延时

发送流媒体的数据的时候需要延时。不然的话，FFmpeg处理数据速度很快，瞬间就能把所有的数据发送出去，流媒体服务器是接受不了的。因此需要按照视频实际的帧率发送数据。本文记录的推流器在视频帧与帧之间采用了av_usleep()函数休眠的方式来延迟发送。这样就可以按照视频的帧率发送数据了，参考代码如下

```c
//…
int64_t start_time=av_gettime();
while (1) {
//…
	//Important:Delay
	if(pkt.stream_index==videoindex){
		AVRational time_base=ifmt_ctx->streams[videoindex]->time_base;
		AVRational time_base_q={1,AV_TIME_BASE};
		int64_t pts_time = av_rescale_q(pkt.dts, time_base, time_base_q);
		int64_t now_time = av_gettime() - start_time;
		if (pts_time > now_time)
			av_usleep(pts_time - now_time);
	}
//…
}
//…
```

#### PTS/DTS问题

没有封装格式的裸流（例如H.264裸流）是不包含PTS、DTS这些参数的。在发送这种数据的时候，需要自己计算并写入AVPacket的PTS，DTS，duration等参数。这里还没有深入研究，简单写了一点代码，如下所示。

```c
//FIX：No PTS (Example: Raw H.264)
//Simple Write PTS
if(pkt.pts==AV_NOPTS_VALUE){
	//Write PTS
	AVRational time_base1=ifmt_ctx->streams[videoindex]->time_base;
	//Duration between 2 frames (us)
	int64_t calc_duration=(double)AV_TIME_BASE/av_q2d(ifmt_ctx->streams[videoindex]->r_frame_rate);
	//Parameters
	pkt.pts=(double)(frame_index*calc_duration)/(double)(av_q2d(time_base1)*AV_TIME_BASE);
	pkt.dts=pkt.pts;
	pkt.duration=(double)calc_duration/(double)(av_q2d(time_base1)*AV_TIME_BASE);
}
```

