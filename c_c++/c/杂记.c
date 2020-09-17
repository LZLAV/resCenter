
#define UINT64_C(value) __CONCAT(value,ULL)
	
	__CONCAT(value,ULL) --> value##ULL
	ULL:整型字面量可以使用后缀u U ul UL ull ULL明确表示各种无符号整型；使用后缀l L ll LL表示该字面量至少为long或为long long型。
	

//数组长度
#define ARRAY_LEN(a) (sizeof(a) / sizeof(a[0]))

//获取当前时间
static inline long long getCurrentTime()
{
   struct timeval tv;
   gettimeofday(&tv,NULL);
   return tv.tv_sec * 1000 + tv.tv_usec / 1000;
}

//检验文件结束符
int flag = feof(fp)
原型在stdio.h中，其功能是检测流上的文件结束符，如果文件结束，则返回非0值，否则返回0



#define INT16_MAX        32767
#define INT16_MIN       -32768
//合并两个short，返回一个short
inline SInt16 TPMixSamples(SInt16 a, SInt16 b) {
	int tmp = a < 0 && b < 0 ? ((int) a + (int) b) - (((int) a * (int) b) / INT16_MIN) : (a > 0 && b > 0 ? ((int) a + (int) b) - (((int) a * (int) b) / INT16_MAX) : a + b);
	return tmp > INT16_MAX ? INT16_MAX : (tmp < INT16_MIN ? INT16_MIN : tmp);
}

//合并两个float，返回一个short
inline SInt16 TPMixSamplesFloat(float a, float b) {
	int tmp = a < 0 && b < 0 ? ((int) a + (int) b) - (((int) a * (int) b) / INT16_MIN) : (a > 0 && b > 0 ? ((int) a + (int) b) - (((int) a * (int) b) / INT16_MAX) : a + b);
	return tmp > INT16_MAX ? INT16_MAX : (tmp < INT16_MIN ? INT16_MIN : tmp);
}

//把一个short转换为一个长度为2的byte数组
inline void converttobytearray(SInt16 source, byte* bytes2) {
	bytes2[0] = (byte) (source & 0xff);
	bytes2[1] = (byte) ((source >> 8) & 0xff);
}

//将两个byte转换为一个short
inline SInt16 convertshort(byte* bytes) {
	return (bytes[0] << 8) + (bytes[1] & 0xFF);
}