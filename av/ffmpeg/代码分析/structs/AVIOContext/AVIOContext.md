## AVIOContext

AVIOContext是FFMPEG管理输入输出数据的结构体。

>unsigned char *buffer：缓存开始位置
>
>int buffer_size：缓存大小（默认32768）
>
>unsigned char *buf_ptr：当前指针读取到的位置
>
>unsigned char *buf_end：缓存结束的位置
>
>void *opaque：URLContext结构体

