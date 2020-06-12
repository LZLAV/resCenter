
/**
 * 1. 创建并初始化 Audio Engine
 * 2. 音频输出
 * 3. 音频输入
 * 4. 配置回调并启动输入、输出
 * */




// 音频输入回调
static void inputCallback(SLAndroidSimpleBufferQueueItf bufferQueue, void *pContext) {
    // 获取同步锁
    pthread_mutex_lock(&mutex);
    
    // 取一个可用的缓存
    short int *inputBuffer = inputBuffers[inputBufferWrite];
    if (inputBuffersAvailable == 0) 
        inputBufferRead = inputBufferWrite;
    // 可用缓存+1
    inputBuffersAvailable++;
    if (inputBufferWrite < numBuffers - 1) 
        inputBufferWrite++; 
    else
        inputBufferWrite = 0;

    pthread_mutex_unlock(&mutex);
    
    // 调用BufferQueue的Enqueue方法，把输入数据取到inputBuffer
    (*bufferQueue)->Enqueue(bufferQueue, inputBuffer, buffersize * 4);
}

// 音频输出回调
static void outputCallback(SLAndroidSimpleBufferQueueItf bufferQueue, void *pContext) {
    short int *outputBuffer = outputBuffers[outputBufferIndex];
    pthread_mutex_lock(&mutex);

    if (inputBuffersAvailable < 1) {
        pthread_mutex_unlock(&mutex);
        memset(outputBuffer, 0, buffersize * 4);
    } else {
        short int *inputBuffer = inputBuffers[inputBufferRead];
        if (inputBufferRead < numBuffers - 1) inputBufferRead++; else inputBufferRead = 0;
        inputBuffersAvailable--;
        pthread_mutex_unlock(&mutex);
        memcpy(outputBuffer, inputBuffer, buffersize * 4);
    }

    (*bufferQueue)->Enqueue(bufferQueue, outputBuffer, buffersize * 4);

    if (outputBufferIndex < numBuffers - 1) outputBufferIndex++; else outputBufferIndex = 0;
}

int play(){

    // 创建Audio Engine
    result = slCreateEngine(&openSLEngine, 0, NULL, 0, NULL, NULL);

// 初始化上一步得到的openSLEngine
    result = (*openSLEngine)->Realize(openSLEngine, SL_BOOLEAN_FALSE);

// 获取SLEngine接口对象，后续的操作将使用这个对象
    SLEngineItf openSLEngineInterface = NULL;
    result = (*openSLEngine)->GetInterface(openSLEngine, SL_IID_ENGINE, &openSLEngineInterface);



    /**
     * 音频输出
     * 1. 打开音频输出设备
     * 2. 配置相关参数
     * 3. 创建播放器
     **/

    // 相关参数
    const SLInterfaceID ids[] = {SL_IID_VOLUME};
    const SLboolean req[] = {SL_BOOLEAN_FALSE};

// 使用第一步的openSLEngineInterface，创建音频输出Output Mix
    result = (*openSLEngineInterface)->CreateOutputMix(openSLEngineInterface, &outputMix, 0, ids, req);

// 初始化outputMix
    result = (*outputMix)->Realize(outputMix, SL_BOOLEAN_FALSE);

// 由于不需要操作到ouputMix，所以这一步就不去获取它的接口对象


}


int init()
{
    // 创建Audio Engine
result = slCreateEngine(&openSLEngine, 0, NULL, 0, NULL, NULL);

// 初始化上一步得到的openSLEngine
result = (*openSLEngine)->Realize(openSLEngine, SL_BOOLEAN_FALSE);

// 获取SLEngine接口对象，后续的操作将使用这个对象
SLEngineItf openSLEngineInterface = NULL;
result = (*openSLEngine)->GetInterface(openSLEngine, SL_IID_ENGINE, &openSLEngineInterface);
}


int rec()
{
    /**
     * 音频输入
     * 1. 配置参数
     * 2. 创建录制器
     * 3.
     **/

    // 参数
    SLDataLocator_IODevice deviceInputLocator = { SL_DATALOCATOR_IODEVICE, SL_IODEVICE_AUDIOINPUT, SL_DEFAULTDEVICEID_AUDIOINPUT, NULL };
    SLDataSource inputSource = { &deviceInputLocator, NULL };

    SLDataLocator_AndroidSimpleBufferQueue inputLocator = { SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE, 1 };
    SLDataFormat_PCM inputFormat = { SL_DATAFORMAT_PCM, 2, samplerate * 1000, SL_PCMSAMPLEFORMAT_FIXED_16, SL_PCMSAMPLEFORMAT_FIXED_16, SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT, SL_BYTEORDER_LITTLEENDIAN };

    SLDataSink inputSink = { &inputLocator, &inputFormat };

    const SLInterfaceID inputInterfaces[2] = { SL_IID_ANDROIDSIMPLEBUFFERQUEUE, SL_IID_ANDROIDCONFIGURATION };

    const SLboolean requireds[2] = { SL_BOOLEAN_TRUE, SL_BOOLEAN_FALSE };


    // 创建AudioRecorder
    result = (*openSLEngineInterface)->CreateAudioRecorder(openSLEngineInterface, &andioRecorderObject, &inputSource, &inputSink, 2, inputInterfaces, requireds);

// 初始化AudioRecorder
    result = (*andioRecorderObject)->Realize(andioRecorderObject, SL_BOOLEAN_FALSE);

// 获取音频输入的BufferQueue接口
    result = (*andioRecorderObject)->GetInterface(andioRecorderObject, SL_IID_ANDROIDSIMPLEBUFFERQUEUE, &inputBufferQueueInterface);

// 获取录制器接口
    SLRecordItf audioRecorderInterface;
    (*andioRecorderObject)->GetInterface(andioRecorderObject, SL_IID_RECORD, &audioRecorderInterface);
}

int common()
{
    /**
     * 配置回调并启动输入、输出
     * 1. 配置输入、输出回调
     * 2. 启动输入输出
     * 3. 回调函数的实现   见上文
     **/

    // 输出回调
    result = *outputBufferQueueInterface)->RegisterCallback(outputBufferQueueInterface, outputCallback, NULL);

    // 输入回调
    result = (*inputBufferQueueInterface)->RegisterCallback(inputBufferQueueInterface, inputCallback, NULL);

    // 设置为播放状态
    result = (*audioPlayerInterface)->SetPlayState(audioPlayerInterface, SL_PLAYSTATE_PLAYING);
    // 设为录制状态
    result = (*andioRecorderObject)->SetRecordState(andioRecorderObject, SL_RECORDSTATE_RECORDING);

    // 启动回调机制
    (*inputBufferQueueInterface)->Enqueue(inputBufferQueueInterface, inputBuffers[0], buffersize * 4);
    (*outputBufferQueueInterface)->Enqueue(outputBufferQueueInterface, outputBuffers[0], buffersize * 4);


}