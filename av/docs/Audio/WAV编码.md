## WAV

音质高 无损格式 体积较大。

WAV对音频流的编码没有硬性规定，除了PCM之外，还有几乎所有支持ACM规范的编码都可以为WAV的音频流进行编码。

#### RIFF

- WAVE文件是以RIFF(Resource Interchange File Format, "资源交互文件格式")格式来组织内部结构的
  RIFF文件结构可以看作是树状结构,其基本构成是称为"块"（Chunk）的单元。
- WAVE文件是由若干个Chunk组成的。按照在文件中的出现位置包括：RIFF WAVE Chunk, Format Chunk, Fact Chunk(可选), Data Chunk。

> Fact Chunk 在压缩后或在非PCM编码时存在



多媒体应用中使用了多种数据，包括位图、音频数据、视频数据以及外围设备控制信息等。RIFF为存储这些类型的数据提供了一种方法，RIFF文件所包含的数据类型由该文件的扩展名来标识，能以RIFF文件存储的数据包括：

音频视频交错格式数据(.AVI) 、波形格式数据(.WAV) 、位图格式数据(.RDI) 、MIDI格式数据(.RMI) 、调色板格式(.PAL) 、多媒体电影(.RMN) 、动画光标(.ANI) 、其它RIFF文件(.BND)。 

#### WAV头文件

所有的WAV都有一个文件头，这个文件头记录着音频流的编码参数。数据块的记录方式是little-endian字节顺序。

![](.\..\png\wav_header.png)

| 偏移地址 | 命名          | 内容                                                         | 备注                                  |
| -------- | ------------- | ------------------------------------------------------------ | ------------------------------------- |
| 00-03    | ChunkId       | "RIFF"                                                       |                                       |
| 04-07    | ChunkSize     | 下个地址开始到文件尾的总字节数(此Chunk的数据大小)            |                                       |
| 08-11    | fccType       | "WAVE"                                                       | 类型块标识（可选）                    |
| 12-15    | SubChunkId1   | "fmt ",最后一位空格。                                        | 块标识符（可“fmt ”，“fact”,"data"等） |
| 16-19    | SubChunkSize1 | 一般为16，表示fmt Chunk的数据块大小为16字节，即20-35         |                                       |
| 20-21    | FormatTag     | 1：表示是PCM 编码                                            |                                       |
| 22-23    | Channels      | 声道数，单声道为1，双声道为2                                 |                                       |
| 24-27    | SamplesPerSec | 采样率                                                       |                                       |
| 28-31    | BytesPerSec   | 码率 ：采样率 * 采样位数 * 声道个数，bytePerSecond = sampleRate * (bitsPerSample / 8) * channels |                                       |
| 32-33    | BlockAlign    | 每次采样的大小：位宽*声道数/8                                |                                       |
| 34-35    | BitsPerSample | 位宽                                                         |                                       |
| 36-39    | SubChunkId2   | "data"                                                       |                                       |
| 40-43    | SubChunkSize2 | 音频数据的长度                                               |                                       |
| 44-...   | data          | 音频数据                                                     |                                       |

上面说到的“类型块标识”只在部分chunk中用到，如 "WAVE" chunk中，这时表示下面嵌套有别的chunk。

当使用了 "类型块标识" 时，该chunk就没有别的项（如块标志符，数据大小等），它只作为文件读取时的一个标识。先找到这个“类型块标识”，再以它为起点读取它下面嵌套的其它chunk。 

每个文件最前端写入的是RIFF块，每个文件只有一个RIFF块。从 Wave文件格式详细说明 中可以看到这一点。

非PCM格式的文件会至少多加入一个 "fact" 块，它用来记录数据(注意是数据而不是文件)解压缩后的大小。这个 "fact" 块一般加在 "data" 块的前面。 

WAVE文件是由若干个Chunk组成的。按照在文件中的出现位置包括：RIFF WAVE Chunk, Format Chunk, Fact Chunk(可选), Data Chunk。

#### 示例

##### PCM转 WAV格式音频

pcm转换成wav，我们只需要在pcm的文件起始位置加上至少44个字节的WAV头信息即可。

**代码见 ： `./demo/编解码与格式转换/WAV/Java/pcm转wav`**