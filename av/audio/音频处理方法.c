

//调节音量的方法
inline SInt16 adjustAudioVolume(SInt16 source, float volume) {
	/**
	SInt16 result = source;
	int temp = (int) ((int) source * volume);
	if (temp < -0x8000) {
		result = -0x8000;
	} else if (temp > 0x7FFF) {
		result = 0x7FFF;
	} else {
		result = (short) temp;
	}
	return result;
	**/

	SInt16 result = source;
	int temp = (int) ((int) source * volume);
	int sign = 1;
	if (temp < 0) {
		sign = -1;
	}
	int abstemp = abs(temp);
	if (abstemp < 29490) {
		result = temp;
	}
	else if (abstemp > 46285) {
		result = 32767 * sign;
	}
	else if (abstemp > 32630) {
		result = ((abstemp - 29490) / 8 + 30668)*sign;
	}
	else {
		result = ((abstemp - 29490) / 2 + 29490)*sign;
	}
	return result;
}


//客户端代码需要根据accompanySampleRate / audioSampleRate算出transfer_ratio;
//以及根据(int)((float)(sample_count) / accompanySampleRate * audioSampleRate)算出transfered_sample_count;
//并且分配出samples_transfered---将伴奏mp3解析成为pcm的short数组，需要先进行转换为录音的采样频率
inline void convertAccompanySampleRateByAudioSampleRate(SInt16 *samples, SInt16 *samples_transfered, int transfered_sample_count, float transfer_ratio) {
	for (int i = 0; i < transfered_sample_count; i++) {
		samples_transfered[i] = samples[(int) (i * transfer_ratio)];
	}
}

//调节采样的音量---非清唱时候最终合成伴奏与录音的时候，判断如果accompanyVolume不是1.0的话，先调节伴奏的音量；而audioVolume是在读出的字节流转换为short流的时候调节的。
inline void adjustSamplesVolume(SInt16 *samples, int size, float accompanyVolume) {
	if (accompanyVolume != 1.0) {
		for (int i = 0; i < size; i++) {
			samples[i] = adjustAudioVolume(samples[i], accompanyVolume);
		}
	}
}

//合成伴奏与录音,byte数组需要在客户端分配好内存---非清唱时候最终合成伴奏与录音调用
inline void mixtureAccompanyAudio(SInt16 *accompanyData, SInt16 *audioData, int size, byte *targetArray) {
	byte* tmpbytearray = new byte[2];
	for (int i = 0; i < size; i++) {
		SInt16 audio = audioData[i];
		SInt16 accompany = accompanyData[i];
		SInt16 temp = TPMixSamples(accompany, audio);
		converttobytearray(temp, tmpbytearray);
		targetArray[i * 2] = tmpbytearray[0];
		targetArray[i * 2 + 1] = tmpbytearray[1];
	}
	delete[] tmpbytearray;
}

//合成伴奏与录音,short数组需要在客户端分配好内存---非清唱时候边和边放调用
inline void mixtureAccompanyAudio(SInt16 *accompanyData, SInt16 *audioData, int size, short *targetArray) {
	for (int i = 0; i < size; i++) {
		SInt16 audio = audioData[i];
		SInt16 accompany = accompanyData[i];
		targetArray[i] = TPMixSamples(accompany, audio);
	}
}