
//create
	
	private final static String MINE_TYPE = "audio/mp4a-latm";	//aac
	private MediaCodec mediaCodec;
	private ByteBuffer[] inputBuffers;
	private ByteBuffer[] outputBuffers;
	
	MediaFormat encodeFormat = MediaFormat.createAudioFormat(MINE_TYPE, sampleRate, channels);
	encodeFormat.setInteger(MediaFormat.KEY_BIT_RATE, bitRate);//比特率
	encodeFormat.setInteger(MediaFormat.KEY_AAC_PROFILE, MediaCodecInfo.CodecProfileLevel.AACObjectLC);
	encodeFormat.setInteger(MediaFormat.KEY_MAX_INPUT_SIZE, 10 * 1024);
	mediaCodec = MediaCodec.createEncoderByType(MINE_TYPE);
	

//config
	mediaCodec.configure(encodeFormat, null, null, MediaCodec.CONFIGURE_FLAG_ENCODE);
	

//start
	mediaCodec.start();
	inputBuffers = mediaCodec.getInputBuffers();
	outputBuffers = mediaCodec.getOutputBuffers();


//encode
	int inputBufferIndex = mediaCodec.dequeueInputBuffer(-1);
	if (inputBufferIndex >= 0) {
		ByteBuffer inputBuffer = inputBuffers[inputBufferIndex];
		inputBuffer.clear();
		inputBuffer.put(data);
		mediaCodec.queueInputBuffer(inputBufferIndex, 0, len, System.nanoTime(), 0);
	}
	MediaCodec.BufferInfo bufferInfo = new MediaCodec.BufferInfo();
	int outputBufferIndex = mediaCodec.dequeueOutputBuffer(bufferInfo, 0);
	while (outputBufferIndex >= 0) {
		ByteBuffer outputBuffer = outputBuffers[outputBufferIndex];
		if (outputAACDelegate != null) {
			int outPacketSize = bufferInfo.size + 7;// 7为ADTS头部的大小
			outputBuffer.position(bufferInfo.offset);
			outputBuffer.limit(bufferInfo.offset + bufferInfo.size);
			byte[] outData = new byte[outPacketSize];
			addADTStoPacket(outData, outPacketSize);//添加ADTS 代码后面会贴上
			outputBuffer.get(outData, 7, bufferInfo.size);//将编码得到的AAC数据 取出到byte[]中 偏移量offset=7
			outputBuffer.position(bufferInfo.offset);
			outputAACDelegate.outputAACPacket(outData);
		}
		mediaCodec.releaseOutputBuffer(outputBufferIndex, false);
		outputBufferIndex = mediaCodec.dequeueOutputBuffer(bufferInfo, 0);
	}


//add ADTS	7字节
private void addADTStoPacket(byte[] packet, int packetLen) {
	int profile = 2; // AAC LC
	int freqIdx = 4; // 44.1KHz
	int chanCfg = 2; // CPE
	// fill in ADTS data 70 
	packet[0] = (byte) 0xFF;
	packet[1] = (byte) 0xF9;
	packet[2] = (byte) (((profile - 1) << 6) + (freqIdx << 2) + (chanCfg >> 2));
	packet[3] = (byte) (((chanCfg & 3) << 6) + (packetLen >> 11));
	packet[4] = (byte) ((packetLen & 0x7FF) >> 3);
	packet[5] = (byte) (((packetLen & 7) << 5) + 0x1F);
	packet[6] = (byte) 0xFC;
}


//stop、release
	mediaCodec.stop();
	mediaCodec.release();