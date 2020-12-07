## AVCodec

>const char *name：编解码器的名字，比较短
>
>const char *long_name：编解码器的名字，全称，比较长
>
>enum AVMediaType type：指明了类型，是视频，音频，还是字幕
>
>enum AVCodecID id：ID，不重复
>
>const AVRational *supported_framerates：支持的帧率（仅视频）
>
>const enum AVPixelFormat *pix_fmts：支持的像素格式（仅视频）
>
>const int *supported_samplerates：支持的采样率（仅音频）
>
>const enum AVSampleFormat *sample_fmts：支持的采样格式（仅音频）
>
>const uint64_t *channel_layouts：支持的声道数（仅音频）
>
>int priv_data_size：私有数据的大小