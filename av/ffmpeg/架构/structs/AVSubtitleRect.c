typedef struct AVSubtitleRect {
    int x;         ///< top left corner  of pict, undefined when pict is not set
    int y;         ///< top left corner  of pict, undefined when pict is not set
    int w;         ///< width            of pict, undefined when pict is not set
    int h;         ///< height           of pict, undefined when pict is not set
    int nb_colors; ///< number of colors in pict, undefined when pict is not set

#if FF_API_AVPICTURE
    /**
     * @deprecated unused
     */
    attribute_deprecated
    AVPicture pict;
#endif
    /**
     * data+linesize for the bitmap of this subtitle.
     * Can be set for text/ass as well once they are rendered.
     */
    uint8_t *data[4];
    int linesize[4];

    enum AVSubtitleType type;

    char *text;                     ///< 0 terminated plain UTF-8 text

    /**
     * 0 terminated ASS/SSA compatible event line.
     * The presentation of this is unaffected by the other values in this
     * struct.
     */
    char *ass;

    int flags;
} AVSubtitleRect;