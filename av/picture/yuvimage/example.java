 /**
	* 把一帧yuv数据保存为bitmap
	* @param yuv 数据流
	* @param mWidth 图片的宽
	* @param mHeight 图片的高
	* @return bitmap 对象
	*
	*/
	public Bitmap saveYUV2Bitmap(byte[] yuv, int mWidth, int mHeight) {
		YuvImage image = new YuvImage(yuv, ImageFormat.NV21, mWidth, mHeight, null);
		ByteArrayOutputStream stream = new ByteArrayOutputStream();
		image.compressToJpeg(new Rect(0, 0, mWidth, mHeight), 100, stream);
		Bitmap bmp = BitmapFactory.decodeByteArray(stream.toByteArray(), 0, stream.size());
		try {
			stream.flush();
			stream.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
			return bmp;
	}