## OpenSL ES

OpenSL ES 提供 C语言接口和 C++ 绑定，利用这个库，不论编写合成器、数字音频工作站、卡拉ok、游戏还是其他实时应用，都可以实现高性能、短延迟时间音频。

#### OpenSL ES Android扩展

#include <SLES/OpenSLES_Android.h>

自动包括

#include <SLES/OpenSLES_AndroidConfiguration.h>

#include <SLES/OpenSLES_AndroidMetadata.h>



Android.mk

LOCAL_LDLIBS += -lOpenSLES



assets/  文件夹下，可以通过原生资源管理器 API 直接访问

#include <android/asset_manager.h>

#include <android/asset_manager_jni.h>



### 开发流程

1. 创建接口对象
2. 设置混音器
3. 创建播放器（录音器）
4. 设置缓冲队列和回调函数
5. 设置播放状态
6. 启动回调函数



4,6 播放 PCM 需要用到



### 重要接口

#### OpenSL ES中最重要的接口类SLObjectItf

通过SLObjectItf接口类我们可以创建所需要的各种类型的类接口，比如：

​        创建引擎接口对象：SLObjectItf engineObject

​        创建混音器接口对象：SLObjectItf outputMixObject

​        创建播放器接口对象：SLObjectItf playerObject

以上等等都是通过SLObjectItf来创建的。



#### 利用SLObjectItf来创建具体的接口对象实例

OpenSL ES中也有具体的接口类，比如（引擎：SLEngineItf，播放器：SLPlayItf，声音控制器：SLVolumeItf等等）。



### 要点

#### 创建音频引擎并实现它

1. OpenSL ES中开始的第一步都是声明SLObjectItf接口类型的引擎接口对象 engineObject。
2. 然后用方法slCreateEngine创建一个引擎接口对象。
3. 创建好引擎接口对象后，需要用SLObjectItf的Realize方法来实现engineObject。
4. 最后用SLObjectItf的GetInterface方法来初始化SLEngnineItf对象实例。

```c
SLObjectItf engineObject = NULL;//用SLObjectItf声明引擎接口对象
SLEngineItf engineEngine = NULL;//声明具体的引擎对象实例

void createEngine()
{
    SLresult result;//返回结果
    result = slCreateEngine(&engineObject, 0, NULL, 0, NULL, NULL);//第一步创建引擎
    result = (*engineObject)->Realize(engineObject, SL_BOOLEAN_FALSE);//实现（Realize）engineObject接口对象
    result = (*engineObject)->GetInterface(engineObject, SL_IID_ENGINE, &engineEngine);//通过engineObject的GetInterface方法初始化engineEngine
}
```

#### 利用引擎对象创建其他接口对象

其他接口对象（SLObjectItf outputMixObject，SLObjectItf playerObject）等都是用引擎接口对象创建的。

```c
//混音器
SLObjectItf outputMixObject = NULL;//用SLObjectItf创建混音器接口对象
SLEnvironmentalReverbItf outputMixEnvironmentalReverb = NULL;////创建具体的混音器对象实例

result = (*engineEngine)->CreateOutputMix(engineEngine, &outputMixObject, 1, mids, mreq);//利用引擎接口对象创建混音器接口对象
result = (*outputMixObject)->Realize(outputMixObject, SL_BOOLEAN_FALSE);//实现（Realize）混音器接口对象
result = (*outputMixObject)->GetInterface(outputMixObject, SL_IID_ENVIRONMENTALREVERB, &outputMixEnvironmentalReverb);//利用混音器接口对象初始化具体混音器实例

//播放器
SLObjectItf playerObject = NULL;//用SLObjectItf创建播放器接口对象
SLPlayItf playerPlay = NULL;//创建具体的播放器对象实例

//audioSrc	输出源
//audioSnk	输出管道

result = (*engineEngine)->CreateAudioPlayer(engineEngine, &playerObject, &audioSrc, &audioSnk, 3, ids, req);//利用引擎接口对象创建播放器接口对象
result = (*playerObject)->Realize(playerObject, SL_BOOLEAN_FALSE);//实现（Realize）播放器接口对象
result = (*playerObject)->GetInterface(playerObject, SL_IID_PLAY, &playerPlay);//初始化具体的播放器对象实例
```

### 示例

#### 播放 assets文件

