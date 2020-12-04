package pku.shengbin.utils;

import android.os.Environment;

/**
 * 常见的配置常量
 * @author rpts
 *
 */
public class ConstantConfig {

	 public static String mRootDir = "/";
	 public static String[] exts = {".3gp", ".asf", ".avi", ".flv", ".m4v", ".mkv", ".mov", ".mp4", ".mpg", ".mpeg", ".rm", ".rmvb", ".ts", ".wmv", ".mp3", ".wma"};
	 public static String DEFAULT_DIR= Environment.getExternalStorageDirectory().getPath();
	 public static String HIRSTORY_DIR="/.hevplayer/history.txt";
	 public static String RTSP="rtsp://";
	 public static String HTTP="http://";
	 public static String RTP="rtp://";
	 public static String FTP="ftp://";
	 public static String CLEAR="clear";
	 public static String CURRENT_DIR="current_dir";
	 public static String INTENT_FILEPATH="pku.shengbin.hevplayer.strMediaPath";
	 public static String INTENT_MEDIATYPE="pku.shengbin.hevplayer.intMediaType";
	
}
