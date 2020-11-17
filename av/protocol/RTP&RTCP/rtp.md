## RTP

建立在UDP 上，RTP用来为端到端的实时传输提供时间信息和流同步，但并不保证服务质量。服务质量由RTCP来提供。

### RTP的封装

#### RTP的头部格式

```
0                   1                   2                   3  
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1  
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  
|V=2|P|X|  CC   |M|     PT      |       sequence number         |  
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  
|                           timestamp                           |  
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+  
|           synchronization source (SSRC) identifier            |  
+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+  
|            contributing source (CSRC) identifiers             |  
|                             ....                              |  
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

```c
struct pjmedia_rtp_hdr
{
#if defined(PJ_IS_BIG_ENDIAN) && (PJ_IS_BIG_ENDIAN!=0)
    pj_uint16_t v:2;		/**< packet type/version	    */
    pj_uint16_t p:1;		/**< padding flag		    */
    pj_uint16_t x:1;		/**< extension flag		    */
    pj_uint16_t cc:4;		/**< CSRC count			    */
    pj_uint16_t m:1;		/**< marker bit			    */
    pj_uint16_t pt:7;		/**< payload type		    */
#else
    pj_uint16_t cc:4;		/**< CSRC count			    */
    pj_uint16_t x:1;		/**< header extension flag	    */ 
    pj_uint16_t p:1;		/**< padding flag		    */
    pj_uint16_t v:2;		/**< packet type/version	    */
    pj_uint16_t pt:7;		/**< payload type		    */
    pj_uint16_t m:1;		/**< marker bit			    */
#endif
    pj_uint16_t seq;		/**< sequence number		    */
    pj_uint32_t ts;		/**< timestamp			    */
    pj_uint32_t ssrc;		/**< synchronization source	    */
};
```

版本号（V）：2比特，用来标志使用的RTP版本。

填充位（P）：1比特，如果该位置位，则该RTP包的尾部就包含附加的填充字节。

扩展位（X）：1比特，如果该位置位的话，RTP固定头部后面就跟有一个扩展头部。

CSRC计数器（CC）：4比特，含有固定头部后面跟着的CSRC的数目。

标记位（M）：1比特,该位的解释由配置文档（Profile）来承担.

载荷类型（PT）：7比特，标识了RTP载荷的类型。 见 https://blog.csdn.net/caoshangpa/article/details/53008018

序列号（SN）：16比特，发送方在每发送完一个RTP包后就将该域的值增加1，**接收方可以由该域检测包的丢失及恢复包序列**。序列号的初始值是随机的。

时间戳：32比特，记录了该包中数据的第一个字节的采样时刻。在一次会话开始时，时间戳初始化成一个初始值。即使在没有信号发送时，时间戳的数值也要随时间而不断地增加。时间戳是去除抖动和实现同步不可缺少的。

同步源标识符(SSRC)：32比特，同步源就是指RTP包流的来源。**在同一个RTP会话中不能有两个相同的SSRC值**。该标识符是随机选取的 RFC1889推荐了MD5随机算法。

贡献源列表（CSRC List）：0～15项，每项32比特，用来标志对一个RTP混合器产生的新包有贡献的所有RTP包的源。由混合器将这些有贡献的SSRC标识符插入表中。SSRC标识符都被列出来，以便接收端能正确指出交谈双方的身份。



### RTCP的封装

RTP需要RTCP为其服务质量提供保证；**RTCP的计时信息，保证音视频同步**

RTCP的主要功能是：服务质量的监视与反馈、媒体间的同步，以及多播组中成员的标识。在RTP会话期间，各参与者周期性地传送RTCP包。RTCP包中含有已发送的数据包的数量、丢失的数据包的数量等统计资料，因此，各参与者可以利用这些信息动态地改变传输速率，甚至改变有效载荷类型。RTP和RTCP配合使用，它们能以有效的反馈和最小的开销使传输效率最佳化，因而特别适合传送网上的实时数据。



RTCP也是用UDP来传送的，但RTCP封装的仅仅是一些控制信息，因而分组很短，所以可以将多个RTCP分组封装在一个UDP包中。

| 类型 | 缩写表示                       | 用途       |
| ---- | ------------------------------ | ---------- |
| 200  | SR(Sender Report)              | 发送端报告 |
| 201  | RR(Receiver Report)            | 接收端报告 |
| 202  | SDES(Source Description Items) | 源点描述   |
| 203  | BYE                            | 结束传输   |
| 204  | APP                            | 特定应用   |

发送端报告分组SR（Sender Report）用来使发送端以多播方式向所有接收端报告发送情况。SR分组的主要内容有：相应的RTP流的SSRC，RTP流中最新产生的RTP分组的时间戳和NTP，RTP流包含的分组数，RTP流包含的字节数。



#### RTCP头部格式

```c
typedef struct pjmedia_rtcp_common
{
#if defined(PJ_IS_BIG_ENDIAN) && PJ_IS_BIG_ENDIAN!=0
    unsigned	    version:2;	/**< packet type            */
    unsigned	    p:1;	/**< padding flag           */
    unsigned	    count:5;	/**< varies by payload type */
    unsigned	    pt:8;	/**< payload type           */
#else
    unsigned	    count:5;	/**< varies by payload type */
    unsigned	    p:1;	/**< padding flag           */
    unsigned	    version:2;	/**< packet type            */
    unsigned	    pt:8;	/**< payload type           */
#endif
    unsigned	    length:16;	/**< packet length          */
    pj_uint32_t	    ssrc;	/**< SSRC identification    */
} pjmedia_rtcp_common;


