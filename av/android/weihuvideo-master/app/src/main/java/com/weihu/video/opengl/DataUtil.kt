package com.weihu.video.opengl

import android.opengl.GLES30
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer
import java.nio.ShortBuffer

/**
 * created by hupihuai on 2019/1/24
 */
class DataUtil {

    companion object {
        fun createByteBuffer(array: FloatArray): FloatBuffer {
            val vertex = ByteBuffer.allocateDirect(array.size * 4)
            vertex.order(ByteOrder.nativeOrder())
            val vertexBuffer = vertex.asFloatBuffer()
            vertexBuffer.put(array)
            vertexBuffer.position(0)
            return vertexBuffer
        }

        fun createByteBuffer(array: ShortArray): ShortBuffer {
            val vertex = ByteBuffer.allocateDirect(array.size * 2)
            vertex.order(ByteOrder.nativeOrder())
            val vertexBuffer = vertex.asShortBuffer()
            vertexBuffer.put(array)
            vertexBuffer.position(0)
            return vertexBuffer
        }

        fun sizeof(dataType: Int): Int {
            return when (dataType) {
                GLES30.GL_FLOAT -> 4
                GLES30.GL_SHORT -> 2
                else -> 1
            }
        }

    }
}