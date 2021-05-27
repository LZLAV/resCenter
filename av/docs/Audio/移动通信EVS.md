## EVS

### OTT

OTT(On The Top)，主要应用于互联网厂商。编解码器 OPUS，全频段（8kHz-48kHz）。支持音乐和语音（语音用SILK，音乐用CELT）



### EVS

移动通信标准组织 3GPP。主要适用于 VoLTE，也适用于 VoWiFi 和 VoIP。全频段（5kbps-128kbps），支持语音、音乐，具有很强的抗丢帧和抗延时抖动的能力。



### 编码

#### 语音

改进型代数码激励线性预测（ACELP），还采用了适合不同语音类别的线性预测模式

#### 音乐

采用频域（MDCT）编码方式， 并特别关注低延迟/低比特率情况下的频域编码效率，从而在语音处理器和音频处理器之间实现无缝可靠的切换。

#### 编解码框图

![](.\png\EVS编解码框图.png)

编码时先对输入的PCM信号做预处理，同时确定是语音信号还是音频信号。如是语音信号就用语音编码器编码得到比特流，如是音频信号就用感知编码器进行编码得到比特流。解码时根据比特流中的信息确定是语音信号还是音频信号，如是语音信号就用语音解码器解码得到PCM数据，然后做语音带宽扩展。如是音频信号就用感知解码器解码得到PCM数据，然后做频率带宽扩展。最后再做后处理作为EVS解码器的输出。



### 关键指标

#### 全频带宽

EVS支持全频段（8kHZ--48kHZ），码率范围是5.9kbps至128kbps。每帧是20Ms时长。下图是音频带宽的分布：

![](.\png\EVS全频段带宽.png)

窄带（Narrow Band, NB）范围是300HZ-3400HZ，对应的采样率是8kHZ，AMR-NB用的就是这种采样率。宽带（Wide Band, WB）范围是50HZ-7000HZ，对应的采样率是16kHZ，AMR-WB用的就是这种采样率。超宽带（Super Wide Band, SWB）范围是20HZ-14000HZ，对应的采样率是32kHZ。全带（Full Band, FB）范围是20HZ-2000HZ，对应的采样率是48kHZ。EVS支持全频段，所以它支持四种采样率：8kHZ、16kHZ、32kHZ和48kHZ。

#### 各种采样率下的码率

![](.\png\EVS支持码率.png)

#### EVS支持DTX/VAD/CNG/SID

在通话过程中通常有一半左右时间讲话，其余时间处于聆听状态。在聆听状态时没必要发语音包给对方，于是就有了DTX（非连续传输）。要用VAD（静音检测）算法去判断是语音还是静音，是语音包时就发语音包，是静音时就发静音包（SID包）。对方收到SID包后就去用CNG（舒适噪声生成）算法去生成舒适噪声。

EVS中有两种CNG算法：基于线性预测的CNG（linear prediction-domain based CNG）和基于频域的CNG（frequency-domain based CNG）。在SID包的发送机制上EVS跟AMR-WB不同，在AMR-WB中VAD检测到是静音时就发送一个SID包，然后40Ms后发送第二个SID包，随后每隔160Ms发送一个SID包，不过VAD一检测到是语音就立刻发送语音包。EVS中SID包的发送机制可配，可以固定每隔一段时间（几帧，范围是3--100）发送一个SID包，也可以根据SNR自适应的发送SID包，发送周期范围是8—50帧。EVS SID包的payload大小也与AMR-WB不同，AMR-WB的是40个字节（50*40=2000bps），EVS是48个字节（50*48=2400bps）。从上可以看出DTX有两个好处，一是可以节省带宽，增加容量，二是因为不编解码减少了运算量，从而降低功耗增加续航时长。

#### 支持PLC

EVS也支持PLC（丢包补偿），这也同AMR-WB一样。不过EVS把Jitter Buffer Module(JBM)也包含了进来。



### 编解码



#### 编码结构

编码后的值放在indices（最多有1953个indices）中, 每个indices有两个成员变量，一个是nb_bits，表示这个indices有多少位，另一个是value，表示这个indices的值。Indices有两种存储方式：G192（ITU-T G.192）和MIME（Multipurpose Internet Mail Extensions）。

##### G.192

![](.\png\EVS_G192存储格式.png)

第一个Word是同步值，分good frame（值为0x6B21）和bad frame（值为0x6B20）两种，第二个Word是长度，后面是每个值（1用0x0081表示， 0用0x007F表示）。Indices里的value用二进制表示，位上的值为1就存为0x0081，为0 就存为0x007F。