/**
 * RTCP sender report.
 */
typedef struct pjmedia_rtcp_sr
{
    pj_uint32_t	    ntp_sec;	    /**< NTP time, seconds part.	*/
    pj_uint32_t	    ntp_frac;	    /**< NTP time, fractions part.	*/
    pj_uint32_t	    rtp_ts;	    /**< RTP timestamp.			*/
    pj_uint32_t	    sender_pcount;  /**< Sender packet cound.		*/
    pj_uint32_t	    sender_bcount;  /**< Sender octet/bytes count.	*/
} pjmedia_rtcp_sr;


/**
 * RTCP receiver report.
 */
typedef struct pjmedia_rtcp_rr
{
    pj_uint32_t	    ssrc;	    /**< SSRC identification.		*/
#if defined(PJ_IS_BIG_ENDIAN) && PJ_IS_BIG_ENDIAN!=0
    pj_uint32_t	    fract_lost:8;   /**< Fraction lost.			*/
    pj_uint32_t	    total_lost_2:8; /**< Total lost, bit 16-23.		*/
    pj_uint32_t	    total_lost_1:8; /**< Total lost, bit 8-15.		*/
    pj_uint32_t	    total_lost_0:8; /**< Total lost, bit 0-7.		*/
#else
    pj_uint32_t	    fract_lost:8;   /**< Fraction lost.			*/
    pj_uint32_t	    total_lost_2:8; /**< Total lost, bit 0-7.		*/
    pj_uint32_t	    total_lost_1:8; /**< Total lost, bit 8-15.		*/
    pj_uint32_t	    total_lost_0:8; /**< Total lost, bit 16-23.		*/
#endif	
    pj_uint32_t	    last_seq;	    /**< Last sequence number.		*/
    pj_uint32_t	    jitter;	    /**< Jitter.			*/
    pj_uint32_t	    lsr;	    /**< Last SR.			*/
    pj_uint32_t	    dlsr;	    /**< Delay since last SR.		*/
} pjmedia_rtcp_rr;


/**
 * This structure declares default RTCP packet (SR) that is sent by pjmedia.
 * Incoming RTCP packet may have different format, and must be parsed
 * manually by application.
 */
typedef struct pjmedia_rtcp_sr_pkt
{
    pjmedia_rtcp_common  common;	/**< Common header.	    */
    pjmedia_rtcp_sr	 sr;		/**< Sender report.	    */
    pjmedia_rtcp_rr	 rr;		/**< variable-length list   */
} pjmedia_rtcp_sr_pkt;

