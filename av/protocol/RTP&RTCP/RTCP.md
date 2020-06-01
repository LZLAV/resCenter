RTCP 协议

RTCP与RTP联合工作，RTP实施实际数据的传输，RTCP则负责将控制包送至电话中的每个人。其主要功能是就RTP正在提供的服务质量(Quality of Service)做出反馈。



作用

- 主要是提供数据发布的质量反馈
- RTCP带有称作规范名字（CNAME）的RTP源持久传输层标识
- 传送最小连接控制信息，如参加者辨识

#### RTCP分类

| 类型 |               缩写               |    用途    |
| :--: | :------------------------------: | :--------: |
| 200  |       SR（Sender Report）        | 发送端报告 |
| 201  |      RR（Receiver Report）       | 接收端报告 |
| 202  | SDES（Source Description Items） |  源点描述  |
| 203  |               BYE                |  结束传输  |
| 204  |               APP                |  特定应用  |

#### RTCP的扩展

| 类型 |            缩写            |      用途      |                     所在RFC                     |
| :--: | :------------------------: | :------------: | :---------------------------------------------: |
| 195  | 1J(Extended Jitter Report) | 扩展Jitter报告 |                    RFC 5450                     |
| 205  |    RTPFB(Transport FB)     |   传输层反馈   | [RFC 4585](https://tools.ietf.org/html/rfc4585) |
| 206  | PSFB(Payload-specific FB)  |  负载相关反馈  |                    RFC 5104                     |
| 207  |    XR(Exteneded Report)    |    扩展报告    |                    RFC 3611                     |

> FB: Feedback(反馈)

#### 反馈报文

类型

- Transport layer FB messages
- Payload-specific FB messages
- Application layer FB messages

##### 报文格式

```
`0                   1                   2                   3  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ |V=2|P|   FMT   |       PT      |          length               | +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ |                  SSRC of packet sender                        | +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ |                  SSRC of media source                         | +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ :            Feedback Control Information (FCI)                 : :                                                               :`
```

- version(V), 2bits : 标识当前RTP版本2
- padding(P), 1bit : 填充位标识
- Feedback message type(FMT), 5bits : 标识反馈消息的类型
- Payload type (PT), 8 bits : rtcp包的类型
- Length, 16 bits :

##### FMT报文子类型

| 类型 | 子类型 |     缩写     |                        用途                         |
| :--: | :----: | :----------: | :-------------------------------------------------: |
| 205  |   1    | Generic NACK |                     RTP丢包重传                     |
|  -   |   3    |    TMMBR     |   Temporary Maximum Media Stream Bitrate Request    |
|  -   |   4    |    TMMBN     | Temporary Maximum Media Stream Bitrate Notification |
| 206  |   1    |     PLI      |               Picture Loss Indication               |

##### Generic NACK

> The Generic NACK message is identified by `PT=RTPFB` and `FMT=1`.

0                   			1                   			2                   		  3
  0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
 |            PID                				|             		BLP               	|
 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

- PID: Packet ID (PID): 16 bits
  - 丢失RTP包的ID
- BLP: bitmask of following lost packets (BLP): 16 bits
  - 从PID开始接下来16个RTP数据包的丢失情况,一个NACK报文可以携带多个RTP序列号，NACK接收端对这些序列号逐个处理。

##### 丢包重传

如果在接收端检查到出现丢包现象,通过RTCP发送丢包ID接可以让丢包重传.

```c
static void RequestLostPacket(rtp_t *rtp, unsigned int rtpSsrc, int seqNo)
{
    char FB_msg_packet[128] = {0};
    unsigned int srcId = rtpSsrc;
    int blp = 0; //表示一个只处理一个丢包

    FB_msg_packet[0] = 0x80 | 1;  // version=2, Generic NACK
    FB_msg_packet[1] = 205;       // RTPFB
    FB_msg_packet[2] = 0;
    FB_msg_packet[3] = 3;         //length = 3

    // SSRC of packet sender
    FB_msg_packet[4] = 0xde;      
    FB_msg_packet[5] = 0xad;
    FB_msg_packet[6] = 0xbe;
    FB_msg_packet[7] = 0xef;

    //SSRC of media source
    FB_msg_packet[8] = (srcId >> 24) & 0xff;      
    FB_msg_packet[9] = (srcId >> 16) & 0xff;
    FB_msg_packet[10] = (srcId >> 8) & 0xff;
    FB_msg_packet[11] = (srcId & 0xff);

    //lost packet ID
    FB_msg_packet[12] = (seqNo >> 8) & 0xff;
    FB_msg_packet[13] = (seqNo & 0xff);

    //BLP
    FB_msg_packet[14] = (blp >> 8) & 0xff;        
    FB_msg_packet[15] = (blp & 0xff);

    net_session_write(&rtp->rtcp_net, FB_msg_packet, 16);
}
```

#### 其他格式

##### SR: Sender Report RTCP Packet

```
		0                   1                   2                   3
        0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
header |V=2|P|    RC   |   PT=SR=200   |             length            |
       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       |                         SSRC of sender                        |
       +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
sender |              NTP timestamp, most significant word             |
info   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       |             NTP timestamp, least significant word             |
       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       |                         RTP timestamp                         |
       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       |                     sender's packet count                     |
       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       |                      sender's octet count                     |
       +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
report |                 SSRC_1 (SSRC of first source)                 |
block  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  1    | fraction lost |       cumulative number of packets lost       |
       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       |           extended highest sequence number received           |
       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       |                      interarrival jitter                      |
       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       |                         last SR (LSR)                         |
       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
       |                   delay since last SR (DLSR)                  |
       +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
report |                 SSRC_2 (SSRC of second source)                |
block  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  2    :                               ...                             :
       +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
       |                  profile-specific extensions                  |
       +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

##### RR: Receiver Report RTCP Packet

```
`0                   1                   2                   3      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+header |V=2|P|    RC   |   PT=RR=201   |             length            |     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+     |                     SSRC of packet sender                     |     +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+report |                 SSRC_1 (SSRC of first source)                 |block  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+1    | fraction lost |       cumulative number of packets lost       |     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+     |           extended highest sequence number received           |     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+     |                      interarrival jitter                      |     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+     |                         last SR (LSR)                         |     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+     |                   delay since last SR (DLSR)                  |     +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+report |                 SSRC_2 (SSRC of second source)                |block  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+2    :                               ...                             :     +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+     |                  profile-specific extensions                  |     +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+`
```



##### common header

```c
/**
 * RTCP common header.
 */
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
```

##### SR Header

```c
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
```

##### SR Packet

```c
typedef struct pjmedia_rtcp_sr_pkt
{
    pjmedia_rtcp_common  common;	/**< Common header.	    */
    pjmedia_rtcp_sr	 sr;		/**< Sender report.	    */
    pjmedia_rtcp_rr	 rr;		/**< variable-length list   */
} pjmedia_rtcp_sr_pkt;
```



##### RR Header

```C
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
```

##### RR Packet

```c
typedef struct pjmedia_rtcp_rr_pkt
{
    pjmedia_rtcp_common  common;	/**< Common header.	    */
    pjmedia_rtcp_rr	 rr;		/**< variable-length list   */
} pjmedia_rtcp_rr_pkt;
```

##### SDES

```C
typedef struct pjmedia_rtcp_sdes
{
    pj_str_t	cname;		/**< RTCP SDES type CNAME.	*/
    pj_str_t	name;		/**< RTCP SDES type NAME.	*/
    pj_str_t	email;		/**< RTCP SDES type EMAIL.	*/
    pj_str_t	phone;		/**< RTCP SDES type PHONE.	*/
    pj_str_t	loc;		/**< RTCP SDES type LOC.	*/
    pj_str_t	tool;		/**< RTCP SDES type TOOL.	*/
    pj_str_t	note;		/**< RTCP SDES type NOTE.	*/
} pjmedia_rtcp_sdes;
```





parse_fb

