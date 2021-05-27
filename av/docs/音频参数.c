音频参数：
	
	libInit  
		
		default:
			
			clock_rate	: 时钟频率		default :16000
			
			channel_count : 声音通道	default :1
			audio_frame_ptime:音频帧长度	default:20ms
			max_media_ports: conferences bridge 支持的最大 port数	default: 12
			thread_cnt : media 线程数		default :1
			quality : 编码质量		dafault :4							Audio为 speex.quality
			ilbc_mode : 互联网低比特率编解码器	default :30
				ilbc 能以良好的语音质量处理丢帧。丢帧通常因连接丢失或者IP数据包延迟而发生。普通的低码率编解码器依赖语音帧之间的关系，这会导致数据包丢失或延迟时出错。与此相反，iLBC编码的语音帧是相互独立的，所以不会遇到此问题。
			ec_tail_len : 回声消除滤波器的长度	default:200ms
			snd_rec_latency : 录制音频缓冲长度，ms		100ms
			snd_play_latency ： 播放音频缓冲长度，ms	default ： 100ms
			
			jb_init：	Jitter buffer initial prefetch delay in msec.The value must be between jb_min_pre and jb_max_pre below. If the value is prefetching will be disabled. 0,	default:-1
			jb_min_pre：itter buffer minimum prefetch delay in msec		default：-1
			jb_max_pre：Jitter buffer maximum prefetch delay in msec	default：-1
			jb_max：Set maximum delay that can be accomodated by the jitter buffer msec.	default:-1
			
			snd_auto_close_time：Specify idle time of sound device before it is automatically closed in seconds. Use value -1 to disable the auto-close feature of sound device
			
			
			ice_max_host_cands：Set the maximum number of host candidates		default：-1 maximum not set
				ICE：交互式连接创建（Interactive Connectivity Establishment），一种综合性的NAT穿越的技术。
				交互式连接创建是由IETF的MMUSIC工作组开发出来的一种framework，可集成各种NAT穿透技术，如STUN、TURN（Traversal Using Relay NAT，中继NAT实现的穿透）、RSIP（Realm Specific IP，特定域IP）等。该framework可以让SIP的客户端利用各种NAT穿透方式打穿远程的防火墙。
			
			turn_conn_type：指定这个TURN服务的连接类型，有效值为 PJ_TURN_TP_UDP 和 PJ_TURN_TP_TCP		default：PJ_TURN_TP_UDP
		

aud_subsys_init:
			
	speex.options : default 0		
	speex.quality : default 5		(init)4
	speex.complexity : default 2	(init)-1
	ilbc.mode : default 30			(init)30
	passthrough.setting.ilbc_mode : default 30
	
	channel_count : 1
	bits_per_sample : 16
	samples_per_frame : 16000 * 1 * 20 /1000
	
	quality<3
		opt | = PJMEDIA_CONF_USE_LINEAR;	//Use linear resampling instead of filter
	quality4,3
		opt | = PJMEDIA_CONF_SMALL_FILTER;	//Use small filter table when resampling


Conference bridge conf

struct pjmedia_conf {
    unsigned options;    /**< Bitmask options.		    */
    unsigned max_ports;    /**< Maximum ports.		    */
    unsigned port_cnt;    /**< Current number of ports.	    */
    unsigned connect_cnt;    /**< Total number of connections    */
    pjmedia_snd_port *snd_dev_port;    /**< Sound device port.		    */
    pjmedia_port *master_port;    /**< Port zero's port.		    */
    char master_name_buf[80]; /**< Port0 name buffer.	    */
    pj_mutex_t *mutex;    /**< Conference mutex.		    */
    struct conf_port **ports;    /**< Array of ports.		    */
    unsigned clock_rate;    /**< Sampling rate.		    */
    unsigned channel_count;/**< Number of channels (1=mono).   */
    unsigned samples_per_frame;    /**< Samples per frame.	    */
    unsigned bits_per_sample;    /**< Bits per sample.	    */
};