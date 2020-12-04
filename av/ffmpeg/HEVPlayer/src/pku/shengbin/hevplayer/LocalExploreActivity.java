package pku.shengbin.hevplayer;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import pku.shengbin.hevplayer.LocalExploreActivity;
import pku.shengbin.utils.ConstantConfig;
import pku.shengbin.utils.FileUtils;
import pku.shengbin.utils.MessageBox;
import android.app.AlertDialog;
import android.app.ListActivity;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.DialogInterface.OnClickListener;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.ListView;
import android.widget.TextView;

/**
 * In this activity, the user explores the local file system.
 * When the user clicks a file, it starts a GLPlayerActivity to play the file.
 */
public class LocalExploreActivity extends ListActivity {
	
	private String			mCurrentDir;
	private TextView 		mTextViewLocation;  //currentDir
	private File[]			mFiles;
	private AlertDialog 	mDialog;

    @Override
	protected void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);
		setContentView(R.layout.movie_explorer);
		mTextViewLocation = (TextView) findViewById(R.id.textview_path);
		//记住上一次退出时的位置，使用的是SharePreferenceActivity来实现
		SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(LocalExploreActivity.this);  
		String currentDir = prefs.getString("current_dir", "");
		setDirAdapter(FileUtils.getCurrentDir(this, currentDir));
	}
	/**
	 *  获取到所需要的文件夹及文件名称
	 * @param dirPath
	 */
	private void setDirAdapter(String dirPath) {
		try {
			mTextViewLocation.setText("Location: " + dirPath);
			mFiles=FileUtils.getDirectory(this,dirPath);
			setListAdapter(new LocalExplorerAdapter(this, mFiles, dirPath.equals(ConstantConfig.mRootDir)));

		} catch (Exception ex) {
			MessageBox.show(this, "Sorry", "Get directory failed! Please check your SD card state.");
		}
	}
	/**
	 * 条目点击事件
	 * @param l
	 * @param v
	 * @param position
	 * @param id
	 */
	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		String moviePath = new String();  //movie文件路径
		
		File file = mFiles[position];
		if (file.isDirectory()) {  //是否为文件夹
			if (file.canRead()) {
				setDirAdapter(file.getAbsolutePath());
			}
			else {
				MessageBox.show(this, "Error", "[" + file.getName() + "] folder can't be read!");
				return;
			}
		} else {
			if (!FileUtils.checkExtension(file)) {  //不是视频文件，则提示用户文件类型不正确
				StringBuilder strBuilder = new StringBuilder();
				for (int i = 0; i < ConstantConfig.exts.length; i++)
					strBuilder.append(ConstantConfig.exts[i] + " ");
				MessageBox.show(this, "Sorry", "Only these file extensions are supported:" + strBuilder.toString());
				return;
			}
			moviePath = file.getAbsolutePath();
			startPlayer(moviePath, 0);
		}
	}

	/**
	 *
	 * @param filePath
	 * @param mediaType
	 */
	private void startPlayer(String filePath, int mediaType) {
		GLPlayActivity.startActivity(this, filePath, mediaType);
    }
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {  	
        if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0) {
            // do something on back
        	if (mCurrentDir.equals(ConstantConfig.mRootDir)) {
        		new AlertDialog.Builder(this)
            	.setMessage("The application will exit. Are you sure?")
            	.setPositiveButton("Conform", new OnClickListener() {
            		public void onClick(DialogInterface arg0, int arg1) {
            			// user exits our application, so we may clear the current_dir state
            			SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(LocalExploreActivity.this);  
            			prefs.edit().putString("current_dir", "").commit();
            			finish();
            		}
            		})
            	.setNegativeButton("Cancel", new OnClickListener() {
    				public void onClick(DialogInterface arg0, int arg1) {
    				}
            		})
            	.show();
        	} else {
        		File f = new File(mCurrentDir);
				setDirAdapter(f.getParent());
        	}

            return true;
        }

        return super.onKeyDown(keyCode, event);
    }
    private static final int MENU1 = Menu.FIRST;
    private static final int MENU2 = MENU1 + 1;
    private static final int REQ_SYSTEM_SETTINGS = 0;
    
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);
        // group id, item id, order id(0 stands for adding order)
		menu.add(0, MENU1, 1, "Open Location");
        menu.add(0, MENU2, 2, "Settings");
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
	        case MENU1:  //open Location
	        {
	        	final List<String> history = FileUtils.getHistory();
	        	final AutoCompleteTextView urlEdit = new AutoCompleteTextView(this);
	        	ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,
	                    android.R.layout.simple_dropdown_item_1line, history.toArray(new String[0]));
	        	urlEdit.setAdapter(adapter);
	        	urlEdit.setThreshold(1);  //自动提示数量
	        	urlEdit.setCompletionHint("You can input 'clear' to clear history");
	        	
	        	DialogInterface.OnClickListener ok_listener = new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface arg0, int arg1) {
						String input = urlEdit.getText().toString();
						try {
							if (input.startsWith(ConstantConfig.RTSP) || input.startsWith(ConstantConfig.HTTP)
									|| input.startsWith(ConstantConfig.RTP) || input.startsWith(ConstantConfig.FTP)) {
								File file = new File(ConstantConfig.DEFAULT_DIR+ "/.hevplayer/history.txt");
								if (!file.exists()) {  //存储历史搜索记录
									new File(ConstantConfig.DEFAULT_DIR + "/.hevplayer").mkdir();
									file.createNewFile();
								}
								
								if (!history.contains(input)) {
									FileWriter writer = new FileWriter(file, true);  
									writer.write(input + "\r\n");  
									writer.close();
								}
								else startPlayer(input, 0);
							}
							else if (input.equals(ConstantConfig.CLEAR)) { //清除记录
								File file = new File(ConstantConfig.DEFAULT_DIR+ "/.hevplayer/history.txt");
								FileOutputStream fos = new FileOutputStream(file);
					            fos.write("".getBytes());
					            fos.close();
							}
							else {
								MessageBox.show(LocalExploreActivity.this, "Tip", "Invalid input! Should start with: 'rtsp://', 'http://', 'rtp://', and 'ftp://'.");
							}

						} catch (Exception e) {
							MessageBox.show(LocalExploreActivity.this, "Error", "File operation failed:  " + e.getMessage());
						}
								
					}
	        	};
	        	mDialog = new AlertDialog.Builder(this)
	        	.setTitle("Input location of a movie file to open and play it:")
	        	.setIcon(android.R.drawable.ic_input_get)
	        	.setView(urlEdit)
	        	.setPositiveButton("OK", ok_listener)
	        	.setNegativeButton("Cancel", null)
	        	.show();
	        	
	        	break;
	        }
	        case MENU2:
	        {
				//设置一些属性
	        	startActivityForResult(new Intent(this, SettingsActivity.class), REQ_SYSTEM_SETTINGS);  
	        	break;
	        }
        };
        return super.onOptionsItemSelected(item);
    }
    
    protected  void onActivityResult(int requestCode, int resultCode, Intent data) {  
    	if (requestCode == REQ_SYSTEM_SETTINGS) {   
	    	//restart activity to apply the setting changes
            this.finish();
            startActivity(new Intent(this, this.getClass()));
        }
    }
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mDialog != null) {
            mDialog.dismiss();
            mDialog = null;
        }
    }
     
}
