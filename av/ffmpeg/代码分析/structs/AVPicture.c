typedef struct AVPicture {
    attribute_deprecated
    uint8_t *data[AV_NUM_DATA_POINTERS];    ///< pointers to the image data planes
    attribute_deprecated
    int linesize[AV_NUM_DATA_POINTERS];     ///< number of bytes per line
} AVPicture;