package com.weihu.video.opengl.draw

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.opengl.GLES30
import android.opengl.GLSurfaceView
import android.opengl.GLUtils
import com.weihu.video.MyApp
import com.weihu.video.R
import com.weihu.video.opengl.DataUtil
import com.weihu.video.opengl.Shader
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.opengles.GL10

/**
 * created by hupihuai on 2019/2/20
 */
class TextureRender : GLSurfaceView.Renderer {

    private val vao = IntArray(1)
    private val vbo = IntArray(1)
    private val ebo = IntArray(1)
    private var esShader = Shader()
    private var texture = 0

    private var vertices = floatArrayOf(
        //顶点            //颜色             //文理
        0.5f, 0.5f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f,// 右上角
        0.5f, -0.5f, 0.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f,// 右下角
        -0.5f, -0.5f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f,// 左下角
        -0.5f, 0.5f, 0.0f, 0.5f, 0.5f, 0.5f, 0.0f, 1.0f// 左上角
    )

    private var indices = shortArrayOf(
        0, 1, 3, // 第一个三角形
        1, 2, 3  // 第二个三角形
    )

    override fun onSurfaceCreated(gl: GL10?, config: EGLConfig?) {
        GLES30.glClearColor(0.2f, 0.3f, 0.3f, 1.0f)

        //vao
        GLES30.glGenVertexArrays(1, vao, 0)
        GLES30.glBindVertexArray(vao[0])
        //vbo
        GLES30.glGenBuffers(1, vbo, 0)
        GLES30.glBindBuffer(GLES30.GL_ARRAY_BUFFER, vbo[0])
        val vertexBuffer = DataUtil.createByteBuffer(vertices)
        //复制数据到opengl
        GLES30.glBufferData(
            //顶点缓冲对象当前绑定到GL_ARRAY_BUFFER目标上
            GLES30.GL_ARRAY_BUFFER,
            //指定传输数据的大小(以字节为单位)
            vertices.size * DataUtil.sizeof(GLES30.GL_FLOAT),
            //发送的实际数据
            vertexBuffer,
            //GL_STATIC_DRAW ：数据不会或几乎不会改变。
            //GL_DYNAMIC_DRAW：数据会被改变很多。
            //GL_STREAM_DRAW ：数据每次绘制时都会改变
            GLES30.GL_STATIC_DRAW
        )
        //设置顶点数组指针
        GLES30.glVertexAttribPointer(
            //shader中 layout(location = 0)的值
            0,
            //顶点属性的大小。顶点属性是一个vec3，它由3个值组成，所以大小是3
            3,
            //数据的类型
            GLES30.GL_FLOAT,
            //GL_TRUE，数据被标准化，所有数据都会被映射到0（对于有符号型signed数据是-1）到1之间。我们把它设置为GL_FALSE
            false,
            //步长，它告诉我们在连续的顶点属性组之间的间隔 字节单位
            8 * DataUtil.sizeof(GLES30.GL_FLOAT),
            //数据偏移量 这里只有顶点 位置数据在数组的开头，所以这里是0
            0
        )
        GLES30.glEnableVertexAttribArray(0)

        //设置颜色数组指针
        GLES30.glVertexAttribPointer(
            //shader中 layout(location = 0)的值
            1,
            //顶点属性的大小。顶点属性是一个vec3，它由3个值组成，所以大小是3
            3,
            //数据的类型
            GLES30.GL_FLOAT,
            //GL_TRUE，数据被标准化，所有数据都会被映射到0（对于有符号型signed数据是-1）到1之间。我们把它设置为GL_FALSE
            false,
            //步长，它告诉我们在连续的顶点属性组之间的间隔 字节单位
            8 * DataUtil.sizeof(GLES30.GL_FLOAT),
            //数据偏移量 编译前面
            3 * DataUtil.sizeof(GLES30.GL_FLOAT)
        )
        GLES30.glEnableVertexAttribArray(1)


        //设置颜色数组指针
        GLES30.glVertexAttribPointer(
            //shader中 layout(location = 0)的值
            2,
            //顶点属性的大小。顶点属性是一个vec3，它由3个值组成，所以大小是3
            2,
            //数据的类型
            GLES30.GL_FLOAT,
            //GL_TRUE，数据被标准化，所有数据都会被映射到0（对于有符号型signed数据是-1）到1之间。我们把它设置为GL_FALSE
            false,
            //步长，它告诉我们在连续的顶点属性组之间的间隔 字节单位
            8 * DataUtil.sizeof(GLES30.GL_FLOAT),
            //数据偏移量 编译前面
            6 * DataUtil.sizeof(GLES30.GL_FLOAT)
        )
        GLES30.glEnableVertexAttribArray(2)

        //vbo end

        //ebo start
        GLES30.glGenBuffers(1, ebo, 0)
        GLES30.glBindBuffer(GLES30.GL_ELEMENT_ARRAY_BUFFER, ebo[0])
        val indexBuffer = DataUtil.createByteBuffer(indices)
        //复制数据到opengl
        GLES30.glBufferData(
            //顶点缓冲对象当前绑定到GL_ELEMENT_ARRAY_BUFFER目标上
            GLES30.GL_ELEMENT_ARRAY_BUFFER,
            //指定传输数据的大小(以字节为单位)
            indices.size * DataUtil.sizeof(GLES30.GL_SHORT),
            //发送的实际数据
            indexBuffer,
            //GL_STATIC_DRAW ：数据不会或几乎不会改变。
            //GL_DYNAMIC_DRAW：数据会被改变很多。
            //GL_STREAM_DRAW ：数据每次绘制时都会改变
            GLES30.GL_STATIC_DRAW
        )
        //ebo end

        //vao end

        //shader
        esShader.loadProgramFromAsset(MyApp.context, "texture_vert.glsl", "texture_frag.glsl")

        //create texture
        val bitmap = BitmapFactory.decodeResource(MyApp.context.resources, R.mipmap.container)
        texture = genTexture(bitmap)
        //记得用完释放
        bitmap.recycle()

    }

