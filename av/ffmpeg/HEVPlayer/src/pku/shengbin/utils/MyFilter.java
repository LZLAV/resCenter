package pku.shengbin.utils;

import java.io.File;
import java.io.FileFilter;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

public class MyFilter implements FileFilter{
	
	 private Context context;
	 private SharedPreferences settings;
	 private boolean showHidden;
	 private boolean showMediaOnly;

	 public MyFilter(Context context){
	     this.context=context;
	     settings = PreferenceManager.getDefaultSharedPreferences(context);
	     showHidden = settings.getBoolean("show_hidden_switch", false);  //隐藏文件夹是否可查看
	     showMediaOnly = settings.getBoolean("only_media_switch", false);  //是否只查看media类型文件
	 }
	 @Override
	 public boolean accept(File pathname) {
	     if (!showHidden && pathname.getName().startsWith("."))
	         return false;
	     else if (pathname.isDirectory())
	         return true;
	     else if (showMediaOnly && !FileUtils.isMedia(pathname.getName()))
	         return false;
	     else
	         return true;
	 }
	
}