```c
JNIEXPORT void JNICALL
Java_com_ywl5320_openslaudio_MainActivity_playAudioByOpenSL_1assets(JNIEnv *env, jobject instance, jobject assetManager, jstring filename) {

    release();
    const char *utf8 = (*env)->GetStringUTFChars(env, filename, NULL);

    // use asset manager to open asset by filename
    AAssetManager* mgr = AAssetManager_fromJava(env, assetManager);
    AAsset* asset = AAssetManager_open(mgr, utf8, AASSET_MODE_UNKNOWN);
    (*env)->ReleaseStringUTFChars(env, filename, utf8);

    // open asset as file descriptor
    off_t start, length;
    int fd = AAsset_openFileDescriptor(asset, &start, &length);
    AAsset_close(asset);

    SLresult result;


    //第一步，创建引擎
    createEngine();

    //第二步，创建混音器
    const SLInterfaceID mids[1] = {SL_IID_ENVIRONMENTALREVERB};
    const SLboolean mreq[1] = {SL_BOOLEAN_FALSE};
    result = (*engineEngine)->CreateOutputMix(engineEngine, &outputMixObject, 1, mids, mreq);
    (void)result;
    result = (*outputMixObject)->Realize(outputMixObject, SL_BOOLEAN_FALSE);
    (void)result;
    result = (*outputMixObject)->GetInterface(outputMixObject, SL_IID_ENVIRONMENTALREVERB, &outputMixEnvironmentalReverb);
    if (SL_RESULT_SUCCESS == result) {
        result = (*outputMixEnvironmentalReverb)->SetEnvironmentalReverbProperties(outputMixEnvironmentalReverb, &reverbSettings);
        (void)result;
    }
    //第三步，设置播放器参数和创建播放器
    // 1、 配置 audio source
    SLDataLocator_AndroidFD loc_fd = {SL_DATALOCATOR_ANDROIDFD, fd, start, length};
    SLDataFormat_MIME format_mime = {SL_DATAFORMAT_MIME, NULL, SL_CONTAINERTYPE_UNSPECIFIED};
    SLDataSource audioSrc = {&loc_fd, &format_mime};

    // 2、 配置 audio sink
    SLDataLocator_OutputMix loc_outmix = {SL_DATALOCATOR_OUTPUTMIX, outputMixObject};
    SLDataSink audioSnk = {&loc_outmix, NULL};

    // 创建播放器
    const SLInterfaceID ids[3] = {SL_IID_SEEK, SL_IID_MUTESOLO, SL_IID_VOLUME};
    const SLboolean req[3] = {SL_BOOLEAN_TRUE, SL_BOOLEAN_TRUE, SL_BOOLEAN_TRUE};
    result = (*engineEngine)->CreateAudioPlayer(engineEngine, &fdPlayerObject, &audioSrc, &audioSnk, 3, ids, req);
    (void)result;

    // 实现播放器
    result = (*fdPlayerObject)->Realize(fdPlayerObject, SL_BOOLEAN_FALSE);
    (void)result;

    // 得到播放器接口
    result = (*fdPlayerObject)->GetInterface(fdPlayerObject, SL_IID_PLAY, &fdPlayerPlay);
    (void)result;

    // 得到声音控制接口
    result = (*fdPlayerObject)->GetInterface(fdPlayerObject, SL_IID_VOLUME, &fdPlayerVolume);
    (void)result;

    //第四步，设置播放状态
    if (NULL != fdPlayerPlay) {

        result = (*fdPlayerPlay)->SetPlayState(fdPlayerPlay, SL_PLAYSTATE_PLAYING);
        (void)result;
    }

    //设置播放音量 （100 * -50：静音 ）
    (*fdPlayerVolume)->SetVolumeLevel(fdPlayerVolume, 20 * -50);

}
```



#### 播放 Uri连接

