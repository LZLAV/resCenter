## AVStream

AVStream是存储每一个视频/音频流信息的结构体。

> int index：标识该视频/音频流
>
> AVCodecContext *codec：指向该视频/音频流的AVCodecContext（它们是一一对应的关系）
>
> AVRational time_base：时基。通过该值可以把PTS，DTS转化为真正的时间。FFMPEG其他结构体中也有这个字段，但是根据我的经验，只有AVStream中的time_base是可用的。PTS*time_base=真正的时间
>
> int64_t duration：该视频/音频流长度
>
> AVDictionary *metadata：元数据信息
>
> AVRational avg_frame_rate：帧率（注：对视频来说，这个挺重要的）
>
> AVPacket attached_pic：附带的图片。比如说一些MP3，AAC音频文件附带的专辑封面。