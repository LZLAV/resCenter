package com.weihu.video

import android.app.Application
import android.content.Context

/**
 * created by hupihuai on 2019/1/24
 */
class MyApp : Application() {
    companion object {
        lateinit var context: Context
    }

    override fun onCreate() {
        super.onCreate()
        context = this
    }
}