```c
JNIEXPORT void JNICALL
Java_com_ywl5320_openslaudio_MainActivity_playAudioByOpenSL_1uri(JNIEnv *env, jobject instance, jstring uri) {
    SLresult result;
    release();
    // convert Java string to UTF-8
    const char *utf8 = (*env)->GetStringUTFChars(env, uri, NULL);

    //第一步，创建引擎
    createEngine();

    //第二步，创建混音器
    const SLInterfaceID mids[1] = {SL_IID_ENVIRONMENTALREVERB};
    const SLboolean mreq[1] = {SL_BOOLEAN_FALSE};
    result = (*engineEngine)->CreateOutputMix(engineEngine, &outputMixObject, 1, mids, mreq);
    (void)result;
    result = (*outputMixObject)->Realize(outputMixObject, SL_BOOLEAN_FALSE);
    (void)result;
    result = (*outputMixObject)->GetInterface(outputMixObject, SL_IID_ENVIRONMENTALREVERB, &outputMixEnvironmentalReverb);
    if (SL_RESULT_SUCCESS == result) {
        result = (*outputMixEnvironmentalReverb)->SetEnvironmentalReverbProperties(
                outputMixEnvironmentalReverb, &reverbSettings);
        (void)result;
    }
    
    //第三步，设置播放器参数和创建播放器
    // configure audio source
    // (requires the INTERNET permission depending on the uri parameter)
    SLDataLocator_URI loc_uri = {SL_DATALOCATOR_URI, (SLchar *) utf8};
    SLDataFormat_MIME format_mime = {SL_DATAFORMAT_MIME, NULL, SL_CONTAINERTYPE_UNSPECIFIED};
    SLDataSource audioSrc = {&loc_uri, &format_mime};

    // configure audio sink
    SLDataLocator_OutputMix loc_outmix = {SL_DATALOCATOR_OUTPUTMIX, outputMixObject};
    SLDataSink audioSnk = {&loc_outmix, NULL};

    // create audio player
    const SLInterfaceID ids[3] = {SL_IID_SEEK, SL_IID_MUTESOLO, SL_IID_VOLUME};
    const SLboolean req[3] = {SL_BOOLEAN_TRUE, SL_BOOLEAN_TRUE, SL_BOOLEAN_TRUE};
    result = (*engineEngine)->CreateAudioPlayer(engineEngine, &uriPlayerObject, &audioSrc, &audioSnk, 3, ids, req);

    (void)result;
    
    // release the Java string and UTF-8
    (*env)->ReleaseStringUTFChars(env, uri, utf8);

    // realize the player
    result = (*uriPlayerObject)->Realize(uriPlayerObject, SL_BOOLEAN_FALSE);
    // this will always succeed on Android, but we check result for portability to other platforms
    if (SL_RESULT_SUCCESS != result) {
        (*uriPlayerObject)->Destroy(uriPlayerObject);
        uriPlayerObject = NULL;
        return;
    }

    // get the play interface
    result = (*uriPlayerObject)->GetInterface(uriPlayerObject, SL_IID_PLAY, &uriPlayerPlay);
    (void)result;


    // get the volume interface
    result = (*uriPlayerObject)->GetInterface(uriPlayerObject, SL_IID_VOLUME, &uriPlayerVolume);
    (void)result;
//第四步，设置播放状态
    if (NULL != uriPlayerPlay) {

        // set the player's state
        result = (*uriPlayerPlay)->SetPlayState(uriPlayerPlay, SL_PLAYSTATE_PLAYING);
        (void)result;
    }

    //设置播放音量 （100 * -50：静音 ）
//    (*uriPlayerVolume)->SetVolumeLevel(uriPlayerVolume, 0 * -50);
}
```

#### 播放pcm文件

##### 创建播放器和混音器

```c
	//第一步，创建引擎
    createEngine();

    //第二步，创建混音器
    const SLInterfaceID mids[1] = {SL_IID_ENVIRONMENTALREVERB};
    const SLboolean mreq[1] = {SL_BOOLEAN_FALSE};
    result = (*engineEngine)->CreateOutputMix(engineEngine, &outputMixObject, 1, mids, mreq);
    (void)result;
    result = (*outputMixObject)->Realize(outputMixObject, SL_BOOLEAN_FALSE);
    (void)result;
    result = (*outputMixObject)->GetInterface(outputMixObject, SL_IID_ENVIRONMENTALREVERB, &outputMixEnvironmentalReverb);
    if (SL_RESULT_SUCCESS == result) {
        result = (*outputMixEnvironmentalReverb)->SetEnvironmentalReverbProperties(
                outputMixEnvironmentalReverb, &reverbSettings);
        (void)result;
    }
    SLDataLocator_OutputMix outputMix = {SL_DATALOCATOR_OUTPUTMIX, outputMixObject};
    SLDataSink audioSnk = {&outputMix, NULL};
```

##### 设置pcm格式的频率位数等信息并创建播放器

