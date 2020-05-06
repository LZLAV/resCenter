package com.weihu.video.h264video

import android.media.*
import android.os.Environment
import java.io.IOException
import java.util.concurrent.ArrayBlockingQueue

/**
 * created by hupihuai on 2019/1/9
 */
class MediaCodeMuxerUtil {
    private lateinit var mediaCodec: MediaCodec
    private val VCODEC_MIME = "video/avc" // H264的MIME
    private var height: Int = 0
    private var width: Int = 0
    private var isRuning = false

    private var yuv420Queue = ArrayBlockingQueue<ByteArray>(10)

    private lateinit var muxer: MediaMuxer
    private var videoTrack = -1
    private var bufferInfo = MediaCodec.BufferInfo()

    fun init(width: Int, height: Int, frameRate: Int) {

        if (!::mediaCodec.isInitialized) {
            val bitrate = 2 * width * height
            this.width = width
            this.height = height

            val mediaCodecInfo = selectCodec(VCODEC_MIME)
            mediaCodec = MediaCodec.createByCodecName(mediaCodecInfo!!.name)

            var videoFormat = MediaFormat.createVideoFormat(VCODEC_MIME, height, width)
            videoFormat.setInteger(MediaFormat.KEY_BIT_RATE, bitrate)
            videoFormat.setInteger(MediaFormat.KEY_FRAME_RATE, frameRate)
            videoFormat.setInteger(
                MediaFormat.KEY_COLOR_FORMAT, MediaCodecInfo.CodecCapabilities.COLOR_FormatYUV420Flexible
            )
            videoFormat.setInteger(MediaFormat.KEY_I_FRAME_INTERVAL, 1)
            mediaCodec.configure(videoFormat, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE)
            createMuxer()
            mediaCodec.start()
        }

    }

    private fun createMuxer() {
        val path = Environment.getExternalStorageDirectory().absolutePath + "/test.mp4"
        try {
            muxer = MediaMuxer(path, MediaMuxer.OutputFormat.MUXER_OUTPUT_MPEG_4)
        } catch (e: IOException) {
            e.printStackTrace()
        }


    }

    private fun selectCodec(mimeType: String): MediaCodecInfo? {
        val numCodecs = MediaCodecList.getCodecCount()
        for (i in 0 until numCodecs) {
            val codecInfo = MediaCodecList.getCodecInfoAt(i)
            //不是编码器
            if (!codecInfo.isEncoder) {
                continue
            }
            val types = codecInfo.supportedTypes
            for (type in types) {
                if (mimeType.equals(type, ignoreCase = true)) {
                    return codecInfo
                }
            }
        }
        return null
    }


    fun putData(buffer: ByteArray) {
        if (yuv420Queue.size >= 10) {
            yuv420Queue.poll()
        }
        yuv420Queue.add(buffer)
    }


