## AVCodecContext

>enum AVMediaType codec_type：编解码器的类型（视频，音频...）
>
>struct AVCodec  *codec：采用的解码器AVCodec（H.264,MPEG2...）
>
>int bit_rate：平均比特率
>
>uint8_t *extradata; int extradata_size：针对特定编码器包含的附加信息（例如对于H.264解码器来说，存储SPS，PPS等）
>
>AVRational time_base：根据该参数，可以把PTS转化为实际的时间（单位为秒s）
>
>int width, height：如果是视频的话，代表宽和高
>
>int refs：运动估计参考帧的个数（H.264的话会有多帧，MPEG2这类的一般就没有了）
>
>int sample_rate：采样率（音频）
>
>int channels：声道数（音频）
>
>enum AVSampleFormat sample_fmt：采样格式
>
>int profile：型（H.264里面就有，其他编码标准应该也有）
>
>int level：级（和profile差不太多）