    private fun genTexture(bitmap: Bitmap): Int {
        var textureId = IntArray(1)
        GLES30.glGenTextures(1, textureId, 0)
        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, textureId[0])
        GLUtils.texImage2D(GLES30.GL_TEXTURE_2D, 0, bitmap, 0)
        //过滤方式 GL_LINEAR 线性取插值 GL_NEAREST 取最靠近
        //当图片缩小时的模式
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_MIN_FILTER, GLES30.GL_NEAREST)
        //当图片放大时的模式
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_MAG_FILTER, GLES30.GL_LINEAR)

        //文理横轴的缩放方式 GL_CLAMP_TO_EDGE：纹理坐标会被约束在0到1之间，超出的部分会重复纹理坐标的边缘，产生一种边缘被拉伸的效果
        // GL_REPEAT 重复
        // GL_MIRRORED_REPEAT 镜像重复
        //GL_CLAMP_TO_BORDER 边缘颜色
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_WRAP_S, GLES30.GL_CLAMP_TO_EDGE)
        //文理纵轴的缩放方式
        GLES30.glTexParameteri(GLES30.GL_TEXTURE_2D, GLES30.GL_TEXTURE_WRAP_T, GLES30.GL_CLAMP_TO_EDGE)
        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, 0)
        return textureId[0]
    }


    override fun onSurfaceChanged(gl: GL10?, width: Int, height: Int) {
        GLES30.glViewport(0, 0, width, height)
    }

    override fun onDrawFrame(gl: GL10?) {
        GLES30.glClear(GLES30.GL_COLOR_BUFFER_BIT)
        esShader.use()
        GLES30.glBindVertexArray(vao[0])
        GLES30.glBindTexture(GLES30.GL_TEXTURE_2D, texture)
        GLES30.glDrawElements(
            //图元的类型
            GLES30.GL_TRIANGLES,
            //定点个数
            6,
            //定点数据类型
            GLES30.GL_UNSIGNED_SHORT,
            //顶点偏移量
            0
        )

    }
}