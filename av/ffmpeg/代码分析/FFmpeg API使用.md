# FFmpeg API 使用

## libavformat

### 封装

#### 接口调用流程





#### 步骤

- API注册
- 申请 AVFormatContext
- 申请AVStream
- 增加目标容器头信息
- 写入帧数据
- 写容器尾信息

#### 注册

```c
av_register_all()
```

#### 申请AVFormatContext

```c
AVOutputFormat *fmt;
AVFormatContext *oc;
avformat_alloc_output_context2(&oc,NULL,"flv",filename);
if(!oc)
{
    return -1;
}
fmt = oc->oformat;
```

#### 申请AVStream

```c
AVStream *st;
AVCodecContext *c;
st = avformat_new_stream(oc,NULL);
if(!oc->st)
{
    return -1;
}
st->id = oc->nb_streams-1;
```

至此，需要将 Codec 与 AVStream 进行对应，可以根据视频的编码参数对 AVCodecContext 的参数进行设置：

```c
c->codec_id = codec_id;
c->bit_rate = 400000;
c->width = 352;
c->height = 288;
st->time_base = (AVRational){1,25};
c->time_base = st->time_base;
c->gop_size = 12;
c->pix_fmt = AV_PIX_FMT_YUV420P;
```

然后为了兼容新版本FFmpeg 的 AVCodeeparameters结构，需要做一个参数copy操作:

```c
ret = avcodec_parameters_from_context(ost->st->codecopar,c);
if(ret < 0)
{
    return -1;
}
```

#### 增加目标容器头信息

```c
ret  = avformat_write_header(oc,&opt);
if(ret < 0)
{
    return -1;
}
```

#### 写入帧数据

在FFmpeg操作数据包时,均采用写帧操作进行音视频数据包的写入,而每一帧在常规情况下均使用AVPacket结构进行音视频数据的存储,AVPacket结构中包含了PTS,DTS、Data等信息,数据在写入封装中时,会根据封装的特性写入对应的信息:

```c
AVFormatContext *ifmt_ctx = NULL;
AVIOContext* read_in = avio_alloc_context(inbuffer,32*1024,0,NULL,get_input_buffer,NULL,NULL);
if(read_in == NULL)
{
    goto end;
}
ifmt_ctx->pb = read_in;
ifmt_ctx->flags = AVFMT_FLAG_CUSTOM_IO;
if((ret = avformat_open_input(&ifmt_ctx,"h264",NULL,NULL))<0)
{
    
}
```



## libavcodec

## libavfilter