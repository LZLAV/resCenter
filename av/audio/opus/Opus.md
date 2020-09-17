opus描述

​	opus/8000(12000 16000 24000 48000)





参数

```c
typedef struct pjmedia_codec_opus_config{    
    unsigned   sample_rate; /**< Sample rate in Hz.                     */    
    unsigned   channel_cnt; /**< Number of channels.                    */    
    unsigned   frm_ptime;   /**< Frame time in msec.             */    
    unsigned   bit_rate;    /**< Encoder bit rate in bps.     */    
    unsigned   packet_loss; /**< Encoder's expected packet loss pct.   */  //预期丢包率    
    unsigned   complexity;  /**< Encoder complexity, 0-10(10 is highest)*/    
    pj_bool_t  cbr;         /**< Constant bit rate?          */	//是否恒定码率
} pjmedia_codec_opus_config;
```

```c
struct {   
    unsigned       clock_rate;    /**< Sampling rate in Hz       */   
    unsigned       channel_cnt;       /**< Channel count.           */   
    pj_uint32_t avg_bps;       /**< Average bandwidth in bits/sec  */   
    pj_uint32_t max_bps;       /**< Maximum bandwidth in bits/sec  */   
    unsigned    max_rx_frame_size;   /**< Maximum frame size             */   
    pj_uint16_t frm_ptime;     /**< Decoder frame ptime in msec.   */   
    pj_uint16_t enc_ptime;     /**< Encoder ptime, or zero if it's        equal to decoder ptime.       */   
    pj_uint8_t  pcm_bits_per_sample;    /**< Bits/sample in the PCM side    */   
    pj_uint8_t  pt;       /**< Payload type.        */   
    pjmedia_format_id fmt_id;   /**< Source format, it's format of 
    							encoder input and decoder
    							output.*/
} info;
```

```c
struct {
    pj_uint8_t  frm_per_pkt;    /**< Number of frames per packet.  */
    unsigned    vad:1;     /**< Voice Activity Detector.  */
    unsigned    cng:1;     /**< Comfort Noise Generator.  */	//舒适噪声
    unsigned    penh:1;        /**< Perceptual Enhancement       */		//知觉增强
    unsigned    plc:1;     /**< Packet loss concealment   */
    unsigned    reserved:1;        /**< Reserved, must be zero.   */
    unsigned    vad_thredshold;    /** vad thredshold*/
    pjmedia_codec_fmtp enc_fmtp;/**< Encoder's fmtp params.       */
    pjmedia_codec_fmtp dec_fmtp;/**< Decoder's fmtp params.       */   
} setting;
```



类型

```c
#define OPUS_AUTO                           -1000 /**<Auto/default setting @hideinitializer*/
#define OPUS_BITRATE_MAX                       -1 
/**<Maximum bitrate @hideinitializer*//** Best for most VoIP/videoconference applications where listening quality and intelligibility matter most * @hideinitializer */
#define OPUS_APPLICATION_VOIP                2048
/** Best for broadcast/high-fidelity application where the decoded audio should be as close as possible to the input * @hideinitializer */
#define OPUS_APPLICATION_AUDIO               2049
/** Only use when lowest-achievable latency is what matters most. Voice-optimized modes cannot be used. * @hideinitializer */
#define OPUS_APPLICATION_RESTRICTED_LOWDELAY 2051#define OPUS_SIGNAL_VOICE                    3001 
/**< Signal being encoded is voice */
#define OPUS_SIGNAL_MUSIC  3002 /**< Signal being encoded is music */
```



- OPUS_APPLICATION_VOIP：在给定比特率条件下为声音信号提供最高质量，它通过高通滤波和强调共振峰和谐波增强了输入信号。它包括带内前向错误检查以预防包丢失。

- OPUS_APPLICATION_AUDIO：对大多数非语音信号，如音乐，在给定比特率条件下提供了最高的质量。使用这种模式的场合包括音乐、混音(音乐/声音),广播,和需要不到15 毫秒的信号延迟的其他应用。

- OPUS_APPLICATION_RESTRICTED_LOWDELAY：配置低延迟模式将为减少延迟禁用语音优化模式。这种模式只能在刚初始化或刚重设编码器的情况下使用，因为在这些情况下编解码器的延迟被修改了。

  当调用者知道语音优化模式不再需要时，配置低延迟模式是有用的。



带宽

​	4kHz  6kHz  8kHz  12kHz  20kHz---> 8000   12000  16000   24000   48000