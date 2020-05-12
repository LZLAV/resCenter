//init
	private int AUDIO_SOURCE = MediaRecorder.AudioSource.MIC;
	public static int SAMPLE_RATE_IN_HZ = 44100;
	private final static int CHANNEL_CONFIGURATION = AudioFormat.CHANNEL_IN_MONO;
	private final static int AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT;
	private int bufferSizeInBytes = 0;
	
	bufferSizeInBytes = AudioRecord.getMinBufferSize(SAMPLE_RATE_IN_HZ, CHANNEL_CONFIGURATION, AUDIO_FORMAT);
	audioRecord = new AudioRecord(AUDIO_SOURCE, SAMPLE_RATE_IN_HZ, CHANNEL_CONFIGURATION, AUDIO_FORMAT,bufferSizeInBytes);
	
	state : AudioRecord.STATE_INITIALIZED
	
//start
	audioRecord.startRecording();
	int size = audioRecord.read(audioSamples, 0, bufferSize);
	
	
//stop/release
	audioRecord.stop();
	audioRecord.release();
		audioRecord = null;