```c
	// 第三步，配置PCM格式信息
    SLDataLocator_AndroidSimpleBufferQueue android_queue={SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE,2};
    SLDataFormat_PCM pcm={
            SL_DATAFORMAT_PCM,//播放pcm格式的数据
            2,//2个声道（立体声）
            SL_SAMPLINGRATE_44_1,//44100hz的频率
            SL_PCMSAMPLEFORMAT_FIXED_16,//位数 16位
            SL_PCMSAMPLEFORMAT_FIXED_16,//和位数一致就行
            SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT,//立体声（前左前右）
            SL_BYTEORDER_LITTLEENDIAN//结束标志
    };
    SLDataSource slDataSource = {&android_queue, &pcm};


    const SLInterfaceID ids[3] = {SL_IID_BUFFERQUEUE, SL_IID_EFFECTSEND, SL_IID_VOLUME};
    const SLboolean req[3] = {SL_BOOLEAN_TRUE, SL_BOOLEAN_TRUE, SL_BOOLEAN_TRUE};
    
    result = (*engineEngine)->CreateAudioPlayer(engineEngine, &pcmPlayerObject, &slDataSource, &audioSnk, 3, ids, req);
    //初始化播放器
    (*pcmPlayerObject)->Realize(pcmPlayerObject, SL_BOOLEAN_FALSE);

//    得到接口后调用  获取Player接口
    (*pcmPlayerObject)->GetInterface(pcmPlayerObject, SL_IID_PLAY, &pcmPlayerPlay);
```

##### 设置缓冲队列和回调函数

```c
	//注册回调缓冲区 获取缓冲队列接口
    (*pcmPlayerObject)->GetInterface(pcmPlayerObject, SL_IID_BUFFERQUEUE, &pcmBufferQueue);
    //缓冲接口回调
    (*pcmBufferQueue)->RegisterCallback(pcmBufferQueue, pcmBufferCallBack, NULL);
```

##### 回调函数

```c
void * pcmBufferCallBack(SLAndroidBufferQueueItf bf, void * context)
{
    //assert(NULL == context);
    getPcmData(&buffer);
    // for streaming playback, replace this test by logic to find and fill the next buffer
    if (NULL != buffer) {
        SLresult result;
        // enqueue another buffer
        result = (*pcmBufferQueue)->Enqueue(pcmBufferQueue, buffer, 44100 * 2 * 2);
        // the most likely other result is SL_RESULT_BUFFER_INSUFFICIENT,
        // which for this code example would indicate a programming error
    }
}
```

##### 读取pcm格式的文件

```c
void getPcmData(void **pcm)
{
    while(!feof(pcmFile))
    {
        fread(out_buffer, 44100 * 2 * 2, 1, pcmFile);
        if(out_buffer == NULL)
        {
            LOGI("%s", "read end");
            break;
        } else{
            LOGI("%s", "reading");
        }
        *pcm = out_buffer;
        break;
    }
}
```

##### 设置播放状态并手动开始调用回调函数

```c
//获取播放状态接口
(*pcmPlayerPlay)->SetPlayState(pcmPlayerPlay, SL_PLAYSTATE_PLAYING);

//主动调用回调函数开始工作
pcmBufferCallBack(pcmBufferQueue, NULL);
```



#### PCM边采集边播放

##### 创建并初始化 Audio Engine

```c
// 创建Audio Engine
result = slCreateEngine(&openSLEngine, 0, NULL, 0, NULL, NULL);

// 初始化上一步得到的openSLEngine
result = (*openSLEngine)->Realize(openSLEngine, SL_BOOLEAN_FALSE);

// 获取SLEngine接口对象，后续的操作将使用这个对象
SLEngineItf openSLEngineInterface = NULL;
result = (*openSLEngine)->GetInterface(openSLEngine, SL_IID_ENGINE, &openSLEngineInterface);
```

##### 音频输出

###### 打开音频输出设备

```c
// 相关参数
const SLInterfaceID ids[] = {SL_IID_VOLUME};
const SLboolean req[] = {SL_BOOLEAN_FALSE};

// 使用第一步的openSLEngineInterface，创建音频输出Output Mix
result = (*openSLEngineInterface)->CreateOutputMix(openSLEngineInterface, &outputMix, 0, ids, req);

// 初始化outputMix
result = (*outputMix)->Realize(outputMix, SL_BOOLEAN_FALSE);

// 由于不需要操作到ouputMix，所以这一步就不去获取它的接口对象
```

###### 配置相关参数

```c
// Buffer Queue的参数
SLDataLocator_AndroidSimpleBufferQueue outputLocator = { SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE, 1 };

// 设置音频格式
SLDataFormat_PCM outputFormat = { SL_DATAFORMAT_PCM, 2, samplerate, SL_PCMSAMPLEFORMAT_FIXED_16, SL_PCMSAMPLEFORMAT_FIXED_16, SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT, SL_BYTEORDER_LITTLEENDIAN };

// 输出源
SLDataSource outputSource = { &outputLocator, &outputFormat };

// 输出管道
SLDataLocator_OutputMix outputMixLocator = { SL_DATALOCATOR_OUTPUTMIX, outputMix };
SLDataSink outputSink = { &outputMixLocator, NULL };
```

