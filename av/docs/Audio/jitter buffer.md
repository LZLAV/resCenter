## Jitter Buffer

在语音通信中Jitter Buffer（下面简称JB）是接收侧一个非常重要的模块，它是决定音质的重要因素之一。

### 作用

1. 会把收到的乱序的语音包排好序放在buffer里正确的位置上
2. 把接收到的语音包放在buffer中缓冲一些时间使播放的更平滑从而获得更好的语音质量。



![](.\png\jitter_buffer工作流程.png)

### 模式

- adaptive （自适应的）
- fixed（固定的）

### 状态

- prefetching（预存取）
- processing（处理中）

只有在processing时才能从JB中取到语音帧。初始化时把状态置成prefetching，当在JB中的语音包个数达到指定的值时便把状态切到processing。如果从JB里取不到语音帧了，它将又回到prefetching。等buffer里语音包个数达到指定值时又重新回到processing状态。

### 结构

![](.\png\jitter_buffer结构.png)

#### 结构确定

通过类型确定 payload buffer 中一个  block 的大小   （以 80 byte为例）

RTP payload:

​	G711/G722/G729/SID(静音包)/RFC2833(DTMF包)

​		G711/G722： 10ms~~>80byte

​		G729：10byte

​		SID：1至11byte

​		RFC2833：4byte

​	VAD使能时，payload 是 2个字节



RTP attribute：

​	block 的大小是固定的

​		media type（G711/G722/G729/SID/RFC2833）

​		sequence number

​		timestamp

​		ssrc

​		payload size

​		payload buffer block ptr(指针)



例：

​	一个 packet time 为 20ms 的G711包，就需要两个 payload buffer block，attribute buffer block 和 payload buffer block 之间有一个映射关系

![](.\png\jitter_buffer映射关系.png)

JB里最多能放多少个包（即容量 capacity）,取决于 media type 和 packet time。

例：（假设Block长度为 256个）

​	media type： G711/G722

​	capacity= 256*10 /packet time

​	当 packet time =20ms，则 capacity = 128



### PUT

依靠 attribute 里的 sequence number (unsigned short 0~65535) 和 timestamp 做排序判断

1. 上一个已经取出的包 sequence number 为 last_got_senq ，timestamp 为 last_got_timestamp
2. 收到的包对应为 cur_sequence 和 cur_timestamp
3. delta_senq = cur_sequence - last_got_senq （循环 buffer需要对应处理）
4. delta_senq < 1 丢弃（说明包相同）
5. position = senquence number % capacity （第一个包，后面收到的包依赖于上一个已放好position）
6. 新包：position = (last_put_position + delta_seqn+capacity) % capacity
7. 得到了当前包的 position 后就可以把包里头的 timestamp 等放到相应的 attribute buffer block 里了
8. 如果放入的对应 block 中有包，而且 sequence number 一样，则认为是重复包，丢弃

### GET

1. 从head上取，开始时 head 为第一个放进 JB 的包的 position，取完后往后移一个位置
2. 如果某个位置没有包，说明这个包丢了，取出的大小为 0 ，告诉后续的 decoder 需做PLC

##### 数据大小

类型：

​	G711/G722：	取10ms

​	G729：				VAD未使能	10ms

​								 VAD使能		 10/2/0 byte ，处理好取包，能显著提高语音质量 MOS 质量

​	SID：

​	RFC2833：包里有个 duration attribute

​		当前 RFC2833 包和上一个 RFC2833 的 duration 相减再除以 80 就是当前包的 packet time。



### 自适应

1. ​	JB 初始化时会设定一个缓存包的个数值（叫 prefetch），并处于 prefetching 状态
2. 网络环境变恶劣，GET的次数比PUT的次数多，GET完最后一帧就进入prefetching状态。
3. 当再有包PUT进JB时，先看前面共有多少次连续的GET，从而增大prefetch值，即增大buffer size的大小。
4. 如果网络变得稳定了，GET和PUT就会交替出现，当交替出现的次数达到一定值时，就会减小prefetch值，即减小buffer size的大小，交替的次数更多时再继续减小prefetch值。

### RESET

哪些情况下需要reset JB，让JB在初始状态下开始运行。

1. 当收到的语音包的媒体类型（G711/G722/G729，不包括SID/RFC2833等）变了，就认为来了新的stream，需要reset JB。
2. 当收到的语音包的SSRC变了，就认为来了新的stream，需要reset JB。
3. 当收到的语音包的packet time变了，就认为来了新的stream，需要reset JB。

### 性能指标

对于JB来说，需要知道当前的运行状态以及一些统计信息等。如果这些信息正常，就说明问题很大可能不是由JB引起的，不正常则说明有很大的可能性。这些信息主要如下：

1. JB当前运行状态：prefetching / processing
2. JB里有多少个缓存的包
3. 从JB中取帧的head的位置
4. 缓冲区的capacity是多少
5. 网络丢包的个数
6. 由于来的太迟而被主动丢弃的包的个数
7. 由于JB里已有这个包而被主动丢弃的包的个数
8. 进prefetching状态的次数（除了第一次）





## 参考

[音频传输之Jitter Buffer设计与实现](https://www.cnblogs.com/talkaudiodev/p/8025242.html)