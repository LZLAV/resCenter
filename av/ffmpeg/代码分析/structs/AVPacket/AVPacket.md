## AVPacket

AVPacket是存储压缩编码数据相关信息的结构体。

> uint8_t *data：压缩编码的数据。
>
> 例如对于H.264来说。1个AVPacket的data通常对应一个NAL。
>
> 注意：在这里只是对应，而不是一模一样。他们之间有微小的差别。
>
> 因此在使用FFMPEG进行视音频处理的时候，常常可以将得到的AVPacket的data数据直接写成文件，从而得到视音频的码流文件。
>
> 
>
> int   size：data的大小
>
> int64_t pts：显示时间戳
>
> int64_t dts：解码时间戳
>
> int   stream_index：标识该AVPacket所属的视频/音频流。