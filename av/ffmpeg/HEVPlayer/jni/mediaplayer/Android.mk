LOCAL_PATH := $(call my-dir)

#
# mediaplayer.so
#
include $(CLEAR_VARS)

LOCAL_C_INCLUDES += $(LOCAL_PATH)/../lenthevcdec/include/ $(LOCAL_PATH)/../ffmpeg/include/ $(LOCAL_PATH)/../native_player/

LOCAL_SRC_FILES := audio_decoder.cpp video_decoder.cpp decoder.cpp framequeue.cpp \
					packetqueue.cpp thread.cpp mediaplayer.cpp

LOCAL_MODULE := mediaplayer

include $(BUILD_STATIC_LIBRARY)
