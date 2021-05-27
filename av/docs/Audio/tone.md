## tone



### 分类

#### CPT tone

CPT（call progress tone，呼叫过程音）tone。存在于通话过程中，主要用于告诉用户目前在什么状态，主要有dial tone(拨号音)/ringback tone(回铃音)/busy tone（忙音）等。CPT tone是单频音，即由一个频率的正弦波形成。CPT tone没有全球统一的标准，而是各个国家有自己的标准，比如中国的标准，欧洲的标准，美国的标准等。下表就是我们国家的标准：

|      名称      | 频率(Hz) |   电平   |         播放形式         |
| :------------: | :------: | :------: | :----------------------: |
|   Dial tone    |   450    | -10 dBm0 |         连续播放         |
| Ring back tone |   450    | -10 dBm0 |   放1秒停4秒，交替播放   |
|   Busy tone    |   450    | -10 dBm0 | 放350ms停350ms，交替播放 |

#### DTMF tone

DTMF（dual tone multi frequency，双音多频音）tone。DTMF tone是双频音，即用两个频率（一个高频和一个低频）的正弦波叠加去表示某个按键值。DTMF tone全球有统一的标准，下表列出了常用的16个按键值是由哪些高频音和低频音组合而成的：

![](.\png\DTMP tone全球标准.png)

### 处理

#### tone generation

tone generation，让用户听到tone。tone generation 是生成单个频率的正弦波（CPT tone）或者两个频率正弦波的叠加（DTMF tone），在信号处理上有相应的算法。

Tone generation分两个方向，local 和remote。Local是tone让自己听到，把生成的正弦波放到RX stream上；remote是tone让对端听到，把生成的正弦波放到TX stream上。对于像ring back tone等断续音还需要timer控制放多长时间停多长时间。

#### tone detection

tone detection，主要是指DTMF tone的detection，让软件知道哪个按键按下了，好进行后续的处理。有专门的算法（Goertzel戈泽尔算法）来detect DTMF的键值，把DTMF的音频信号（多帧的PCM信号）作为算法的输入，经过一定帧数后得到的就是DTMF的键值。

有时候我们需要告诉对端按下的是什么DTMF键，即要把键值传给对端，主要有三种方法，具体如下：

1. 把DTMF音频信号直接编码得到码流放在RTP中发给对端。对端收到RTP包后解码复原出音频信号，然后再通过DTMF detection算法得到键值。这通常被叫做in-band方法。

2. 在本端做DTMF detection得到键值，然后根据RFC2833（后来升级成RFC4733）组成RFC2833包发给对端。对端收到RFC2833包后去解析就知道是哪个键值了。这通常被叫做out-of-band方法。RFC2833包也是用RTP做承载，不过它的payload type是动态的（96~127之间一个值），payload共4个字节（32个比特），具体如下：

   ![](.\png\tone detection out-of-band.png)

   其中bit0-7（共8位）表示键值，bit8表示DTMF按键结束，bit9目前保留不用，bit10-15（共6位）表示按键信号的level（dBm表示），bit16-31（共16位）表示按键持续的时间（以采样值为单位）。一个DTMF键会生成多个RFC2833包，对同一个键值而言，这些包的sequence number会每次加1，但是timestamp不变，duration会持续增加，以8k采样率20ms为一包为例，第一个RFC2833包duration为160，第二个RFC2833包duration为320，依次向上加，直到END包（bit8置1）结束。END包会发3次（发3 次主要是为了防丢包），每个END包sequence number会加1，但是duration保持不变。

3. 在本端做DTMF detection得到键值，然后通过SIP信令的INFO带给对端，让对端知道是哪个键值。