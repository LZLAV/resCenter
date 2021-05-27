## RTP

RTP全称是Real-time Transport Protocol（实时传输协议），它是IETF提出的一个标准，对应的RFC文档为RFC3550。一般用其承载实时性要求很高的数据形成RTP包，在语音通信中，把PCM数据编码后得到的码流作为RTP的payload。



### 包结构

![](.\png\RTP包头结构.png)



```c
struct rtp_hdr
{
#if defined(IS_BIG_ENDIAN) && (IS_BIG_ENDIAN) != 0)
    uint16_t v:2;	/** package type/version */
    uint16_t p:1;	/** padding flag 		 */
    uint16_t x:1;	/** extension flag		 */
    uint16_t cc:4;	/** CSRC count			 */
    uint16_t m:1;	/** marker bit			 */
    uint16_t pt:7;	/** payload type		 */
#else
    uint16_t cc:4;	/** CSRC count			 */
    uint16_t x:1;	/** extension flag		 */
    uint16_t p:1;	/** padding flag 		 */
    uint16_t v:2;	/** package type/version */
    uint16_t pt:7;	/** payload type		 */
    uint16_t m:1;	/** marker bit			 */
#endif
    uint16_t seq;	/** sequence number 	 */
    uint16_t ts;	/** timestamp			 */
    uint16_t ssrc;	/** synchronization source	*/
};
```

M 位即Mark位，表示语音的开始，在通话刚开始的第一个语音包，M位要置1。如果 VAD使能，从VAD包切到语音包时，第一个语音包M位也要置1。

在通话刚开始的第一个语音包中，sequence/timestamp/SSRC等都要是随机值。在后续的包中，SSRC代表通话的一方，在整个通话过程中都要保持不变。Sequence要每次加一。Timestamp要依据采样率以及帧长每次加本帧内采样的点数值，比如8000 Hz采用率，帧长为20ms, 每次timestamp要加160。

发送方把每一帧PCM数据编码后得到码流，将其作为RTP的payload，同时填充好包头中的字段，然后通过UDP socket发送到网络中去。接收方通过UDP socket收到RTP包，解析包头得到payload type/sequence等信息，同时也得到payload，然后将它们送给下一个模块处理。

