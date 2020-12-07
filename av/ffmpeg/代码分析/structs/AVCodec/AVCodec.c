typedef struct AVCodec {
    /**
     * Name of the codec implementation.
     * The name is globally unique among encoders and among decoders (but an
     * encoder and a decoder can share the same name).
     * This is the primary way to find a codec from the user perspective.
     */
    const char *name;
    /**
     * Descriptive name for the codec, meant to be more human readable than name.
     * You should use the NULL_IF_CONFIG_SMALL() macro to define it.
     */
    const char *long_name;
    enum AVMediaType type;
    enum AVCodecID id;
    /**
     * Codec capabilities.
     * see AV_CODEC_CAP_*
     */
    int capabilities;
    const AVRational *supported_framerates; ///< array of supported framerates, or NULL if any, array is terminated by {0,0}
    const enum AVPixelFormat *pix_fmts;     ///< array of supported pixel formats, or NULL if unknown, array is terminated by -1
    const int *supported_samplerates;       ///< array of supported audio samplerates, or NULL if unknown, array is terminated by 0
    const enum AVSampleFormat *sample_fmts; ///< array of supported sample formats, or NULL if unknown, array is terminated by -1
    const uint64_t *channel_layouts;         ///< array of support channel layouts, or NULL if unknown. array is terminated by 0
    uint8_t max_lowres;                     ///< maximum value for lowres supported by the decoder
    const AVClass *priv_class;              ///< AVClass for the private context
    const AVProfile *profiles;              ///< array of recognized profiles, or NULL if unknown, array is terminated by {FF_PROFILE_UNKNOWN}

    /**
     * Group name of the codec implementation.
     * This is a short symbolic name of the wrapper backing this codec. A
     * wrapper uses some kind of external implementation for the codec, such
     * as an external library, or a codec implementation provided by the OS or
     * the hardware.
     * If this field is NULL, this is a builtin, libavcodec native codec.
     * If non-NULL, this will be the suffix in AVCodec.name in most cases
     * (usually AVCodec.name will be of the form "<codec_name>_<wrapper_name>").
     */
    const char *wrapper_name;

    /*****************************************************************
     * No fields below this line are part of the public API. They
     * may not be used outside of libavcodec and can be changed and
     * removed at will.
     * New public fields should be added right above.
     *****************************************************************
     */
    int priv_data_size;
#if FF_API_NEXT
    struct AVCodec *next;
#endif
    /**
     * @name Frame-level threading support functions
     * @{
     */
    /**
     * Copy necessary context variables from a previous thread context to the current one.
     * If not defined, the next thread will start automatically; otherwise, the codec
     * must call ff_thread_finish_setup().
     *
     * dst and src will (rarely) point to the same context, in which case memcpy should be skipped.
     */
    int (*update_thread_context)(struct AVCodecContext *dst, const struct AVCodecContext *src);
    /** @} */

    /**
     * Private codec-specific defaults.
     */
    const AVCodecDefault *defaults;

    /**
     * Initialize codec static data, called from avcodec_register().
     *
     * This is not intended for time consuming operations as it is
     * run for every codec regardless of that codec being used.
     */
    void (*init_static_data)(struct AVCodec *codec);

    int (*init)(struct AVCodecContext *);
    int (*encode_sub)(struct AVCodecContext *, uint8_t *buf, int buf_size,
                      const struct AVSubtitle *sub);
    /**
     * Encode data to an AVPacket.
     *
     * @param      avctx          codec context
     * @param      avpkt          output AVPacket (may contain a user-provided buffer)
     * @param[in]  frame          AVFrame containing the raw data to be encoded
     * @param[out] got_packet_ptr encoder sets to 0 or 1 to indicate that a
     *                            non-empty packet was returned in avpkt.
     * @return 0 on success, negative error code on failure
     */
    int (*encode2)(struct AVCodecContext *avctx, struct AVPacket *avpkt,
                   const struct AVFrame *frame, int *got_packet_ptr);
    int (*decode)(struct AVCodecContext *, void *outdata, int *outdata_size, struct AVPacket *avpkt);
    int (*close)(struct AVCodecContext *);
    /**
     * Encode API with decoupled frame/packet dataflow. This function is called
     * to get one output packet. It should call ff_encode_get_frame() to obtain
     * input data.
     */
    int (*receive_packet)(struct AVCodecContext *avctx, struct AVPacket *avpkt);

    /**
     * Decode API with decoupled packet/frame dataflow. This function is called
     * to get one output frame. It should call ff_decode_get_packet() to obtain
     * input data.
     */
    int (*receive_frame)(struct AVCodecContext *avctx, struct AVFrame *frame);
    /**
     * Flush buffers.
     * Will be called when seeking
     */
    void (*flush)(struct AVCodecContext *);
    /**
     * Internal codec capabilities.
     * See FF_CODEC_CAP_* in internal.h
     */
    int caps_internal;

    /**
     * Decoding only, a comma-separated list of bitstream filters to apply to
     * packets before decoding.
     */
    const char *bsfs;

    /**
     * Array of pointers to hardware configurations supported by the codec,
     * or NULL if no hardware supported.  The array is terminated by a NULL
     * pointer.
     *
     * The user can only access this field via avcodec_get_hw_config().
     */
    const struct AVCodecHWConfigInternal *const *hw_configs;

    /**
     * List of supported codec_tags, terminated by FF_CODEC_TAGS_END.
     */
    const uint32_t *codec_tags;
} AVCodec;
