### H264打包RTP

产生大于 MTU 的包，在IP层其将会被分割成几个小于 MTU 尺寸的包，这样将会无法检测数据是否丢失，因为 IP 和 UDP 协议都没有提供分组到达的检测。

TCP 建立连接后，传输数据的大小不受限制，双方可按照一定的格式传输大量的数据，而 UDP 最大为 64 K（2^16）。

1500 - 20 -(8+12) = 1460 字节

```text
20 ： IP 头部
8  ： UDP 头部
12 ： RTP 头部
```

H264媒体流的 RTP 负载格式（RTP = [RTP Header] + [RTP payload]），主要有三种：

- 单元NAL 单元分组（RTP payload = [NAL Header] + [NAL payload]）

  单个 NALU 传递，NALU 头部兼作 RTP 头部，RTP 头部类型即 NAL 单元类型 1-23

- 聚合分组（RTP payload = [STAP-A NAL HDR] [NALU | size] [NALU | HDR ] [NALU | Data] [NALU2 | size] ...）

  将多个 NAL 单元聚合在一个 RTP 分组中

- 片分组

  Fragment Unit = [ FU Indicator ] + [ FU Header ] + [ FU payload ]

  RTP payload = [ Fragment Unit ]

#### 单元NAL分组

##### NALU Header

```c
struct
{
    TYPE:5;		//类型
    NRI:2;		//优先级
    F:1;		//隐藏比特位
}NALU_Header;
```

##### NRI

00 表示没有参考作用，可丢弃。如 B slice，SEI 等

非零，包括 01 10 00 ，表示不可丢弃。如 SPS、PPS、I slice、P slice等

##### F 

网络发现 NAL 单元有比特错误时可设置该比特为 1，以便接收方丢掉该单元。

##### TYPE

H.264 只取 1～23 是有效的值，24～31 表示这是一个特别格式的 NAL 单元。

#### 聚合分组

由多个 NAL 单元组成一个 RTP 包. 分别有4种组合方式: STAP-A, STAP-B, MTAP16, MTAP24.  那么这里的类型值分别是 24, 25, 26 以及 27

##### 单一时间聚合分组（STAP）

包含 STAP-A (24) 和 STAP-B(25)，按时间戳进行组合，NAL单元具有相同的时间戳，一般用于低延迟环境

##### 多时间聚合分组（MTAP）

MTAP16（26）和 MTAP24（27），一般用于高延迟的网络环境，大大增强了基于流媒体的 H.264 的性能。

#### 片分组

对于 H.264 的 I 帧、P 帧等主要是 FU (分片)发送。共有两个类型 FU-A 和 FU-B ，分别为 28 和 29。可在两个层次上进行分割：

1. 视频编码层 VCL 上的分割

   调整编码 slice 的大小

2. 网络提取层 NAL 上的分割

一个 NAL 单元采用分割分组后，每个 RTP 分组序列依次递增 1，RTP 时间戳相同且唯一。

##### FU 的 RTP 荷载格式

```c
struct
{
    TYPE:5;
    NRI:2;
    F:1;
}FU_INDICATOR;
```

```c
struct
{
    TYPE:5;
    R:1;
    E:1;	//结束包标识
    S:1;	//开始包标识
}FU_HEADER;
```

```text
| FU indicator | FU Header | FU payload | :....OPTIONAL RTP padding |
```

**FU INDICATOR**

NAR：大于 00 值指示 NAL 单元的解码要求维护引用图像的完整性。

nal_unit_type：

​	6、9、10、11、12			00

​	7、8								   11

​	5										 11

**FU Header**

S：开始位指示。设置为 1，表示分片 NAL 单元的开始

E：结束位指示。设置为 1，表示分片 NAL 单元的结束

R：保留位。必须设置为 0，接收者必须忽略该位

##### 分片流程

1. 第一个 FU-A 包的 FU indicator 的 F 应该为当前 NALU 头的 F，NRI 应该为当前 NAL 头的 NRI；type 则等于 28，表明为 FU-A 包。
2. 后续 FU indicator 和第一个完全一样，如果不是最后一个包，则 FU header 应该为：S=0，E=0，R=0，TYPE 等于 NALU 头的 type。
3. 最后一个 FU-A 包 FU Header 应该为：S=0，E=1，R=0，TYPE 等于 NALU 头的 type

总结：

​	同一个 NALU 分包的 FU indicator 头是完全一致的，FU Header 只有 S 以及 E 位有区别，分别标记开始和结束，它们的 RTP 分包的序列号应该是依次递增的，并且它们的时间戳必须一致，而负载数据为 NALU 包去掉一个字节的 NALU 头后剩余数据的拆分。可以认为 NALU 头被拆分成了 FU indicator 和 FU header ，所以不再需要 1 字节 的 NALU 头了。

##### 特点

NAL 单元的分割是 RTP 打包机制的一个重要环节，特点：（5个）  待续～





#### SDP

RTCP反馈特定信息编码到本地 SDP 中，表明本地端点有能力并且愿意接收本地 SDP 中描述的 RTCP 反馈数据包。

从SDP媒体解码 RTCP FB 特定信息。

a=fmtp:99 profile-level-id = 420A01E;packetization-mode =1;sprop-parameter-ets=Z01ACpZTBYml,aMIjiA==

420A01E：SPS 的开头几个字节

packetization-mode=1：要求每个 RTP 中只有一个NAL 单元，或者一个 FU

sprop-parameter-ets = Z01ACpZTBYml,aMIjiA== ：SPS 和 PPS 的Base64 转码，不用在码流中再传输 SPS/PPS