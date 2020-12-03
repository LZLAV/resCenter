package pku.shengbin.hevplayer.fragment;

import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.util.List;

import pku.shengbin.hevplayer.GLPlayActivity;
import pku.shengbin.hevplayer.LocalExplorerAdapter;
import pku.shengbin.hevplayer.R;
import pku.shengbin.hevplayer.bean.Data;
import pku.shengbin.utils.ConstantConfig;
import pku.shengbin.utils.FileUtils;
import pku.shengbin.utils.MessageBox;
import pku.shengbin.utils.ThreadUtils;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.preference.PreferenceManager;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class VideoFragment extends Fragment implements OnItemClickListener,OnClickListener{

	private static String			mCurrentDir="";
	private static TextView 		mTextViewLocation;  //currentDir
	private static File[]			mFiles;
	private AlertDialog 			mDialog;
	private static ListView        mListView;
	private ImageView 		openLocation;
	private static Context context;
	
	private static final int INIT_DATA=1;
	
	private static Handler handle =new Handler(){
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case INIT_DATA:
				Data data =(Data) msg.obj;
				mFiles=data.getFiles();
				String dirPath = data.getDirPath();
				mListView.setAdapter(new LocalExplorerAdapter(context,mFiles,dirPath.equals(ConstantConfig.mRootDir)));
				break;
			}
		};
	};
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View view=inflater.inflate(R.layout.movie_explorer, null);
		initTitle(view);
		return view;
	}
	

	private void initTitle(View view) {
		RelativeLayout titleRelative=(RelativeLayout) view.findViewById(R.id.title);
		TextView titleTextView =(TextView) titleRelative.findViewById(R.id.title_text);
		titleTextView.setText(getResources().getString(R.string.video));
//		titleTextView.setTextSize(20);
		openLocation = (ImageView) titleRelative.findViewById(R.id.image_add);
		openLocation.setOnClickListener(this);
		init(view);
	}
	
	private void init(View view){
		mTextViewLocation = (TextView) view.findViewById(R.id.textview_path);
		mListView = (ListView) view.findViewById(R.id.list_path);
		context =getActivity();
		//记住上一次退出时的位置
		SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getActivity().getApplicationContext());
		String currentDir = prefs.getString(ConstantConfig.CURRENT_DIR, "");
		Log.e(ConstantConfig.CURRENT_DIR,currentDir);
		//设置Adapter
		setDirAdapter(FileUtils.getCurrentDir(getActivity(), currentDir));
		mListView.setOnItemClickListener(this);
	}
	
	private static void setDirAdapter(final String dirPath){
		try{
			mTextViewLocation.setText(context.getResources().getString(R.string.location)+dirPath);
			mCurrentDir=dirPath;
			SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(context.getApplicationContext());  
			prefs.edit().putString(ConstantConfig.CURRENT_DIR, dirPath).commit();
			ThreadUtils.getInstance().execu(new Thread(){
				@Override
				public void run() {
					// TODO Auto-generated method stub
					super.run();
					File[] files = FileUtils.getDirectory(context, dirPath);
					Message msg=Message.obtain();
					Data data=new Data();
					data.setFiles(files);
					data.setDirPath(dirPath);
					msg.what =INIT_DATA;
					msg.obj =data;
					handle.sendMessage(msg);
				}
			});
			
		}catch(Exception e){
			MessageBox.show(context,context.getResources().getString(R.string.prompt), context.getResources().getString(R.string.prompt_content));
		}	
	}


	@Override
	public void onItemClick(AdapterView<?> arg0, View view, int position, long id) {
		String moviePath =new String();
		//movie文件路径
		File file=mFiles[position];
		if(file.isDirectory()){  //是否为文件夹
			if(file.canRead()){  //是否可读
				setDirAdapter(file.getAbsolutePath());
			}else{
				MessageBox.show(getActivity(), context.getResources().getString(R.string.error), "[" + file.getName() + "] "+context.getResources().getString(R.string.no_read));
				return;
			}
		}else{
			if(!FileUtils.checkExtension(file)){
				//不是视频文件，则提示用户文件类型不正确
				StringBuilder strBuilder =new StringBuilder();
				for(int i=0;i<ConstantConfig.exts.length;i++){
					strBuilder.append(ConstantConfig.exts[i]+" ");
				}
				MessageBox.show(getActivity(),  context.getResources().getString(R.string.prompt), context.getResources().getString(R.string.only_support_extend) + strBuilder.toString());
				return;
			}
			moviePath = file.getAbsolutePath();
			startPlayer(moviePath,0);
		}
	}


	private void startPlayer(String moviePath, int mediaType) {
		GLPlayActivity.startActivity(getActivity(), moviePath, mediaType);
	}


	@Override
	public void onClick(View view) {
		switch(view.getId()){
			case R.id.image_add:  //openLocation
				openLocation();
				break;
		}
	}
	
	private void openLocation(){

		final List<String> history=FileUtils.getHistory();
		final AutoCompleteTextView urlEdit=new AutoCompleteTextView(getActivity());
		ArrayAdapter<String> adapter=new ArrayAdapter<String>(getActivity(),android.R.layout.simple_dropdown_item_1line,history.toArray(new String[0]));
		urlEdit.setAdapter(adapter);
		//自动提示数量
		urlEdit.setThreshold(1);
		urlEdit.setCompletionHint(context.getResources().getString(R.string.clear_history));
		
		DialogInterface.OnClickListener ok_listener=new DialogInterface.OnClickListener(){

			@Override
			public void onClick(DialogInterface arg0, int arg1) {
				
				String input =urlEdit.getText().toString();
				try{
					if(input.startsWith(ConstantConfig.RTSP)||input.startsWith(ConstantConfig.HTTP)
							|| input.startsWith(ConstantConfig.RTP) || input.startsWith(ConstantConfig.FTP)){
						File file=new File(ConstantConfig.DEFAULT_DIR+ConstantConfig.HIRSTORY_DIR);
						if(!file.exists()){
							//存储历史搜索记录
							new File(ConstantConfig.DEFAULT_DIR+"/.hevplayer").mkdir();  //创建文件夹
							file.createNewFile();
						}
						if(!history.contains(input)){
							FileWriter writer=new FileWriter(file,true);
							writer.write(input+"\r\n");
							writer.close();
						}else{
							startPlayer(input,0);
						}
					}else if(input.equals(ConstantConfig.CLEAR)){
						//清楚记录
						File file = new File(ConstantConfig.DEFAULT_DIR+ "/.hevplayer/history.txt");
						FileOutputStream fos = new FileOutputStream(file);
			            fos.write("".getBytes());
			            fos.close();
					}else{
						MessageBox.show(getActivity(), context.getResources().getString(R.string.prompt), context.getResources().getString(R.string.start_with)+"'rtsp://', 'http://', 'rtp://', and 'ftp://'.");
					}
				}catch(Exception e){
					MessageBox.show(getActivity(), context.getResources().getString(R.string.error), context.getResources().getString(R.string.file_operator_failed) + e.getMessage());
				}
				
			}};
			
			mDialog =new AlertDialog.Builder(getActivity()).setTitle(context.getResources().getString(R.string.input_movie_hint))
					.setIcon(android.R.drawable.ic_input_get)
					.setView(urlEdit)
		        	.setPositiveButton(context.getResources().getString(R.string.confirm), ok_listener)
		        	.setNegativeButton(context.getResources().getString(R.string.cancel), null)
		        	.show();
	}
	
	//处理返回事件
	public static boolean goBack(){
		if(mCurrentDir.equals(ConstantConfig.mRootDir)){
			SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(context);  
			prefs.edit().putString(ConstantConfig.CURRENT_DIR, ConstantConfig.mRootDir).commit();
			return false;
		}else{
			File f=new File(mCurrentDir);
			setDirAdapter(f.getParent());
			return true;
		}
	}
	
	@Override
	public void onDestroy() {
		if(mCurrentDir!=null){
			mCurrentDir=null;
		}
		if(mTextViewLocation!=null){
			mTextViewLocation=null;
		}
		if(mFiles!=null){
			mFiles=null;
		}
		if(mListView!=null){
			mListView=null;
		}
		if(context!=null){
			context=null;
		}
		super.onDestroy();
	}
}
