
AVFormatContext *ic = NULL;
int err;

avdevice_register_all();
avformat_network_init();

ic = avformat_alloc_context();
//设置  AVFormatContext 相关相关变量

err = avformat_open_input(&ic, is->filename, is->iformat, &format_opts)

//获得文件相关信息
err = avformat_find_stream_info(ic, opts);

av_dict_get(ic->metadata, "title", NULL, 0);

//根据获取的 start__time 做相应的 seek
ret = avformat_seek_file(ic, -1, INT64_MIN, timestamp, INT64_MAX, 0);

//根据 AVMediaType type 获取音视频的子流
avformat_match_stream_specifier(ic, st, wanted_stream_spec[type])

//获取当前流最合适的编解码器
av_find_best_stream(ic, AVMEDIA_TYPE_VIDEO,
                                st_index[AVMEDIA_TYPE_VIDEO], -1, NULL, 0);


// 打开子流
stream_component_open(is, st_index[AVMEDIA_TYPE_AUDIO]);

    avcodec_alloc_context3(NULL);

    avcodec_parameters_to_context(avctx, ic->streams[stream_index]->codecpar);


    avcodec_find_decoder(avctx->codec_id);

    avcodec_find_decoder_by_name(forced_codec_name);

    opts = filter_codec_opts(codec_opts, avctx->codec_id, ic, ic->streams[stream_index], codec);

    av_dict_set(&opts, "threads", "auto", 0);


    avcodec_open2(avctx, codec, &opts);

        Audio:
            audio_open(is, channel_layout, nb_channels, sample_rate, &is->audio_tgt);

            decoder_init(&is->auddec, avctx, &is->audioq, is->continue_read_thread);

            decoder_start(&is->auddec, audio_thread, "audio_decoder", is);

        Video:
            
            decoder_init(&is->viddec, avctx, &is->videoq, is->continue_read_thread);

            decoder_start(&is->viddec, video_thread, "video_decoder", is)


        Subtitle:

            decoder_init(&is->subdec, avctx, &is->subtitleq, is->continue_read_thread);

            decoder_start(&is->subdec, subtitle_thread, "subtitle_decoder", is)