```

版本（V）：同RTP包头域。

填充（P）：同RTP包头域。

接收报告计数器（RC）：5比特，该SR包中的接收报告块的数目，可以为零。

包类型（PT）：8比特，SR包是200。

长度域（Length）：16比特，其中存放的是该SR包以32比特为单位的总长度减一。

同步源（SSRC）：SR包发送者的同步源标识符。与对应RTP包中的SSRC一样。当RTP session改变（如IP等）时，这个ID也要改变。

NTP Timestamp（Network time protocol）SR包发送时的绝对时间值。NTP的作用是同步不同的RTP媒体流。

RTP Timestamp：与NTP时间戳对应，与RTP数据包中的RTP时间戳具有相同的单位和随机初始值。

Sender’s packet count：从开始发送包到产生这个SR包这段时间里，发送者发送的RTP数据包的总数. SSRC改变时，这个域清零。

Sender`s octet count：从开始发送包到产生这个SR包这段时间里，发送者发送的净荷数据的总字节数（不包括头部和填充）。发送者改变其SSRC时，这个域要清零。

同步源n的SSRC标识符：该报告块中包含的是从该源接收到的包的统计信息。

丢失率（Fraction Lost）：表明从上一个SR或RR包发出以来从同步源n(SSRC_n)来的RTP数据包的丢失率。

累计的包丢失数目：从开始接收到SSRC_n的包到发送SR,从SSRC_n传过来的RTP数据包的丢失总数。

收到的扩展最大序列号：从SSRC_n收到的RTP数据包中最大的序列号，

接收抖动（Interarrival jitter）：RTP数据包接受时间的统计方差估计

上次SR时间戳（Last SR,LSR）：取最近从SSRC_n收到的SR包中的NTP时间戳的中间32比特。如果目前还没收到SR包，则该域清零。

上次SR以来的延时（Delay since last SR,DLSR）：上次从SSRC_n收到SR包到发送本报告的延时。



#### 常见问题

##### 绝对时间戳和相对时间戳在进行同步处理时有什么不同

当我们取得绝对时间后，我们就可以根据这个绝对时间来播放这些数据包。这个绝对时间，加上我们需要的延时（用于数据传输，解码等等的时间）就是我们的播放时间，这样我们可以保证时间的严格同步（相当于把对方的动作延时一段时间后原原本本的再现出来）。目前，在RTP中，能得到这个绝对时间的办法只有RTCP。

对于相对时间戳，我们更关心的是两个时间戳之间的时间间隔，依靠这个时间间隔，来确定两个包的播放时间间隔。



##### 单个媒体内的同步和不同媒体流之间的同步在处理方式上有什么不同

​       应该说，不同媒体之间同步比单媒体同步要复杂得多，除了要保证本身的播放要和时间同步外，还要保证两个或多个媒体间同步（比如音视频的同步）。这种不同更关心的两个时间戳时间的换算统一，前面我已经说过，不同编码有不同的采样频率，那么时间戳的增长速度就不同。另外，两个时间戳也需要有一个标准时间来表示时间戳的同步。最简单的方法是两个媒体的第一个时间戳相同，表示两个流的采集开始时间统一。另外还可以通过RTCP来做不同流之间的同步，这在下个问题中会提到。



##### RTCP 时间戳字段如何用于作为流间同步标识

在RTP协议中，我们取得时间戳的方法有两个：一个是RTP包中的时间戳，另外一个是RTCP包中的绝对时间戳和相对时间戳。绝对时间戳的概念上面我已经说了，它可以表示系统的绝对时间。而RTCP包中的相对时间就是RTP包中的时间。根据这两个时间，不同流都可以纠正自己播放时间和真正时间的偏差以达到和绝对时间同步的目的。**反过来说，如果我们没有办法拿到这个绝对时间，只有RTP包中的相对时间，那怎我们需要确定两个流在某一时间点的时间戳的数值。通俗的说，就是在某个时间点，流A的timestamp是多少，B是多少，然后根据这个时间两个流播放的延时时间，以达到同步的目的。实现这个目的最简单的办法是在两个流开始的时候，使用相同的stamp，拿音视频来说，在某一绝对时刻，采集相应的数据，并打上相同的时间戳，以后的播放，都以这个时间做基准时间，以保证同步**。



为什么一般都用 90000 作为视频采样频率呢？

