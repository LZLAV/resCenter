typedef struct AVFormatContext {
    /**
     * A class for logging and @ref avoptions. Set by avformat_alloc_context().
     * Exports (de)muxer private options if they exist.
     */
    const AVClass *av_class;

    /**
     * The input container format.
     *
     * Demuxing only, set by avformat_open_input().
     */
    ff_const59 struct AVInputFormat *iformat;

    /**
     * The output container format.
     *
     * Muxing only, must be set by the caller before avformat_write_header().
     */
    ff_const59 struct AVOutputFormat *oformat;

    /**
     * Format private data. This is an AVOptions-enabled struct
     * if and only if iformat/oformat.priv_class is not NULL.
     *
     * - muxing: set by avformat_write_header()
     * - demuxing: set by avformat_open_input()
     */
    void *priv_data;

    /**
     * I/O context.
     *
     * - demuxing: either set by the user before avformat_open_input() (then
     *             the user must close it manually) or set by avformat_open_input().
     * - muxing: set by the user before avformat_write_header(). The caller must
     *           take care of closing / freeing the IO context.
     *
     * Do NOT set this field if AVFMT_NOFILE flag is set in
     * iformat/oformat.flags. In such a case, the (de)muxer will handle
     * I/O in some other way and this field will be NULL.
     */
    AVIOContext *pb;

    /* stream info */
    /**
     * Flags signalling stream properties. A combination of AVFMTCTX_*.
     * Set by libavformat.
     */
    int ctx_flags;

    /**
     * Number of elements in AVFormatContext.streams.
     *
     * Set by avformat_new_stream(), must not be modified by any other code.
     */
    unsigned int nb_streams;
    /**
     * A list of all streams in the file. New streams are created with
     * avformat_new_stream().
     *
     * - demuxing: streams are created by libavformat in avformat_open_input().
     *             If AVFMTCTX_NOHEADER is set in ctx_flags, then new streams may also
     *             appear in av_read_frame().
     * - muxing: streams are created by the user before avformat_write_header().
     *
     * Freed by libavformat in avformat_free_context().
     */
    AVStream **streams;

#if FF_API_FORMAT_FILENAME
    /**
     * input or output filename
     *
     * - demuxing: set by avformat_open_input()
     * - muxing: may be set by the caller before avformat_write_header()
     *
     * @deprecated Use url instead.
     */
    attribute_deprecated
    char filename[1024];
#endif

    /**
     * input or output URL. Unlike the old filename field, this field has no
     * length restriction.
     *
     * - demuxing: set by avformat_open_input(), initialized to an empty
     *             string if url parameter was NULL in avformat_open_input().
     * - muxing: may be set by the caller before calling avformat_write_header()
     *           (or avformat_init_output() if that is called first) to a string
     *           which is freeable by av_free(). Set to an empty string if it
     *           was NULL in avformat_init_output().
     *
     * Freed by libavformat in avformat_free_context().
     */
    char *url;

    /**
     * Position of the first frame of the component, in
     * AV_TIME_BASE fractional seconds. NEVER set this value directly:
     * It is deduced from the AVStream values.
     *
     * Demuxing only, set by libavformat.
     */
    int64_t start_time;

    /**
     * Duration of the stream, in AV_TIME_BASE fractional
     * seconds. Only set this value if you know none of the individual stream
     * durations and also do not set any of them. This is deduced from the
     * AVStream values if not set.
     *
     * Demuxing only, set by libavformat.
     */
    int64_t duration;

    /**
     * Total stream bitrate in bit/s, 0 if not
     * available. Never set it directly if the file_size and the
     * duration are known as FFmpeg can compute it automatically.
     */
    int64_t bit_rate;

    unsigned int packet_size;
    int max_delay;

    /**
     * Flags modifying the (de)muxer behaviour. A combination of AVFMT_FLAG_*.
     * Set by the user before avformat_open_input() / avformat_write_header().
     */
    int flags;
#define AVFMT_FLAG_GENPTS       0x0001 ///< Generate missing pts even if it requires parsing future frames.
#define AVFMT_FLAG_IGNIDX       0x0002 ///< Ignore index.
#define AVFMT_FLAG_NONBLOCK     0x0004 ///< Do not block when reading packets from input.
#define AVFMT_FLAG_IGNDTS       0x0008 ///< Ignore DTS on frames that contain both DTS & PTS
#define AVFMT_FLAG_NOFILLIN     0x0010 ///< Do not infer any values from other values, just return what is stored in the container
#define AVFMT_FLAG_NOPARSE      0x0020 ///< Do not use AVParsers, you also must set AVFMT_FLAG_NOFILLIN as the fillin code works on frames and no parsing -> no frames. Also seeking to frames can not work if parsing to find frame boundaries has been disabled
#define AVFMT_FLAG_NOBUFFER     0x0040 ///< Do not buffer frames when possible
#define AVFMT_FLAG_CUSTOM_IO    0x0080 ///< The caller has supplied a custom AVIOContext, don't avio_close() it.
#define AVFMT_FLAG_DISCARD_CORRUPT  0x0100 ///< Discard frames marked corrupted
#define AVFMT_FLAG_FLUSH_PACKETS    0x0200 ///< Flush the AVIOContext every packet.
/**
 * When muxing, try to avoid writing any random/volatile data to the output.
 * This includes any random IDs, real-time timestamps/dates, muxer version, etc.
 *
 * This flag is mainly intended for testing.
 */
#define AVFMT_FLAG_BITEXACT         0x0400
#if FF_API_LAVF_MP4A_LATM
#define AVFMT_FLAG_MP4A_LATM    0x8000 ///< Deprecated, does nothing.
#endif
#define AVFMT_FLAG_SORT_DTS    0x10000 ///< try to interleave outputted packets by dts (using this flag can slow demuxing down)
#define AVFMT_FLAG_PRIV_OPT    0x20000 ///< Enable use of private options by delaying codec open (this could be made default once all code is converted)
#if FF_API_LAVF_KEEPSIDE_FLAG
#define AVFMT_FLAG_KEEP_SIDE_DATA 0x40000 ///< Deprecated, does nothing.
#endif
#define AVFMT_FLAG_FAST_SEEK   0x80000 ///< Enable fast, but inaccurate seeks for some formats
#define AVFMT_FLAG_SHORTEST   0x100000 ///< Stop muxing when the shortest stream stops.
#define AVFMT_FLAG_AUTO_BSF   0x200000 ///< Add bitstream filters as requested by the muxer

    /**
     * Maximum size of the data read from input for determining
     * the input container format.
     * Demuxing only, set by the caller before avformat_open_input().
     */
    int64_t probesize;

    /**
     * Maximum duration (in AV_TIME_BASE units) of the data read
     * from input in avformat_find_stream_info().
     * Demuxing only, set by the caller before avformat_find_stream_info().
     * Can be set to 0 to let avformat choose using a heuristic.
     */
    int64_t max_analyze_duration;

    const uint8_t *key;
    int keylen;

    unsigned int nb_programs;
    AVProgram **programs;

    /**
     * Forced video codec_id.
     * Demuxing: Set by user.
     */
    enum AVCodecID video_codec_id;

    /**
     * Forced audio codec_id.
     * Demuxing: Set by user.
     */
    enum AVCodecID audio_codec_id;

    /**
     * Forced subtitle codec_id.
     * Demuxing: Set by user.
     */
    enum AVCodecID subtitle_codec_id;

    /**
     * Maximum amount of memory in bytes to use for the index of each stream.
     * If the index exceeds this size, entries will be discarded as
     * needed to maintain a smaller size. This can lead to slower or less
     * accurate seeking (depends on demuxer).
     * Demuxers for which a full in-memory index is mandatory will ignore
     * this.
     * - muxing: unused
     * - demuxing: set by user
     */
    unsigned int max_index_size;

    /**
     * Maximum amount of memory in bytes to use for buffering frames
     * obtained from realtime capture devices.
     */
    unsigned int max_picture_buffer;

    /**
     * Number of chapters in AVChapter array.
     * When muxing, chapters are normally written in the file header,
     * so nb_chapters should normally be initialized before write_header
     * is called. Some muxers (e.g. mov and mkv) can also write chapters
     * in the trailer.  To write chapters in the trailer, nb_chapters
     * must be zero when write_header is called and non-zero when
     * write_trailer is called.
     * - muxing: set by user
     * - demuxing: set by libavformat
     */
    unsigned int nb_chapters;
    AVChapter **chapters;

    /**
     * Metadata that applies to the whole file.
     *
     * - demuxing: set by libavformat in avformat_open_input()
     * - muxing: may be set by the caller before avformat_write_header()
     *
     * Freed by libavformat in avformat_free_context().
     */
    AVDictionary *metadata;

    /**
     * Start time of the stream in real world time, in microseconds
     * since the Unix epoch (00:00 1st January 1970). That is, pts=0 in the
     * stream was captured at this real world time.
     * - muxing: Set by the caller before avformat_write_header(). If set to
     *           either 0 or AV_NOPTS_VALUE, then the current wall-time will
     *           be used.
     * - demuxing: Set by libavformat. AV_NOPTS_VALUE if unknown. Note that
     *             the value may become known after some number of frames
     *             have been received.
     */
    int64_t start_time_realtime;

    /**
     * The number of frames used for determining the framerate in
     * avformat_find_stream_info().
     * Demuxing only, set by the caller before avformat_find_stream_info().
     */
    int fps_probe_size;

    /**
     * Error recognition; higher values will detect more errors but may
     * misdetect some more or less valid parts as errors.
     * Demuxing only, set by the caller before avformat_open_input().
     */
    int error_recognition;

    /**
     * Custom interrupt callbacks for the I/O layer.
     *
     * demuxing: set by the user before avformat_open_input().
     * muxing: set by the user before avformat_write_header()
     * (mainly useful for AVFMT_NOFILE formats). The callback
     * should also be passed to avio_open2() if it's used to
     * open the file.
     */
    AVIOInterruptCB interrupt_callback;

    /**
     * Flags to enable debugging.
     */
    int debug;
#define FF_FDEBUG_TS        0x0001

    /**
     * Maximum buffering duration for interleaving.
     *
     * To ensure all the streams are interleaved correctly,
     * av_interleaved_write_frame() will wait until it has at least one packet
     * for each stream before actually writing any packets to the output file.
     * When some streams are "sparse" (i.e. there are large gaps between
     * successive packets), this can result in excessive buffering.
     *
     * This field specifies the maximum difference between the timestamps of the
     * first and the last packet in the muxing queue, above which libavformat
     * will output a packet regardless of whether it has queued a packet for all
     * the streams.
     *
     * Muxing only, set by the caller before avformat_write_header().
     */
    int64_t max_interleave_delta;

    /**
     * Allow non-standard and experimental extension
     * @see AVCodecContext.strict_std_compliance
     */
    int strict_std_compliance;

    /**
     * Flags indicating events happening on the file, a combination of
     * AVFMT_EVENT_FLAG_*.
     *
     * - demuxing: may be set by the demuxer in avformat_open_input(),
     *   avformat_find_stream_info() and av_read_frame(). Flags must be cleared
     *   by the user once the event has been handled.
     * - muxing: may be set by the user after avformat_write_header() to
     *   indicate a user-triggered event.  The muxer will clear the flags for
     *   events it has handled in av_[interleaved]_write_frame().
     */
    int event_flags;
/**
 * - demuxing: the demuxer read new metadata from the file and updated
 *   AVFormatContext.metadata accordingly
 * - muxing: the user updated AVFormatContext.metadata and wishes the muxer to
 *   write it into the file
 */
#define AVFMT_EVENT_FLAG_METADATA_UPDATED 0x0001

    /**
     * Maximum number of packets to read while waiting for the first timestamp.
     * Decoding only.
     */
    int max_ts_probe;

    /**
     * Avoid negative timestamps during muxing.
     * Any value of the AVFMT_AVOID_NEG_TS_* constants.
     * Note, this only works when using av_interleaved_write_frame. (interleave_packet_per_dts is in use)
     * - muxing: Set by user
     * - demuxing: unused
     */
    int avoid_negative_ts;
#define AVFMT_AVOID_NEG_TS_AUTO             -1 ///< Enabled when required by target format
#define AVFMT_AVOID_NEG_TS_MAKE_NON_NEGATIVE 1 ///< Shift timestamps so they are non negative
#define AVFMT_AVOID_NEG_TS_MAKE_ZERO         2 ///< Shift timestamps so that they start at 0

    /**
     * Transport stream id.
     * This will be moved into demuxer private options. Thus no API/ABI compatibility
     */
    int ts_id;

    /**
     * Audio preload in microseconds.
     * Note, not all formats support this and unpredictable things may happen if it is used when not supported.
     * - encoding: Set by user
     * - decoding: unused
     */
    int audio_preload;

    /**
     * Max chunk time in microseconds.
     * Note, not all formats support this and unpredictable things may happen if it is used when not supported.
     * - encoding: Set by user
     * - decoding: unused
     */
    int max_chunk_duration;

    /**
     * Max chunk size in bytes
     * Note, not all formats support this and unpredictable things may happen if it is used when not supported.
     * - encoding: Set by user
     * - decoding: unused
     */
    int max_chunk_size;

    /**
     * forces the use of wallclock timestamps as pts/dts of packets
     * This has undefined results in the presence of B frames.
     * - encoding: unused
     * - decoding: Set by user
     */
    int use_wallclock_as_timestamps;

    /**
     * avio flags, used to force AVIO_FLAG_DIRECT.
     * - encoding: unused
     * - decoding: Set by user
     */
    int avio_flags;

    /**
     * The duration field can be estimated through various ways, and this field can be used
     * to know how the duration was estimated.
     * - encoding: unused
     * - decoding: Read by user
     */
    enum AVDurationEstimationMethod duration_estimation_method;

    /**
     * Skip initial bytes when opening stream
     * - encoding: unused
     * - decoding: Set by user
     */
    int64_t skip_initial_bytes;

    /**
     * Correct single timestamp overflows
     * - encoding: unused
     * - decoding: Set by user
     */
    unsigned int correct_ts_overflow;

    /**
     * Force seeking to any (also non key) frames.
     * - encoding: unused
     * - decoding: Set by user
     */
    int seek2any;

    /**
     * Flush the I/O context after each packet.
     * - encoding: Set by user
     * - decoding: unused
     */
    int flush_packets;

    /**
     * format probing score.
     * The maximal score is AVPROBE_SCORE_MAX, its set when the demuxer probes
     * the format.
     * - encoding: unused
     * - decoding: set by avformat, read by user
     */
    int probe_score;

    /**
     * number of bytes to read maximally to identify format.
     * - encoding: unused
     * - decoding: set by user
     */
    int format_probesize;

    /**
     * ',' separated list of allowed decoders.
     * If NULL then all are allowed
     * - encoding: unused
     * - decoding: set by user
     */
    char *codec_whitelist;

    /**
     * ',' separated list of allowed demuxers.
     * If NULL then all are allowed
     * - encoding: unused
     * - decoding: set by user
     */
    char *format_whitelist;

    /**
     * An opaque field for libavformat internal usage.
     * Must not be accessed in any way by callers.
     */
    AVFormatInternal *internal;

    /**
     * IO repositioned flag.
     * This is set by avformat when the underlaying IO context read pointer
     * is repositioned, for example when doing byte based seeking.
     * Demuxers can use the flag to detect such changes.
     */
    int io_repositioned;

    /**
     * Forced video codec.
     * This allows forcing a specific decoder, even when there are multiple with
     * the same codec_id.
     * Demuxing: Set by user
     */
    AVCodec *video_codec;

    /**
     * Forced audio codec.
     * This allows forcing a specific decoder, even when there are multiple with
     * the same codec_id.
     * Demuxing: Set by user
     */
    AVCodec *audio_codec;

    /**
     * Forced subtitle codec.
     * This allows forcing a specific decoder, even when there are multiple with
     * the same codec_id.
     * Demuxing: Set by user
     */
    AVCodec *subtitle_codec;

    /**
     * Forced data codec.
     * This allows forcing a specific decoder, even when there are multiple with
     * the same codec_id.
     * Demuxing: Set by user
     */
    AVCodec *data_codec;

    /**
     * Number of bytes to be written as padding in a metadata header.
     * Demuxing: Unused.
     * Muxing: Set by user via av_format_set_metadata_header_padding.
     */
    int metadata_header_padding;

    /**
     * User data.
     * This is a place for some private data of the user.
     */
    void *opaque;

    /**
     * Callback used by devices to communicate with application.
     */
    av_format_control_message control_message_cb;

    /**
     * Output timestamp offset, in microseconds.
     * Muxing: set by user
     */
    int64_t output_ts_offset;

    /**
     * dump format separator.
     * can be ", " or "\n      " or anything else
     * - muxing: Set by user.
     * - demuxing: Set by user.
     */
    uint8_t *dump_separator;

    /**
     * Forced Data codec_id.
     * Demuxing: Set by user.
     */
    enum AVCodecID data_codec_id;

#if FF_API_OLD_OPEN_CALLBACKS
    /**
     * Called to open further IO contexts when needed for demuxing.
     *
     * This can be set by the user application to perform security checks on
     * the URLs before opening them.
     * The function should behave like avio_open2(), AVFormatContext is provided
     * as contextual information and to reach AVFormatContext.opaque.
     *
     * If NULL then some simple checks are used together with avio_open2().
     *
     * Must not be accessed directly from outside avformat.
     * @See av_format_set_open_cb()
     *
     * Demuxing: Set by user.
     *
     * @deprecated Use io_open and io_close.
     */
    attribute_deprecated
    int (*open_cb)(struct AVFormatContext *s, AVIOContext **p, const char *url, int flags, const AVIOInterruptCB *int_cb, AVDictionary **options);
#endif

    /**
     * ',' separated list of allowed protocols.
     * - encoding: unused
     * - decoding: set by user
     */
    char *protocol_whitelist;

    /**
     * A callback for opening new IO streams.
     *
     * Whenever a muxer or a demuxer needs to open an IO stream (typically from
     * avformat_open_input() for demuxers, but for certain formats can happen at
     * other times as well), it will call this callback to obtain an IO context.
     *
     * @param s the format context
     * @param pb on success, the newly opened IO context should be returned here
     * @param url the url to open
     * @param flags a combination of AVIO_FLAG_*
     * @param options a dictionary of additional options, with the same
     *                semantics as in avio_open2()
     * @return 0 on success, a negative AVERROR code on failure
     *
     * @note Certain muxers and demuxers do nesting, i.e. they open one or more
     * additional internal format contexts. Thus the AVFormatContext pointer
     * passed to this callback may be different from the one facing the caller.
     * It will, however, have the same 'opaque' field.
     */
    int (*io_open)(struct AVFormatContext *s, AVIOContext **pb, const char *url,
                   int flags, AVDictionary **options);

    /**
     * A callback for closing the streams opened with AVFormatContext.io_open().
     */
    void (*io_close)(struct AVFormatContext *s, AVIOContext *pb);

    /**
     * ',' separated list of disallowed protocols.
     * - encoding: unused
     * - decoding: set by user
     */
    char *protocol_blacklist;

    /**
     * The maximum number of streams.
     * - encoding: unused
     * - decoding: set by user
     */
    int max_streams;

    /**
     * Skip duration calcuation in estimate_timings_from_pts.
     * - encoding: unused
     * - decoding: set by user
     */
    int skip_estimate_duration_from_pts;

    /**
     * Maximum number of packets that can be probed
     * - encoding: unused
     * - decoding: set by user
     */
    int max_probe_packets;
} AVFormatContext;
