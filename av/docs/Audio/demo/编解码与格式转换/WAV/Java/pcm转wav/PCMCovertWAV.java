public class PCMCovertWAV {
    private static final String TAG = PCMCovertWAV.class.getSimpleName();
	/**
	* 生成wav格式的Header
	* wave是RIFF文件结构，每一部分为一个chunk，其中有RIFF WAVE chunk，
	* FMT Chunk，Fact chunk（可选）,Data chunk
	*
	* @param totalAudioLen 不包括header的音频数据总长度
	* @param sampleRate    采样率,也就是录制时使用的频率
	* @param channels      audioRecord的频道数量
	* @param sampleBits    位宽
	*/
	public static byte[] generateWavFileHeader(int totalAudioLen, int sampleRate, int channels, int sampleBits) {
		WavHeader wavHeader = new WavHeader(totalAudioLen, sampleRate, (short) channels, (short) sampleBits);
		return wavHeader.getHeader();
	}

    /**
     * 将header写入到pcm文件中 不修改文件名
     *
     * @param file   写入的pcm文件
     * @param header wav头数据
     */
    public static void writeHeader(File file, byte[] header) {
        if (!FileUtils.isFile(file)) {
            return;
        }

        RandomAccessFile wavRaf = null;
        try {
            wavRaf = new RandomAccessFile(file, "rw");
            wavRaf.seek(0);
            wavRaf.write(header);
            wavRaf.close();
        } catch (Exception e) {
            Logger.e(e, TAG, e.getMessage());
        } finally {
            try {
                if (wavRaf != null) {
                    wavRaf.close();
                }
            } catch (IOException e) {
                Logger.e(e, TAG, e.getMessage());
            }
        }
	}
	
	
	private void makeFile() {
		
		mergePcmFiles(recordFile, files);

		//这里实现上一篇未完成的工作
		byte[] header = WavUtils.generateWavFileHeader((int) resultFile.length(), currentConfig.getSampleRate(), currentConfig.getChannelCount(), currentConfig.getEncoding());
		WavUtils.writeHeader(resultFile, header);
    
		Logger.i(TAG, "录音完成！ path: %s ； 大小：%s", recordFile.getAbsoluteFile(), recordFile.length());
    }
}