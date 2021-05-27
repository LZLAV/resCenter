public class RecordHelper {
    
    //0.此状态用于控制线程中的循环操作，应用volatile修饰，保持数据的一致性
    private volatile RecordState state = RecordState.IDLE;
    private AudioRecordThread audioRecordThread;
    private File tmpFile = null;

    public void start(String filePath, RecordConfig config) {
        if (state != RecordState.IDLE) {
            Logger.e(TAG, "状态异常当前状态： %s", state.name());
            return;
        }
        recordFile = new File(filePath);
        String tempFilePath = getTempFilePath();
        Logger.i(TAG, "tmpPCM File: %s", tempFilePath);
        tmpFile = new File(tempFilePath);
        //1.开启录音线程并准备录音
        audioRecordThread = new AudioRecordThread();
        audioRecordThread.start();
    }

    public void stop() {
        if (state == RecordState.IDLE) {
            Logger.e(TAG, "状态异常当前状态： %s", state.name());
            return;
        }

        state = RecordState.STOP;
    }

    private class AudioRecordThread extends Thread {
        private AudioRecord audioRecord;
        private int bufferSize;

        AudioRecordThread() {
            //2.根据录音参数构造AudioRecord实体对象
            bufferSize = AudioRecord.getMinBufferSize(currentConfig.getFrequency(),
                    currentConfig.getChannel(), currentConfig.getEncoding()) * RECORD_AUDIO_BUFFER_TIMES;
            audioRecord = new AudioRecord(MediaRecorder.AudioSource.MIC, currentConfig.getFrequency(),
                    currentConfig.getChannel(), currentConfig.getEncoding(), bufferSize);
        }

        @Override
        public void run() {
            super.run();
            state = RecordState.RECORDING;
            Logger.d(TAG, "开始录制");
            FileOutputStream fos = null;
            try {
                fos = new FileOutputStream(tmpFile);
                audioRecord.startRecording();
                byte[] byteBuffer = new byte[bufferSize];

                while (state == RecordState.RECORDING) {
                    //3.不断读取录音数据并保存至文件中
                    int end = audioRecord.read(byteBuffer, 0, byteBuffer.length);
                    fos.write(byteBuffer, 0, end);
                    fos.flush();
                }
                //4.当执行stop()方法后state != RecordState.RECORDING，终止循环，停止录音
                audioRecord.stop();
            } catch (Exception e) {
                Logger.e(e, TAG, e.getMessage());
            } finally {
                try {
                    if (fos != null) {
                        fos.close();
                    }
                } catch (IOException e) {
                    Logger.e(e, TAG, e.getMessage());
                }
            }
            state = RecordState.IDLE;
            Logger.d(TAG, "录音结束");
        }
    }
}