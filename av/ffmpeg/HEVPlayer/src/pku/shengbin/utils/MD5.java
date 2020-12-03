package pku.shengbin.utils;   

import java.security.MessageDigest;

/**
 * Utility class which computes MD5 value of a String.
 */
public class MD5 {   
//	public final static String compute(String s) {   
//		char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',   
//				'a', 'b', 'c', 'd', 'e', 'f' };   
//		try {   
//			byte[] strTemp = s.getBytes();   
//			MessageDigest mdTemp = MessageDigest.getInstance("MD5");   
//			mdTemp.update(strTemp);   
//			byte[] md = mdTemp.digest();   
//			int j = md.length;   
//			char str[] = new char[j * 2];   
//			int k = 0;   
//			for (int i = 0; i < j; i++) {   
//				byte byte0 = md[i];   
//				str[k++] = hexDigits[byte0 >>> 4 & 0xf];   
//				str[k++] = hexDigits[byte0 & 0xf];   
//			}   
//			return new String(str);   
//		} catch (Exception e) {   
//			return null;   
//		}   
//	}  
	
	/**
	 * 对字符串使用MD5进行加密后返回字符串
	 * @param s
	 * @return
	 */
	public final static String compute(String s) {

		try {   
			byte[] strTemp = s.getBytes();   
			MessageDigest mdTemp = MessageDigest.getInstance("MD5");   
			mdTemp.update(strTemp);   
			byte[] md = mdTemp.digest();
			return byteToHex(md);
		} catch (Exception e) {   
			return null;   
		}   
	}

	/**
	 * 将字节数组转换成字符串
	 * @param byteArray
	 * @return
	 */
	public static String byteToHex(byte[] byteArray){
		char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
				'a', 'b', 'c', 'd', 'e', 'f' };
		//一个byte是八位二进制，两位16进制字符
		char[] md=new char[byteArray.length*2];
		int k=0;
		for(int i=0;i<byteArray.length;i++){
			byte byte0 = byteArray[i];
			md[k++]= hexDigits[byte0 >>> 4 & 0xf]; //高四位
			md[k++] = hexDigits[byte0 & 0xf];   //低四位
		}
		return new String(md);
	}
}  