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
`0                   1                   2                  3  
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ 
|V=2|P|   FMT   |       PT      |          length               | 
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ 
|                  SSRC of packet sender                        | 
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ 
|                  SSRC of media source                         | 
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+ 
:            Feedback Control Information (FCI)                 : 
:                                                               :`
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

  0                   		   1                   		   2                   		  3
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
0                   1                   2                   3      
0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1     
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

header 

|V=2|P|    RC   |   PT=RR=201   |             length            |     
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+     
|                     SSRC of packet sender                     |     +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+

report 

|                 SSRC_1 (SSRC of first source)                 |

block  

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
1    
| fraction lost |       cumulative number of packets lost       |     
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+     
|           extended highest sequence number received           |     
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+     
|                      interarrival jitter                      |     
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+     
|                         last SR (LSR)                         |     
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+     
|                   delay since last SR (DLSR)                  |     +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+

report 

|                 SSRC_2 (SSRC of second source)                |

block  

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
2    
:                               ...                             :     +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+     
|                  profile-specific extensions                  |     
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+`
```



##### common header

```c
struct
{
    unsigned int v:2;		//版本号
    unsigned int p:1;		//填充标识
    unsigned int rc:5;		//接收报告计数，5bit
    unsigned int pt:8;		//RTCP包的类型，8bit
    unsigned int length;	//包的长度
}RTCP_Header;
```

##### SR Header

```c
struct
{
    unsigned int TimeStamp;		//时间戳
    unsigned int PacketCount;	//发送包数
    unsigned int ssrc;			//同步源标识符
    unsigned int LostRate;		//丢包率
    unsigned int jitter;		//到达间隔抖动
    unsigned int MaxSeq;		//最大序列号
    unsigned int Lsr;			//最后到达的SR的时间戳
    unsigned int Dlsr;			//从最后一个发送端报告之后的延迟
}RTCP_Sender;
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
struct
{
    unsigned int ssrc;			//同步源标识符
    unsigned int LostPacket;	//丢包数
    unsigned int LostRate;		//丢包率
    unsigned int MaxSeq;		//最大序列号
    unsigned int Jitter;		//到达间隔抖动
    unsigned int Lsr;			//最后到达的 SR 的时间
    unsigned int Dlsr;			//从最后一个发送端报告之后的延迟
}RTCP_Receiver;
```

##### RR Packet

