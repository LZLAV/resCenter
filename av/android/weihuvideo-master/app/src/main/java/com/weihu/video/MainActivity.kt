package com.weihu.video

import android.content.Intent
import android.databinding.DataBindingUtil
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import com.weihu.video.R
import com.weihu.video.databinding.ActivityMainBinding
import com.weihu.video.h264video.H264VideoActivity
import com.weihu.video.opengl.OpenglActivity
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = DataBindingUtil.setContentView(this, R.layout.activity_main)
        setViewListener()
    }

    private fun setViewListener() {
        binding.h264videoBtn.setOnClickListener {
            Intent(this, H264VideoActivity::class.java).apply {
                startActivity(this)
            }
        }
        binding.openglBtn.setOnClickListener {
            Intent(this, OpenglActivity::class.java).apply {
                startActivity(this)
            }
        }
    }

    /**
     * A native method that is implemented by the 'native-lib' native library,
     * which is packaged with this application.
     */
    external fun stringFromJNI(): String

    companion object {

        // Used to load the 'native-lib' library on application startup.
        init {
            System.loadLibrary("native-lib")
        }
    }
}