    fun startEncoder() {
        Thread {
            isRuning = true
            var input: ByteArray? = null
            var pts: Long = 0
            var generateIndex: Long = 0

            while (isRuning) {
                if (yuv420Queue.size > 0) {
                    input = yuv420Queue.poll()
                    val yuv420sp = ByteArray(getYuvBuffer(width, height))
                    nv212nv12(input, yuv420sp, width, height)
                    //旋转代码
                    YUV420spRotate90Clockwise(yuv420sp, input, width, height)
//                    input = yuv420sp
                }
                if (input != null) {
                    try {
                        val inputBuffers = mediaCodec.inputBuffers
                        val outputBuffers = mediaCodec.outputBuffers

                        val inputBufferIndex = mediaCodec.dequeueInputBuffer(-1)
                        if (inputBufferIndex > 0) {
                            //数据放入到inputBuffer中
                            val inputBuffer = inputBuffers[inputBufferIndex]
                            inputBuffer.clear()
                            inputBuffer.put(input, 0, input.size)
                            //把数据传给编码器并进行编码
                            mediaCodec.queueInputBuffer(
                                inputBufferIndex, 0,
                                input.size,
                                System.nanoTime() / 1000, 0
                            )
                            generateIndex++

                            //输出buffer出队，返回成功的buffer索引。
                            var outputBufferIndex = mediaCodec.dequeueOutputBuffer(bufferInfo, 11000)
                            while (outputBufferIndex >= 0) {
                                val outputBuffer = outputBuffers[outputBufferIndex]

                                if (bufferInfo.flags == MediaCodec.BUFFER_FLAG_CODEC_CONFIG) {
                                    bufferInfo.size = 0
                                    println("BUFFER_FLAG_CODEC_CONFIG = ")
                                    if (videoTrack < 0) {
                                        //这里初始化可以直接拿到sps pps
                                        videoTrack = muxer.addTrack(mediaCodec.outputFormat)
                                        muxer.start()
                                    }
                                }

                                if (bufferInfo.size > 0) {
                                    //防止视频数据错乱
                                    outputBuffer.position(bufferInfo.offset)
                                    outputBuffer.limit(bufferInfo.offset + bufferInfo.size)
                                    muxer.writeSampleData(videoTrack, outputBuffer, bufferInfo)
                                }
                                mediaCodec.releaseOutputBuffer(outputBufferIndex, false)
                                outputBufferIndex = mediaCodec.dequeueOutputBuffer(bufferInfo, 0)
                            }
                        }
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                } else {
                    Thread.sleep(500)
                }
            }
            // 停止编解码器并释放资源
            try {
                mediaCodec.stop()
                mediaCodec.release()
            } catch (e: Exception) {
                e.printStackTrace()
            }


            // 关闭数据流
            try {
                muxer.stop()
                muxer.release()
            } catch (e: IOException) {
                e.printStackTrace()
            }


        }.start()

    }

    fun getYuvBuffer(width: Int, height: Int): Int {
        // stride = ALIGN(width, 16)
        val stride = Math.ceil(width / 16.0).toInt() * 16
        // y_size = stride * height
        val y_size = stride * height
        // c_stride = ALIGN(stride/2, 16)
        val c_stride = Math.ceil(width / 32.0).toInt() * 16
        // c_size = c_stride * height/2
        val c_size = c_stride * height / 2
        // size = y_size + c_size * 2
        return y_size + c_size * 2
    }

    fun stop() {
        isRuning = false
    }

    //顺时针旋转90
    private fun YUV420spRotate90Clockwise(src: ByteArray, dst: ByteArray, srcWidth: Int, srcHeight: Int) {

        val wh = srcWidth * srcHeight
        val uvHeight = srcHeight shr 1

        //旋转Y
        var k = 0
        for (i in 0 until srcWidth) {
            var nPos = 0
            for (j in 0 until srcHeight) {
                dst[k] = src[nPos + i]
                k++
                nPos += srcWidth
            }
        }

        var i = 0
        while (i < srcWidth) {
            var nPos = wh
            for (j in 0 until uvHeight) {
                dst[k] = src[nPos + i]
                dst[k + 1] = src[nPos + i + 1]
                k += 2
                nPos += srcWidth
            }
            i += 2
        }

    }


    private fun YUV420spRotate90Anticlockwise(src: ByteArray, dst: ByteArray, width: Int, height: Int) {
        val wh = width * height
        val uvHeight = height shr 1

        //旋转Y
        var k = 0
        for (i in 0 until width) {
            var nPos = width - 1
            for (j in 0 until height) {
                dst[k] = src[nPos - i]
                k++
                nPos += width
            }
        }

        var i = 0
        while (i < width) {
            var nPos = wh + width - 1
            for (j in 0 until uvHeight) {
                dst[k] = src[nPos - i - 1]
                dst[k + 1] = src[nPos - i]
                k += 2
                nPos += width
            }
            i += 2
        }
    }

    //顺时针旋转270度
    private fun YUV420spRotate270(des: ByteArray, src: ByteArray, width: Int, height: Int) {
        var n = 0
        val uvHeight = height shr 1
        val wh = width * height
        //copy y
        for (j in width - 1 downTo 0) {
            for (i in 0 until height) {
                des[n++] = src[width * i + j]
            }
        }

        var j = width - 1
        while (j > 0) {
            for (i in 0 until uvHeight) {
                des[n++] = src[wh + width * i + j - 1]
                des[n++] = src[wh + width * i + j]
            }
            j -= 2
        }
    }

    //旋转180度（顺时逆时结果是一样的）
    private fun YUV420spRotate180(src: ByteArray, des: ByteArray, width: Int, height: Int) {

        var n = 0
        val uh = height shr 1
        val wh = width * height
        //copy y
        for (j in height - 1 downTo 0) {
            for (i in width - 1 downTo 0) {
                des[n++] = src[width * j + i]
            }
        }


        for (j in uh - 1 downTo 0) {
            var i = width - 1
            while (i > 0) {
                des[n] = src[wh + width * j + i - 1]
                des[n + 1] = src[wh + width * j + i]
                n += 2
                i -= 2
            }
        }
    }


    private fun nv212nv12(nv21: ByteArray?, nv12: ByteArray?, width: Int, height: Int) {
        if (nv21 == null || nv12 == null) return
        val framesize = width * height
        var i = 0
        var j = 0
        System.arraycopy(nv21, 0, nv12, 0, framesize)
        i = 0
        while (i < framesize) {
            nv12[i] = nv21[i]
            i++
        }
        j = 0
        while (j < framesize / 2) {
            nv12[framesize + j - 1] = nv21[j + framesize]
            j += 2
        }
        j = 0
        while (j < framesize / 2) {
            nv12[framesize + j] = nv21[j + framesize - 1]
            j += 2
        }
    }


}