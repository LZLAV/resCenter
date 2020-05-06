void drawYUV(const char *path, int width, int height, ANativeWindow_Buffer buffer) {
    FILE *file = fopen(path, "rb");

    unsigned char *yuvData = new unsigned char[width * height * 3 / 2];

    fread(yuvData, 1, width * height * 3 / 2, file);

    unsigned char *rgb24 = new unsigned char[width * height * 3];

    //YUV420P转RGB24
    YUV420P_TO_RGB24(yuvData, rgb24, width, height);

    uint32_t *line = (uint32_t *) buffer.bits;
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int index = y * width + x;
            line[x] = rgb24[index * 3 + 2] << 16
                      | rgb24[index * 3 + 1] << 8
                      | rgb24[index * 3];
        }
        line = line + buffer.stride;
    }

    //释放内存
    delete[] yuvData;
    delete[] rgb24;

    //关闭文件句柄
    fclose(file);
}

void yuv2rgb(JNIEnv *env, jobject obj, jstring jpegPath, jint width, jint height, jobject surface) {

    const char *path = env->GetStringUTFChars(jpegPath, 0);

    //获取目标surface
    ANativeWindow *window = ANativeWindow_fromSurface(env, surface);
    if (NULL == window) {
        ThrowException(env, "java/lang/RuntimeException", "unable to get native window");
        return;
    }
    //默认的是RGB_565
    int32_t result = ANativeWindow_setBuffersGeometry(window, 0, 0, WINDOW_FORMAT_RGBA_8888);
    if (result < 0) {
        ThrowException(env, "java/lang/RuntimeException", "unable to set buffers geometry");
        //释放窗口
        ANativeWindow_release(window);
        window = NULL;
        return;
    }
    ANativeWindow_acquire(window);

    ANativeWindow_Buffer buffer;
    //锁定窗口的绘图表面
    if (ANativeWindow_lock(window, &buffer, NULL) < 0) {
        ThrowException(env, "java/lang/RuntimeException", "unable to lock native window");
        //释放窗口
        ANativeWindow_release(window);
        window = NULL;
        return;
    }

    //绘制YUV
    drawYUV(path, width, height, buffer);

    //解锁窗口的绘图表面
    if (ANativeWindow_unlockAndPost(window) < 0) {
        ThrowException(env, "java/lang/RuntimeException",
                       "unable to unlock and post to native window");
    }

    env->ReleaseStringUTFChars(jpegPath, path);
    //释放
    ANativeWindow_release(window);
}