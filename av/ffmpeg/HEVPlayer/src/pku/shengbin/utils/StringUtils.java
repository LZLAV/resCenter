package pku.shengbin.utils;

public class StringUtils {

	public static boolean isEmpty(String str){
		if(str==null||str.length()==0||str.equals("")){
			return true;
		}
		return false;
	}
	
}