90k是用于视频同步的时间尺度(TimeScale),就是每秒90k个时钟tick。为什么采用90k呢？目前视频的帧速率主要有25fps、29.97fps、30fps等，而90k刚好是它们的倍数，所以就采用了90k。



##### RTCP SR 的 RTP 时间戳计算

RTCP中的SR（Sender Report发送端报告）控制分组包含NTP（网络时间，是以1900-1-1零时为起点的系统绝对时间）时间戳和RTP时间戳（封装数据时候打上的时间戳与媒体帧上打上的时间戳不同）可用于同步音视频媒体流。其实现机制如下：

RTP时间戳是依据邻近的RTP数据包中的时间戳结合NTP时间差得到的，用公式表达为：

​	RTP_tsi = tsi + NTPi-NTP'i

其中：

​	RTP_tsi表示RTCP中的RTP时间戳；

​	tsi表示邻近的RTP包中的时间戳；

​	NTPi表示RTCP的网络时间戳；

​	NTP'i表示邻近的RTP包对应的网络时间戳；

​	下标表示第i个源。

RTP_tsj=tsj+NTPj—NTP'j 表示第j个源的RTP时间戳；

因此，i和源j之间的相对时差可以表示为：

（RTP_tsi – tsi） -( RTP_tsj - tsj) = (NTPi –NTP'i)- （NTPj—NTP'j）；

由于NTP同步，差值可以反映出两个源的相对时差。因为要同步不同来源的媒体流，必须使得同步他们的绝对时间基准，而NTP时间戳正是这样的绝对时间基准[4]。而对于同一来源的媒体流，应用RTP的时间戳来保证其同步。



##### 网络状态估算

假如视频数据从A发送到B,因此我们需要建立2个socket,一个负责从A发送RTP视频数据包到B,一个负责收发RTCP数据包.通过RTCP控制包中的信息判断网络状况更改码率适应网络带宽.A端周期性发送SR--发送者报告包给B端,B端周期性回复SR包,往A端发送RR--接收者报告包,告知A端接收状况,这样A端可以估算出现在的网络状况,调整A端发送速度,改善视频质量.具体的调整算法要经过网络测试获得,不是固定不变的.





### RTP的会话过程

当应用程序建立一个RTP会话时，应用程序将确定一对目的传输地址。目的传输地址由一个网络地址和一对端口组成，有两个端口：一个给RTP包，一个给RTCP包，使得RTP/RTCP数据能够正确发送。RTP数据发向偶数的UDP端口，而对应的控制信号RTCP数据发向相邻的奇数UDP端口（偶数的UDP端口＋1），这样就构成一个UDP端口对。

RTP 的发送过程如下，接收过程则相反：

1. RTP协议从上层接收流媒体信息码流（如H.263），封装成RTP数据包；RTCP从上层接收控制信息，封装成RTCP控制包。
2. RTP将RTP 数据包发往UDP端口对中偶数端口；RTCP将RTCP控制包发往UDP端口对中的奇数端口。



### RTP时间戳

RTP规定一次会话的初始时间戳必须随机选择，但协议没有规定时间戳的单位，也没有规定该值的精确解释，而是由负载类型来确定时钟的颗粒，这样各种应用类型可以根据需要选择合适的输出计时精度。

#### 时间戳单位

时间戳计算的单位不是秒之类的单位，而是由采样频率所代替的单位，这样做的目的就是为了是时间戳单位更为精准。比如说一个音频的采样频率为8000Hz，那么我们可以把时间戳单位设为1 / 8000。
    时间戳增量：相邻两个RTP包之间的时间差（以时间戳单位为基准）。
    采样频率：  每秒钟抽取样本的次数，例如音频的采样率一般为8000Hz
    帧率：      每秒传输或者显示帧数，例如25f/s

#### 时间戳增量

相邻两个RTP包之间的时间差（以时间戳单位为基准）。



其实，网络发送重点关注的是流量的平衡，即均匀地利用网络带宽，为了实现这一点，需要满足：数据采集的速率与数据网络传输的速率尽量保持一致。时间戳增量的设置影响的是RTP包的网络传输的速率，时间戳增量越小，发送速度越快。