```c
typedef struct pjmedia_rtcp_rr_pkt
{
    pjmedia_rtcp_common  common;	/**< Common header.	    */
    RTCP_Receiver	 rr;		/**< variable-length list   */
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



#### RTCP_FB

##### rtcp_fb_type

```c
typedef enum pjmedia_rtcp_fb_type
{
    /**
     * Positive acknowledgement feedbacks. Sample subtypes are Reference Picture
     * Selection Indication (RPSI) and application layer feedbacks.
     */
    PJMEDIA_RTCP_FB_ACK,		//ack

    /**
     * Negative acknowledgement feedbacks. Sample subtypes are generic NACK,
     * Picture Loss Indication (PLI), Slice Loss Indication (SLI), Reference
     * Picture Selection Indication (RPSI), and application layer feedbacks.
     */
    PJMEDIA_RTCP_FB_NACK,		//nack

    /**
     * Minimum interval between two regular RTCP packets.
     */
    PJMEDIA_RTCP_FB_TRR_INT,	//trr-int

    /**
     * Other feedback types.
     */
    PJMEDIA_RTCP_FB_OTHER

} pjmedia_rtcp_fb_type;
```

##### rtcp_fb_cap

```c
typedef struct pjmedia_rtcp_fb_cap
{
    /**
     * Specify the codecs to which the capability is applicable. Codec ID is
     * using the same format as in pjmedia_codec_mgr_find_codecs_by_id() and
     * pjmedia_vid_codec_mgr_find_codecs_by_id(), e.g: "L16/8000/1", "PCMU",
     * "H264". This can also be an asterisk ("*") to represent all codecs.
     */
    pj_str_t		    codec_id;

    /**
     * Specify the RTCP Feedback type.
     */
    pjmedia_rtcp_fb_type    type;

    /**
     * Specify the type name if RTCP Feedback type is PJMEDIA_RTCP_FB_OTHER.
     */
    pj_str_t		    type_name;

    /**
     * Specify the RTCP Feedback parameters. Feedback subtypes should be
     * specified in this field, e.g:
     * - 'pli' for Picture Loss Indication feedback,
     * - 'sli' for Slice Loss Indication feedback,
     * - 'rpsi' for Reference Picture Selection Indication feedback,
     * - 'app' for specific/proprietary application layer feedback.
     */
    pj_str_t		    param;

} pjmedia_rtcp_fb_cap;
```

##### rtcp_fb_nack

```c
typedef struct pjmedia_rtcp_fb_nack
{
    pj_int32_t		 pid;		/**< Packet ID (RTP seq) */
    pj_uint16_t		 blp;		/**< Bitmask of following lost packets */
} pjmedia_rtcp_fb_nack;
```

###### build

```c
PJ_DEF(pj_status_t) pjmedia_rtcp_fb_build_nack(
        pjmedia_rtcp_session *session,
        void *buf,
        pj_size_t *length,
        unsigned nack_cnt,
        const pjmedia_rtcp_fb_nack nack[]) {
    pjmedia_rtcp_common *hdr;
    pj_uint8_t *p;
    unsigned len, i;

    PJ_ASSERT_RETURN(session && buf && length && nack_cnt && nack, PJ_EINVAL);

    len = (3 + nack_cnt) * 4;
    if (len > *length)
        return PJ_ETOOSMALL;

    /* Build RTCP-FB NACK header */
    hdr = (pjmedia_rtcp_common *) buf;
    pj_memcpy(hdr, &session->rtcp_rr_pkt.common, sizeof(*hdr));
    hdr->pt = RTCP_RTPFB;
    hdr->count = 1; /* FMT = 1 */
    hdr->length = pj_htons((pj_uint16_t) (len / 4 - 1));

    /* Build RTCP-FB NACK FCI */
    p = (pj_uint8_t *) hdr + sizeof(*hdr);
    for (i = 0; i < nack_cnt; ++i) {
        pj_uint16_t val;
        val = pj_htons((pj_uint16_t) nack[i].pid);
        pj_memcpy(p, &val, 2);
        val = pj_htons(nack[i].blp);
        pj_memcpy(p + 2, &val, 2);
        p += 4;
    }

    /* Finally */
    *length = len;

    return PJ_SUCCESS;
}
```

##### pli

pjmedia_rtcp_common 中参数设置为：

> type = 206
>
> count = 1

##### rtcp_fb_sli

```c
typedef struct pjmedia_rtcp_fb_sli
{
    pj_uint16_t		 first;		/**< First lost macroblock */ 第一个丢失的宏块
    pj_uint16_t		 number;	/**< The number of lost macroblocks packets */
    pj_uint8_t		 pict_id;	/**< Picture ID (temporal ref) */
} pjmedia_rtcp_fb_sli;
```

###### build sli

```c
PJ_DEF(pj_status_t) pjmedia_rtcp_fb_build_sli(
        pjmedia_rtcp_session *session,
        void *buf,
        pj_size_t *length,
        unsigned sli_cnt,
        const pjmedia_rtcp_fb_sli sli[]) {
    pjmedia_rtcp_common *hdr;
    pj_uint8_t *p;
    unsigned len, i;

    PJ_ASSERT_RETURN(session && buf && length && sli_cnt && sli, PJ_EINVAL);

    len = (3 + sli_cnt) * 4;
    if (len > *length)
        return PJ_ETOOSMALL;

    /* Build RTCP-FB SLI header */
    hdr = (pjmedia_rtcp_common *) buf;
    pj_memcpy(hdr, &session->rtcp_rr_pkt.common, sizeof(*hdr));
    hdr->pt = RTCP_PSFB;
    hdr->count = 2; /* FMT = 2 */
    hdr->length = pj_htons((pj_uint16_t) (len / 4 - 1));

    /* Build RTCP-FB SLI FCI */
    p = (pj_uint8_t *) hdr + sizeof(*hdr);
    for (i = 0; i < sli_cnt; ++i) {
        /* 'first' takes 13 bit */
        *p++ = (pj_uint8_t) ((sli[i].first >> 5) & 0xFF);   /* 8 MSB bits */
        *p = (pj_uint8_t) ((sli[i].first & 31) << 3);        /* 5 LSB bits */
        /* 'number' takes 13 bit */
        *p++ |= (pj_uint8_t) ((sli[i].number >> 10) & 7);    /* 3 MSB bits */
        *p++ = (pj_uint8_t) ((sli[i].number >> 2) & 0xFF);  /* 8 mid bits */
        *p = (pj_uint8_t) ((sli[i].number & 3) << 6);        /* 2 LSB bits */
        /* 'pict_id' takes 6 bit */
        *p++ |= (sli[i].pict_id & 63);
    }

    /* Finally */
    *length = len;

    return PJ_SUCCESS;
}
```



##### rtcp_fb_rpsi

```c
typedef struct pjmedia_rtcp_fb_rpsi
{
    pj_uint8_t		 pt;		/**< Payload Type */
    pj_str_t		 rpsi;		/**< Native RPSI bit string	*/
    pj_size_t		 rpsi_bit_len;	/**< Length of RPSI in bit */
} pjmedia_rtcp_fb_rpsi;
```

###### build

```c
PJ_DEF(pj_status_t) pjmedia_rtcp_fb_build_rpsi(
        pjmedia_rtcp_session *session,
        void *buf,
        pj_size_t *length,
        const pjmedia_rtcp_fb_rpsi *rpsi) {
    pjmedia_rtcp_common *hdr;
    pj_uint8_t *p;
    unsigned bitlen, padlen, len;

    PJ_ASSERT_RETURN(session && buf && length && rpsi, PJ_EINVAL);

    bitlen = rpsi->rpsi_bit_len + 16;
    padlen = (32 - (bitlen % 32)) % 32;
    len = (3 + (bitlen + padlen) / 32) * 4;
    if (len > *length)
        return PJ_ETOOSMALL;

    /* Build RTCP-FB RPSI header */
    hdr = (pjmedia_rtcp_common *) buf;
    pj_memcpy(hdr, &session->rtcp_rr_pkt.common, sizeof(*hdr));
    hdr->pt = RTCP_PSFB;
    hdr->count = 3; /* FMT = 3 */
    hdr->length = pj_htons((pj_uint16_t) (len / 4 - 1));

    /* Build RTCP-FB RPSI FCI */
    p = (pj_uint8_t *) hdr + sizeof(*hdr);
    /* PB (number of padding bits) */
    *p++ = (pj_uint8_t) padlen;
    /* Payload type */
    *p++ = rpsi->pt & 0x7F;
    /* RPSI bit string */
    pj_memcpy(p, rpsi->rpsi.ptr, rpsi->rpsi_bit_len / 8);
    p += rpsi->rpsi_bit_len / 8;
    if (rpsi->rpsi_bit_len % 8) {
        *p++ = *(rpsi->rpsi.ptr + rpsi->rpsi_bit_len / 8);
    }
    /* Zero padding */
    if (padlen >= 8)
        pj_bzero(p, padlen / 8);

    /* Finally */
    *length = len;

    return PJ_SUCCESS;
}
```

nack、sli、rpsi 等数据包分组可以附加到其他 RTCP 分组，例如  RR、SR，以组成复合 RTCP 分组。

RTCP 反馈特定信息编码到本地SDP 中，表明本地端点有能力并且愿意接收本地SDP 中描述的 RTCP 反馈数据包。也从 SDP 媒体解码RTCP Fb 特定信息。