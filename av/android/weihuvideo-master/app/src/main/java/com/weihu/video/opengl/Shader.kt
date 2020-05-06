package com.weihu.video.opengl

import android.content.Context
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.io.InputStream
import android.opengl.GLES30
import android.util.Log


/**
 * created by hupihuai on 2019/1/24
 */
class Shader {

    private var programObject = 0

    private fun readShader(context: Context, fileName: String?): String? {
        var shaderSource: String? = null
        if (fileName == null) {
            return shaderSource
        }
        var inputStream: InputStream? = null
        try {
            inputStream = context.assets.open(fileName)
            val buffer = ByteArray(inputStream!!.available())
            inputStream!!.read(buffer)
            val os = ByteArrayOutputStream()
            os.write(buffer)
            os.close()
            inputStream!!.close()
            shaderSource = os.toString()
        } catch (ioe: IOException) {
            ioe.printStackTrace()
            inputStream = null
        }

        return shaderSource

    }


    private fun loadShader(type: Int, shaderSrc: String): Int {
        val compiled = IntArray(1)
        val shader = GLES30.glCreateShader(type)
        if (shader == 0) {
            return 0
        }
        GLES30.glShaderSource(shader, shaderSrc)
        GLES30.glCompileShader(shader)
        GLES30.glGetShaderiv(shader, GLES30.GL_COMPILE_STATUS, compiled, 0)
        if (compiled[0] == 0) {
            Log.e("Shader", GLES30.glGetShaderInfoLog(shader))
            GLES30.glDeleteShader(shader)
            return 0
        }
        return shader
    }


    fun loadProgram(vertShaderSrc: String, fragShaderSrc: String) {
        val linked = IntArray(1)
        val vertexShader = loadShader(GLES30.GL_VERTEX_SHADER, vertShaderSrc)

        if (vertexShader == 0) {
            return
        }
        val fragmentShader = loadShader(GLES30.GL_FRAGMENT_SHADER, fragShaderSrc)
        if (fragmentShader == 0) {
            GLES30.glDeleteShader(vertexShader)
            return
        }
        // 创建 program object
        programObject = GLES30.glCreateProgram()
        if (programObject == 0) {
            return
        }
        GLES30.glAttachShader(programObject, vertexShader)
        GLES30.glAttachShader(programObject, fragmentShader)
        // 链接 the program
        GLES30.glLinkProgram(programObject)
        // 获取 status
        GLES30.glGetProgramiv(programObject, GLES30.GL_LINK_STATUS, linked, 0)
        if (linked[0] == 0) {
            Log.e("Shader", "Error linking program:")
            Log.e("Shader", GLES30.glGetProgramInfoLog(programObject))
            GLES30.glDeleteProgram(programObject)
            return
        }
        // 链接玩就可以删除shader 以后所有的操作都正对program
        GLES30.glDeleteShader(vertexShader)
        GLES30.glDeleteShader(fragmentShader)
    }


    fun loadProgramFromAsset(context: Context, vertexShaderFileName: String, fragShaderFileName: String) {
        val linked = IntArray(1)
        val vertShaderSrc = readShader(context, vertexShaderFileName) ?: return
        val fragShaderSrc = readShader(context, fragShaderFileName) ?: return
        val vertexShader = loadShader(GLES30.GL_VERTEX_SHADER, vertShaderSrc)
        if (vertexShader == 0) {
            return
        }
        val fragmentShader = loadShader(GLES30.GL_FRAGMENT_SHADER, fragShaderSrc)

        if (fragmentShader == 0) {
            GLES30.glDeleteShader(vertexShader)
            return
        }
        programObject = GLES30.glCreateProgram()

        if (programObject == 0) {
            return
        }
        //把shader添加到program
        GLES30.glAttachShader(programObject, vertexShader)
        GLES30.glAttachShader(programObject, fragmentShader)

        GLES30.glLinkProgram(programObject)
        GLES30.glGetProgramiv(programObject, GLES30.GL_LINK_STATUS, linked, 0)
        if (linked[0] == 0) {
            Log.e("Shader", "Error linking program:")
            Log.e("Shader", GLES30.glGetProgramInfoLog(programObject))
            GLES30.glDeleteProgram(programObject)
            return
        }
        //链接玩就可以删除shader 以后所有的操作都正对program
        GLES30.glDeleteShader(vertexShader)
        GLES30.glDeleteShader(fragmentShader)
    }

    /**
     * 使用单签program
     */
    fun use() {
        if (programObject <= 0) {
            Log.e("Shader", "Error  program:")
            return
        }
        GLES30.glUseProgram(programObject)
    }

    fun setInt(name: String, value: Int) {
        GLES30.glUniform1i(GLES30.glGetUniformLocation(programObject, name), value)
    }


}