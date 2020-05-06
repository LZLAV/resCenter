package com.weihu.video.h264video

import android.Manifest
import android.content.pm.PackageManager
import android.databinding.DataBindingUtil
import android.graphics.ImageFormat
import android.hardware.Camera
import android.os.Bundle
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat
import android.support.v7.app.AppCompatActivity
import android.view.SurfaceHolder
import android.widget.Toast
import com.weihu.video.R
import com.weihu.video.databinding.ActivityH264VideoBinding
import java.io.IOException

class H264VideoActivity : AppCompatActivity(), SurfaceHolder.Callback, Camera.PreviewCallback {
    private lateinit var binding: ActivityH264VideoBinding
    private lateinit var camera: Camera
    private val video_width = 1280
    private val video_height = 720

    private var mediaCodeUtil: MediaCodeMuxerUtil? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = DataBindingUtil.setContentView(this, R.layout.activity_h264_video)

        requestPermission()
        binding.surfaceView.holder.addCallback(this)
        mediaCodeUtil = MediaCodeMuxerUtil()
        mediaCodeUtil?.init(video_width, video_height, 30)
        binding.startBtn.setOnClickListener {
            mediaCodeUtil?.startEncoder()
        }

        binding.stopBtn.setOnClickListener {
            mediaCodeUtil?.stop()
        }

    }

    private fun requestPermission() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED ||
            ContextCompat.checkSelfPermission(
                this, Manifest.permission.RECORD_AUDIO
            ) != PackageManager.PERMISSION_GRANTED ||
            ContextCompat.checkSelfPermission(
                this, Manifest.permission.WRITE_EXTERNAL_STORAGE
            ) != PackageManager.PERMISSION_GRANTED ||
            ContextCompat.checkSelfPermission(
                this, Manifest.permission.READ_EXTERNAL_STORAGE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            Toast.makeText(this, "申请权限", Toast.LENGTH_SHORT).show()
            // 申请 相机 麦克风权限
            ActivityCompat.requestPermissions(
                this,
                arrayOf(
                    Manifest.permission.CAMERA,
                    Manifest.permission.RECORD_AUDIO,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE,
                    Manifest.permission.READ_EXTERNAL_STORAGE
                ),
                100
            )
        }
    }

    override fun surfaceChanged(holder: SurfaceHolder?, format: Int, width: Int, height: Int) {

    }

    override fun surfaceDestroyed(holder: SurfaceHolder?) {
        // 停止预览并释放资源
        if (camera != null) {
            camera.setPreviewCallback(null)
            camera.stopPreview()
        }
    }


    override fun surfaceCreated(holder: SurfaceHolder?) {
        camera = Camera.open()
        camera.setDisplayOrientation(90)
        val parameters = camera.parameters
        parameters.previewFormat = ImageFormat.NV21
        parameters.focusMode = Camera.Parameters.FOCUS_MODE_AUTO
        parameters.setPreviewSize(video_width, video_height)

        try {
            camera.parameters = parameters
            camera.setPreviewDisplay(binding.surfaceView.holder)
            camera.setPreviewCallback(this)
            camera.startPreview()
        } catch (e: IOException) {
            e.printStackTrace()
        }

    }

    override fun onPreviewFrame(data: ByteArray, camera: Camera?) {
        if (mediaCodeUtil != null) {
            mediaCodeUtil?.putData(data)
        }
    }
}
