## AVFormatContext

AVFormatContext是一个贯穿始终的数据结构，很多函数都要用到它作为参数。它是FFMPEG解封装（flv，mp4，rmvb，avi）功能的结构体。AVFormatContext是包含码流参数较多的结构体。

>AVIOContext *pb：输入数据的缓存
>
>unsigned int nb_streams：视音频流的个数
>
>AVStream **streams：视音频流
>
>char filename[1024]：文件名
>
>int64_t duration：时长（单位：微秒us，转换为秒需要除以1000000）
>
>int bit_rate：比特率（单位bps，转换为kbps需要除以1000）
>
>AVDictionary *metadata：元数据

视频的原数据（metadata）信息可以通过AVDictionary获取。元数据存储在AVDictionaryEntry结构体中，如下所示

```c
typedef struct AVDictionaryEntry {
    char *key;
    char *value;
} AVDictionaryEntry;
```

每一条元数据分为key和value两个属性。

在ffmpeg中通过av_dict_get()函数获得视频的原数据。

下列代码显示了获取元数据并存入meta字符串变量的过。

```c

//MetaData------------------------------------------------------------
//从AVDictionary获得
//需要用到AVDictionaryEntry对象
//CString author,copyright,description;
CString meta=NULL,key,value;
AVDictionaryEntry *m = NULL;
//不用一个一个找出来
/*	m=av_dict_get(pFormatCtx->metadata,"author",m,0);
author.Format("作者：%s",m->value);
*/
//使用循环读出
//(需要读取的数据，字段名称，前一条字段（循环时使用），参数)
while(m=av_dict_get(pFormatCtx->metadata,"",m,AV_DICT_IGNORE_SUFFIX)){
	key.Format(m->key);
	value.Format(m->value);
	meta+=key+"\t:"+value+"\r\n" ;
}
```

