## ffplay

#### main()

main()是FFplay的主函数。
调用了如下函数
	av_register_all()：注册所有编码器和解码器。
	show_banner()：打印输出FFmpeg版本信息（编译时间，编译选项，类库信息等）。
	parse_options()：解析输入的命令。
	SDL_Init()：SDL初始化。
	stream_open ()：打开输入媒体。
	event_loop()：处理各种消息，不停地循环下去

#### parse_options()

parse_options()解析全部输入选项。即将输入命令“ffplay -f h264 test.264”中的“-f”这样的命令解析出来。其函数调用结构如下图所示。需要注意的是，FFplay（ffplay.c）的parse_options()和FFmpeg（ffmpeg.c）中的parse_options()实际上是一样的。

#### stream_open()

stream_open()的作用是打开输入的媒体。这个函数还是比较复杂的，包含了FFplay中各种线程的创建。

stream_open()调用了如下函数：
	packet_queue_init()：初始化各个PacketQueue（视频/音频/字幕）
	read_thread()：读取媒体信息线程。

#### read_thread()

read_thread()调用了如下函数：

​	avformat_open_input()：打开媒体。

​	avformat_find_stream_info()：获得媒体信息。
​	av_dump_format()：输出媒体信息到控制台。
​	stream_component_open()：分别打开视频/音频/字幕解码线程。
​	refresh_thread()：视频刷新线程。
​	av_read_frame()：获取一帧压缩编码数据（即一个AVPacket）。
​	packet_queue_put()：根据压缩编码数据类型的不同（视频/音频/字幕），放到不同的PacketQueue中。

#### refresh_thread()

refresh_thread()调用了如下函数：

SDL_PushEvent(FF_REFRESH_EVENT)：发送FF_REFRESH_EVENT的SDL_Event

av_usleep()：每两次发送之间，间隔一段时间

#### stream_component_open()

stream_component_open()用于打开视频/音频/字幕解码的线程。

stream_component_open()调用了如下函数：
	avcodec_find_decoder()：获得解码器。
	avcodec_open2()：打开解码器。
	audio_open()：打开音频解码。
	SDL_PauseAudio(0)：SDL中播放音频的函数。
	video_thread()：创建视频解码线程。
	subtitle_thread()：创建字幕解码线程。
	packet_queue_start()：初始化PacketQueue。



audio_open()调用了如下函数
	SDL_OpenAudio()：SDL中打开音频设备的函数。注意它是根据SDL_AudioSpec参数打开音频设备。SDL_AudioSpec中的callback字段指定了音频播放的回调函数sdl_audio_callback()。当音频设备需要更多数据的时候，会调用该回调函数。因此该函数是会被反复调用的。



SDL_AudioSpec中指定的回调函数sdl_audio_callback()。
sdl_audio_callback()调用了如下函数
	audio_decode_frame()：解码音频数据。
	update_sample_display()：当不显示视频图像，而是显示音频波形的时候，调用此函数。



audio_decode_frame()调用了如下函数
	packet_queue_get()：获取音频压缩编码数据（一个AVPacket）。
	avcodec_decode_audio4()：解码音频压缩编码数据（得到一个AVFrame）。
	swr_init()：初始化libswresample中的SwrContext。libswresample用于音频采样采样数据（PCM）的转换。
	swr_convert()：转换音频采样率到适合系统播放的格式。
	swr_free()：释放SwrContext。



video_thread()调用了如下函数
	avcodec_alloc_frame()：初始化一个AVFrame。
	get_video_frame()：获取一个存储解码后数据的AVFrame。
	queue_picture()：

get_video_frame()调用了如下函数
	packet_queue_get()：获取视频压缩编码数据（一个AVPacket）。
	avcodec_decode_video2()：解码视频压缩编码数据（得到一个AVFrame）。



queue_picture()调用了如下函数
	SDL_LockYUVOverlay()：锁定一个SDL_Overlay。
	sws_getCachedContext()：初始化libswscale中的SwsContext。Libswscale用于图像的Raw格式数据（YUV，RGB）之间的转换。注意sws_getCachedContext()和sws_getContext()功能是一致的。
	sws_scale()：转换图像数据到适合系统播放的格式。
	SDL_UnlockYUVOverlay()：解锁一个SDL_Overlay。

subtitle_thread()调用了如下函数
	packet_queue_get()：获取字幕压缩编码数据（一个AVPacket）。avcodec_decode_subtitle2()：解码字幕压缩编码数据。



#### event_loop()

FFplay再打开媒体之后，便会进入event_loop()函数，永远不停的循环下去。该函数用于接收并处理各种各样的消息。有点像Windows的消息循环机制。



do_exit()函数调用了以下函数
	stream_close()：关闭打开的媒体。
	SDL_Quit()：关闭SDL。



stream_close()函数调用了以下函数
	packet_queue_destroy()：释放PacketQueue。
	SDL_FreeYUVOverlay()：释放SDL_Overlay。
	sws_freeContext()：释放SwsContext。





video_refresh()函数调用了以下函数
	video_display()：显示像素数据到屏幕上。
	show_status：这算不上是一个函数，但是是一个独立的功能模块，因此列了出来。该部分打印输出播放的状态至屏幕上。



video_display()函数调用了以下函数
	video_open()：初始化的时候调用，打开播放窗口。
	video_audio_display()：显示音频波形图（或者频谱图）的时候调用。里面包含了不少画图操作。
	video_image_display()：显示视频画面的时候调用。



video_open()函数调用了以下函数
	SDL_SetVideoMode()：设置SDL_Surface（即SDL最基础的黑色的框）的大小等信息。
	SDL_WM_SetCaption()：设置SDL_Surface对应窗口的标题文字。



video_audio_display()函数调用了以下函数
	SDL_MapRGB()：获得指定（R，G，B）以及SDL_PixelFormat的颜色数值。例如获得黑色的值，作为背景。（R，G，B）为（0x00，0x00，0x00）。
	fill_rectangle()：将指定颜色显示到屏幕上。
	SDL_UpdateRect()：更新屏幕。



video_image_display()函数调用了以下函数
	calculate_display_rect()：计算显示画面的位置。当拉伸了SDL的窗口的时候，可以让其中的视频保持纵横比。
	SDL_DisplayYUVOverlay()：显示画面至屏幕。