###### 创建播放器

```c
// 参数
const SLInterfaceID outputInterfaces[1] = { SL_IID_BUFFERQUEUE };
const SLboolean requireds[2] = { SL_BOOLEAN_TRUE, SL_BOOLEAN_FALSE };

// 创建音频播放对象AudioPlayer
result = (*openSLEngineInterface)->CreateAudioPlayer(openSLEngineInterface, &audioPlayerObject, &outputSource, &outputSink, 1, outputInterfaces, requireds);

// 初始化AudioPlayer
result = (*audioPlayerObject)->Realize(audioPlayerObject, SL_BOOLEAN_FALSE);

// 获取音频输出的BufferQueue接口
SLAndroidSimpleBufferQueueItf outputBufferQueueInterface = NULL;
result = (*audioPlayerObject)->GetInterface(audioPlayerObject, SL_IID_ANDROIDSIMPLEBUFFERQUEUE, &outputBufferQueueInterface); 

// 获取播放器接口
SLPlayItf outputPlayInterface;
result = (*audioPlayerObject)->GetInterface(audioPlayerObject, SL_IID_PLAY, &audioPlayerInterface);
```

##### 音频输入

###### 配置参数

```c
// 参数
SLDataLocator_IODevice deviceInputLocator = { SL_DATALOCATOR_IODEVICE, SL_IODEVICE_AUDIOINPUT, SL_DEFAULTDEVICEID_AUDIOINPUT, NULL };
SLDataSource inputSource = { &deviceInputLocator, NULL };

SLDataLocator_AndroidSimpleBufferQueue inputLocator = { SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE, 1 };
SLDataFormat_PCM inputFormat = { SL_DATAFORMAT_PCM, 2, samplerate * 1000, SL_PCMSAMPLEFORMAT_FIXED_16, SL_PCMSAMPLEFORMAT_FIXED_16, SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT, SL_BYTEORDER_LITTLEENDIAN };

SLDataSink inputSink = { &inputLocator, &inputFormat };

const SLInterfaceID inputInterfaces[2] = { SL_IID_ANDROIDSIMPLEBUFFERQUEUE, SL_IID_ANDROIDCONFIGURATION };

const SLboolean requireds[2] = { SL_BOOLEAN_TRUE, SL_BOOLEAN_FALSE };
```

###### 创建录制器

```c
// 创建AudioRecorder
result = (*openSLEngineInterface)->CreateAudioRecorder(openSLEngineInterface, &andioRecorderObject, &inputSource, &inputSink, 2, inputInterfaces, requireds);

// 初始化AudioRecorder
result = (*andioRecorderObject)->Realize(andioRecorderObject, SL_BOOLEAN_FALSE);

// 获取音频输入的BufferQueue接口
result = (*andioRecorderObject)->GetInterface(andioRecorderObject, SL_IID_ANDROIDSIMPLEBUFFERQUEUE, &inputBufferQueueInterface);

// 获取录制器接口
SLRecordItf audioRecorderInterface;
(*andioRecorderObject)->GetInterface(andioRecorderObject, SL_IID_RECORD, &audioRecorderInterface);
```

##### 配置回调并启动输入、输出

###### 配置输入、输出回调

```c
// 输出回调
result = *outputBufferQueueInterface)->RegisterCallback(outputBufferQueueInterface, outputCallback, NULL);

// 输入回调
result = (*inputBufferQueueInterface)->RegisterCallback(inputBufferQueueInterface, inputCallback, NULL);
```

###### 启动输入输出

```c
// 设置为播放状态
result = (*audioPlayerInterface)->SetPlayState(audioPlayerInterface, SL_PLAYSTATE_PLAYING);
// 设为录制状态
result = (*andioRecorderObject)->SetRecordState(andioRecorderObject, SL_RECORDSTATE_RECORDING);

// 启动回调机制
(*inputBufferQueueInterface)->Enqueue(inputBufferQueueInterface, inputBuffers[0], buffersize * 4);
(*outputBufferQueueInterface)->Enqueue(outputBufferQueueInterface, outputBuffers[0], buffersize * 4);
```

##### 回调函数的实现

```c
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
```







#### 疑问点

输出源\输入源   		参数设置

输出管道\输入管道	参数设置	