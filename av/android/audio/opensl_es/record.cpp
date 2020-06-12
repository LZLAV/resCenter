
/**
 *  缓冲区
 * */
#include "RecordBuffer.h"

RecordBuffer::RecordBuffer(int buffersize) {
    buffer = new short *[2];
    for(int i = 0; i < 2; i++)
    {
        buffer[i] = new short[buffersize];
    }
}

RecordBuffer::~RecordBuffer() {
}

short *RecordBuffer::getRecordBuffer() {
    index++;
    if(index > 1)
    {
        index = 0;
    }
    return buffer[index];
}

short *RecordBuffer::getNowBuffer() {
    return buffer[index];
}




#include <jni.h>
#include <string>
#include "AndroidLog.h"
#include "RecordBuffer.h"
#include "unistd.h"

extern "C"
{
#include <SLES/OpenSLES.h>
#include <SLES/OpenSLES_Android.h>
}

//引擎接口
static SLObjectItf engineObject = NULL;
//引擎对象
static SLEngineItf engineEngine;

//录音器接口
static SLObjectItf recorderObject = NULL;
//录音器对象
static SLRecordItf recorderRecord;
//缓冲队列
static SLAndroidSimpleBufferQueueItf recorderBufferQueue;

//录制大小设为4096
#define RECORDER_FRAMES (2048)
static unsigned recorderSize = RECORDER_FRAMES * 2;

//PCM文件
FILE *pcmFile;
//录音buffer
RecordBuffer *recordBuffer;

bool finished = false;


void bqRecorderCallback(SLAndroidSimpleBufferQueueItf bq, void *context)
{
    // for streaming recording, here we would call Enqueue to give recorder the next buffer to fill
    // but instead, this is a one-time buffer so we stop recording
    LOGD("record size is %d", recorderSize);

    fwrite(recordBuffer->getNowBuffer(), 1, recorderSize, pcmFile);

    if(finished)
    {
        (*recorderRecord)->SetRecordState(recorderRecord, SL_RECORDSTATE_STOPPED);
        fclose(pcmFile);
        LOGD("停止录音");
    } else{
        (*recorderBufferQueue)->Enqueue(recorderBufferQueue, recordBuffer->getRecordBuffer(),
                                        recorderSize);
    }
}

/**
 * OPENSL ES使用：
 * 1. 创建对象
 * 2. 初始化
 * 3. 获取接口来使用相关功能
 *
 * OPENSL ES使用回调机制来访问音频IO，但不像Jack、CoreAudio那些音频异步IO 框架，OpenSL 的回调里并不会把音频数据作为参数传递，回调方法仅仅是告诉我们：
 *  BufferQueue已经就绪，可以接受/获取数据了。
 *
 *  使用SLBufferQueueItf. Enqueue函数从(往)音频设备获取(放入)数据。完整的函数签名是：
 *      SLresult (*Enqueue) (SLBufferQueueItf self, const void *pBuffer, SLuint32 size);
 *
 *  当BufferQueue就绪，这个方法就应被调用。当开启录制或开始播放时，BufferQueue就可以接受数据。这之后，回调机制通过回调来告知应用程序它已经准备好，可以消费(提供)数据。
 *
 *  Enqueue方法在回调里调用，那么在开始播放(录制)的时候，需要先调用Enqueue来启动回调机制，否则回调将不会被调用到。
 */


extern "C"
JNIEXPORT void JNICALL
Java_ywl5320_com_openslrecord_MainActivity_rdSound(JNIEnv *env, jobject instance, jstring path_) {
    const char *path = env->GetStringUTFChars(path_, 0);
    /**
     * PCM文件
     */
    pcmFile = fopen(path, "w");
    /**
     * PCMbuffer队列
     */
    recordBuffer = new RecordBuffer(RECORDER_FRAMES * 2);
    SLresult result;
    /**
     * 创建引擎对象
     */
    result = slCreateEngine(&engineObject, 0, NULL, 0, NULL, NULL);
    result = (*engineObject)->Realize(engineObject, SL_BOOLEAN_FALSE);
    result = (*engineObject)->GetInterface(engineObject, SL_IID_ENGINE, &engineEngine);

    /**
     * 设置IO设备（麦克风）
     */
    SLDataLocator_IODevice loc_dev = {SL_DATALOCATOR_IODEVICE, SL_IODEVICE_AUDIOINPUT,
                                      SL_DEFAULTDEVICEID_AUDIOINPUT, NULL};
    SLDataSource audioSrc = {&loc_dev, NULL};
    /**
     * 设置buffer队列
     */
    SLDataLocator_AndroidSimpleBufferQueue loc_bq = {SL_DATALOCATOR_ANDROIDSIMPLEBUFFERQUEUE, 2};
    /**
     * 设置录制规格：PCM、2声道、44100HZ、16bit
     */
    SLDataFormat_PCM format_pcm = {SL_DATAFORMAT_PCM, 2, SL_SAMPLINGRATE_44_1,
                                   SL_PCMSAMPLEFORMAT_FIXED_16, SL_PCMSAMPLEFORMAT_FIXED_16,
                                   SL_SPEAKER_FRONT_LEFT | SL_SPEAKER_FRONT_RIGHT, SL_BYTEORDER_LITTLEENDIAN};
    //设置管道
    SLDataSink audioSnk = {&loc_bq, &format_pcm};

    const SLInterfaceID id[1] = {SL_IID_ANDROIDSIMPLEBUFFERQUEUE};
    const SLboolean req[1] = {SL_BOOLEAN_TRUE};

    /**
     * 创建录制器
     */
    result = (*engineEngine)->CreateAudioRecorder(engineEngine, &recorderObject, &audioSrc,
                                                  &audioSnk, 1, id, req);
    if (SL_RESULT_SUCCESS != result) {
        return;
    }
    result = (*recorderObject)->Realize(recorderObject, SL_BOOLEAN_FALSE);
    if (SL_RESULT_SUCCESS != result) {
        return;
    }
    result = (*recorderObject)->GetInterface(recorderObject, SL_IID_RECORD, &recorderRecord);
    result = (*recorderObject)->GetInterface(recorderObject, SL_IID_ANDROIDSIMPLEBUFFERQUEUE,
                                             &recorderBufferQueue);

    /**
     * 设置回调
     */
    finished = false;
    result = (*recorderBufferQueue)->Enqueue(recorderBufferQueue, recordBuffer->getRecordBuffer(),
                                             recorderSize);
    result = (*recorderBufferQueue)->RegisterCallback(recorderBufferQueue, bqRecorderCallback, NULL);
    LOGD("开始录音");
    /**
     * 开始录音
     */
    (*recorderRecord)->SetRecordState(recorderRecord, SL_RECORDSTATE_RECORDING);
    env->ReleaseStringUTFChars(path_, path);
}extern "C"
JNIEXPORT void JNICALL
Java_ywl5320_com_openslrecord_MainActivity_rdStop(JNIEnv *env, jobject instance) {

    // TODO
    if(recorderRecord != NULL)
    {
        finished = true;
    }
}
