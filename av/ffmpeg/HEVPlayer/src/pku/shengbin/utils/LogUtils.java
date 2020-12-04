package pku.shengbin.utils;

import android.util.Log;

/**
 * ¿ØÖÆLogµÄÊä³ö
 * @author rpts
 *
 */
public class LogUtils {
	
	private static final int LOG_LEVEL=0;
	private static final int LOG_V=1;
	private static final int LOG_D=2;
	private static final int LOG_I=3;
	private static final int LOG_W=4;
	private static final int LOG_E=5;
	
	public static void v(String tag,String msg){
		if(LOG_LEVEL<LOG_V){
			Log.v(tag,msg);
		}else{
			return;
		}
	}
	
	public static void d(String tag,String msg){
		if(LOG_LEVEL<LOG_D){
			Log.d(tag,msg);
		}else{
			return;
		}
	}
	
	public static void i(String tag,String msg){
		if(LOG_LEVEL<LOG_I){
			Log.i(tag,msg);
		}else{
			return;
		}
	}
	
	public static void w(String tag,String msg){
		if(LOG_LEVEL<LOG_W){
			Log.w(tag,msg);
		}else{
			return;
		}
	}
	
	public static void e(String tag,String msg){
		if(LOG_LEVEL<LOG_E){
			Log.e(tag,msg);
		}else{
			return;
		}
	}
}
