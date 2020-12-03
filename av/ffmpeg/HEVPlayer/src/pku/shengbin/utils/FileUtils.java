package pku.shengbin.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.util.Log;

public class FileUtils {

	/**
     * 文件排序，文件夹大于文件
     * @param files
     */
    public static void sortFiles(File[] files) {
        Arrays.sort(files, new Comparator<File>() {
            public int compare(File f1, File f2) {
                if (f1.isDirectory() && f2.isFile())
                    return -1;
                else if (f2.isDirectory() && f1.isFile())
                    return 1;
                else return f1.getName().compareToIgnoreCase(f2.getName());
            }
        });
    }

    /**
     * 检查扩展名
     * @param file
     * @return
     */
    public static boolean checkExtension(File file) {
        for (int i = 0; i < ConstantConfig.exts.length; i++) {
            if (file.getName().indexOf(ConstantConfig.exts[i]) > 0) {
                return true;
            }
        }
        return false;
    }


    /**
     *  获取到所需要的文件夹及文件名称
     * @param dirPath
     */
    public static  File[] getDirectory(final Context context,String dirPath) {
        String mCurrentDir=null;
        try {
            mCurrentDir = dirPath;
            SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(context);
            prefs.edit().putString("current_dir", mCurrentDir).commit();
            //文件过滤
            File f = new File(dirPath);
            File[] temp = f.listFiles(new MyFilter(context));  //过滤之后得到的文件及文件夹
            //对获取到的文件夹进行排序
            sortFiles(temp);
            File[] files = null;
            //判断是否为根目录，是则没有 Parent file,否则就要有parent file
            if (!dirPath.equals(ConstantConfig.mRootDir)) {
                files = new File[temp.length + 1];
                System.arraycopy(temp, 0, files, 1, temp.length);
                files[0] = new File(f.getParent());
            } else {
                files = temp;
            }
            return files;

        } catch (Exception ex) {
            MessageBox.show(context, "Sorry", "Get directory failed! Please check your SD card state.");
            return null;
        }
    }

//    /**
//     * 文件过滤操作
//     */
//    static class MyFilter implements FileFilter {
//        private Context context;
//
//        public MyFilter(Context context){
//            this.context=context;
//        }
//        // android maintains the preferences for us, so use directly
//        SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(context);
//        boolean showHidden = settings.getBoolean("show_hidden_switch", false);  //隐藏文件夹是否可查看
//        boolean showMediaOnly = settings.getBoolean("only_media_switch", false);  //是否只查看media类型文件
//        //判断是否是media
//        //文件过滤的方法
//        public boolean accept(File file) {
//            if (!showHidden && file.getName().startsWith("."))
//                return false;
//            else if (file.isDirectory())
//                return true;
//            else if (showMediaOnly && !isMedia(file.getName()))
//                return false;
//            else
//                return true;
//        }
//    }

    /**
     * 判断是否为media
     * @param name
     * @return
     */
    public static boolean isMedia(String name) {
        for (int i = 0; i < ConstantConfig.exts.length; i++) {
            if (name.endsWith(ConstantConfig.exts[i]))
                return true;
        }
        return false;
    }

    public static String getCurrentDir(Context context,String currentDir){

        if (currentDir.isEmpty()) {
            currentDir = ConstantConfig.mRootDir;
            try {
                String state = Environment.getExternalStorageState();
                //只读并且是大容量
                if (state.equals(Environment.MEDIA_MOUNTED) || state.equals(Environment.MEDIA_MOUNTED_READ_ONLY)) {
                    currentDir = Environment.getExternalStorageDirectory().getPath();
                }
            } catch (Exception ex) {
                MessageBox.show(context, "Sorry", "Get sdcard directory failed! Please check your SD card state.");
            }
        }
        return currentDir;
    }

    /**
     *
     * @return
     */
    public static List<String> getHistory(){

        List<String> history = new ArrayList<String>();
        try {
            File file = new File(ConstantConfig.DEFAULT_DIR + "/.hevplayer/history.txt");
            if (file.exists()) {
                BufferedReader reader = new BufferedReader(new FileReader(file));
                String temp = null;
                while((temp = reader.readLine()) != null)
                    history.add(temp);
                reader.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        history.add(ConstantConfig.CLEAR);
        return history;
    }
	
}
