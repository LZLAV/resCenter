## FFmpeg例子分析

#### main()

main()是FFmpeg的主函数。
调用了如下函数
av_register_all()：注册所有编码器和解码器。
show_banner()：打印输出FFmpeg版本信息（编译时间，编译选项，类库信息等）。
parse_options()：解析输入的命令。
transcode()：转码。
exit_progam()：退出和清理。

## parse_options()

parse_options()解析全部输入选项。即将输入命令 **“ffmpeg -i xxx.mpg -vcodec libx264 yyy.mkv”** 中的“-i”，“-vcodec”这样的命令解析出来。

定义位于 cmdutils.c 中。

调用了如下函数：
	parse_option()：解析一个输入选项。具体的解析步骤不再赘述。parse_options()会循环调用parse_option()直到所有选项解析完毕。FFmpeg的每一个选项信息存储在一个OptionDef结构体中。

##### OptionDef结构体

其中的重要字段：
	name：用于存储选项的名称。例如“i”，“f”，“codec”等等。
	flags：存储选项值的类型。例如：HAS_ARG（包含选项值），OPT_STRING（选项值为字符串类型），OPT_TIME（选项值为时间类型。
	u：存储该选项的处理函数。
	help：选项的说明信息。

FFmpeg使用一个名称为options，类型为OptionDef的数组存储所有的选项。有一部分通用选项存储在cmdutils_common_opts.h中。

在这里，例举一个选项的OptionDef结构体：输入

```c
{ "i",HAS_ARG | OPT_PERFILE, { (void*) opt_input_file }, "input file name", "filename" }
```

在这个结构体中，可以看出选项的名称为“i”，选项包含选项值（HAS_ARG），选项的处理函数是opt_input_file()，选项的说明是“input file name”。下面可以详细看一下选项的处理函数opt_input_file()。该函数的定义位于ffmpeg_opt.c文件中。可以看出，调用了avformat_alloc_context()初始化了AVFormatContext结构体，调用了avformat_open_input()函数打开了 **“-i”** 选项指定的文件。此外，调用了 avformat_find_stream_info() 等完成了一些初始化操作。此外，调用了av_dump_format()打印输出输入文件信息。

```c

static int opt_input_file(void *optctx, const char *opt, const char *filename)
{
    //略…
    /* open the input file with generic avformat function */
    err = avformat_open_input(&ic, filename, file_iformat, &format_opts);
    if (err < 0) {
        print_error(filename, err);
        exit(1);
    }
   
    //略…
    /* Set AVCodecContext options for avformat_find_stream_info */
    opts = setup_find_stream_info_opts(ic, codec_opts);
    orig_nb_streams = ic->nb_streams;
 
    /* If not enough info to get the stream parameters, we decode the
       first frames to get it. (used in mpeg case for example) */
    ret = avformat_find_stream_info(ic, opts);
    if (ret < 0) {
        av_log(NULL, AV_LOG_FATAL, "%s: could not find codec parameters\n", filename);
        avformat_close_input(&ic);
        exit(1);
    }
   
    //略…
    /* dump the file content */
    av_dump_format(ic, nb_input_files, filename, 0);
   
    //略…
    return 0;
}
```

#### transcode()

调用了如下函数
	transcode_init()：转码的初始化工作。
	check_keyboard_interaction()：检测键盘操作。例如转码的过程中按下“Q”键之后，会退出转码。
	transcode_step()：进行转码。
	print_report()：打印转码信息，输出到屏幕上。
	flush_encoder()：输出编码器中剩余的帧。
其中check_keyboard_interaction()，transcode_step()，print_report()三个函数位于一个循环之中会不断地执行。

##### transcode_init()

transcode_init()调用了以下几个重要的函数：
	av_dump_format()：在屏幕上打印输出格式信息。注意是输出格式的信息，输入格式的信息的打印是在parse_options()函数执行过程中调用opt_input_file()的时候打印到屏幕上的。
	init_input_stream()：其中调用了avcodec_open2()打开编码器。
	avformat_write_header()：写输出文件的文件头

##### transcode_step()

transcode_step()调用了如下函数：
	process_input()：完成解码工作。
	transcode_from_filter()：未分析。
	reap_filters()：完成编码工作。

##### process_input()

process_input()调用了如下函数：
	get_input_packet()：获取一帧压缩编码数据，即一个AVPacket。其中调用了av_read_frame()。

​	output_packet()：解码压缩编码的数据并将之送至AVFilterContext。 

​	output_packet()调用了如下函数：

​		decode_video()：解码一帧视频（一个AVPacket）。

​		decode_audio()：解码音频（并不一定是一帧，是一个AVPacket）。

​		do_streamcopy()：如果不需要重新编码的话，则调用此函数，一般用于封装格式之间的转换。速度比转码快很多。

​		 decode_video()调用了如下函数：

​				avcodec_decode_video2()：解码一帧视频。

​				rate_emu_sleep()：要求按照帧率处理数据的时候调用，可以避免FFmpeg处理速度过快。常用于网络实时流的处理（RTP/RTMP流的推送）。

​				configure_filtergraph()：设置AVFilterGraph。

​				av_buffersrc_add_frame()：将解码后的数据（一个AVFrame）送至AVFilterContext。 

​		decode_audio()调用的函数和decode_video()基本一样。唯一的不同在于其解码音频的函数是avcodec_decode_audio4() 

#### reap_filters()

reap_filters()调用了如下函数
	av_buffersink_get_buffer_ref()：从AVFilterContext中取出一帧解码后的数据（结构为AVFilterBufferRef，可以转换为AVFrame）。
	avfilter_copy_buf_props()：AVFilterBufferRef转换为AVFrame。
	do_audio_out()：编码音频。
	do_video_out()：编码视频。
	avfilter_unref_buffer()：释放资源。

​	do_video_out()调用了如下函数
​		avcodec_encode_video2()：编码一帧视频。
​		write_frame()：写入编码后的视频压缩数据。

​		write_frame()调用了如下函数：
​			av_bitstream_filter_filter()：使用AVBitStreamFilter的时候，会调用此函数进行处理。
​			av_interleaved_write_frame()：写入压缩编码数据。

​	do_audio_out()调用的函数与do_video_out()基本上一样。唯一的不同在于视频编码函数avcodec_encode_video2()变成了音频编码函数avcodec_encode_audio2()。

#### exit_program()

调用了如下函数：
	avfilter_graph_free()：释放AVFilterGraph。
	avformat_free_context()：释放输出文件的AVFormatContext。
	av_bitstream_filter_close()：关闭AVBitStreamFilter。
	avformat_close_input()：关闭输入文件。