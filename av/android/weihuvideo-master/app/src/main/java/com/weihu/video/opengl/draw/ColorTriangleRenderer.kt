package com.weihu.video.opengl.draw

import android.opengl.GLES30
import android.opengl.GLSurfaceView
import com.weihu.video.MyApp
import com.weihu.video.opengl.DataUtil
import com.weihu.video.opengl.Shader
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.opengles.GL10

/**
 * created by hupihuai on 2019/1/24
 */
class ColorTriangleRenderer : GLSurfaceView.Renderer {
    private val vao = IntArray(1)
    private val vbo = IntArray(1)
    private var esShader = Shader()

    private var vertices = floatArrayOf(
        // 位置              // 颜色
        0.5f, -0.5f, 0.0f, 1.0f, 0.0f, 0.0f,   // 右下
        -0.5f, -0.5f, 0.0f, 0.0f, 1.0f, 0.0f,   // 左下
        0.0f, 0.5f, 0.0f, 0.0f, 0.0f, 1.0f    // 顶部
    )

    override fun onSurfaceChanged(gl: GL10?, width: Int, height: Int) {
        GLES30.glViewport(0, 0, width, height)
    }

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
            //步长，它告诉我们在连续的顶点属性组之间的间隔 也就是绘制一个顶点要多少数据 字节单位
            6 * DataUtil.sizeof(GLES30.GL_FLOAT),
            //数据偏移量 这里顶点从0开始
            0
        )
        GLES30.glEnableVertexAttribArray(0)


        //设置顶点数组指针
        GLES30.glVertexAttribPointer(
            //shader中 layout(location = 0)的值
            1,
            //顶点属性的大小。顶点属性是一个vec3，它由3个值组成，所以大小是3
            3,
            //数据的类型
            GLES30.GL_FLOAT,
            //GL_TRUE，数据被标准化，所有数据都会被映射到0（对于有符号型signed数据是-1）到1之间。我们把它设置为GL_FALSE
            false,
            //步长，它告诉我们在连续的顶点属性组之间的间隔 也就是绘制一个顶点要多少数据 字节单位
            6 * DataUtil.sizeof(GLES30.GL_FLOAT),
            //数据偏移量 前面有顶点 所以这里要偏移定点数据 三个定点*每个顶点的大小
            3 * DataUtil.sizeof(GLES30.GL_FLOAT)
        )
        //激活第二个（location=1）不然颜色不会显示
        GLES30.glEnableVertexAttribArray(1)
        //vbo end

        //vao end
        //shader
        esShader.loadProgramFromAsset(MyApp.context, "color_triangle_vert.glsl", "color_triangle_frag.glsl")
    }

    override fun onDrawFrame(gl: GL10?) {
        GLES30.glClear(GLES30.GL_COLOR_BUFFER_BIT)
        esShader.use()
        GLES30.glBindVertexArray(vao[0])
        GLES30.glDrawArrays(
            //图元的类型
            GLES30.GL_TRIANGLES,
            //起始索引
            0,
            //多少个顶点
            3
        )
    }
}