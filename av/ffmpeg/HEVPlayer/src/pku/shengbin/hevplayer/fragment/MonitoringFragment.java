package pku.shengbin.hevplayer.fragment;

import java.util.ArrayList;
import java.util.List;

import pku.shengbin.hevplayer.GLPlayActivity;
import pku.shengbin.hevplayer.R;
import pku.shengbin.hevplayer.adapter.AreaAdapter;
import pku.shengbin.hevplayer.adapter.BuildingAdapter;
import pku.shengbin.hevplayer.adapter.FloorAdapter;
import pku.shengbin.hevplayer.adapter.MonitorAdapter;
import pku.shengbin.hevplayer.base.entity.AreaManager;
import pku.shengbin.hevplayer.base.entity.BuildingManger;
import pku.shengbin.hevplayer.base.entity.FloorManager;
import pku.shengbin.hevplayer.base.entity.MonitorManager;
import pku.shengbin.hevplayer.bean.Area;
import pku.shengbin.hevplayer.bean.Building;
import pku.shengbin.hevplayer.bean.Floor;
import pku.shengbin.hevplayer.bean.Monitor;
import pku.shengbin.utils.ConstantConfig;
import pku.shengbin.utils.DialogUtils;
import pku.shengbin.utils.MessageBox;
import pku.shengbin.utils.ThreadUtils;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.Dialog;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class MonitoringFragment extends Fragment implements OnClickListener,OnItemClickListener,OnItemLongClickListener{

	private RelativeLayout titleRelative;
	private ImageView addImage;
	private static ListView mLVStructure; //层次结构列表
	private static List<Area> listArea;
	private static List<Building> listBuilding;
	private static List<Floor> listFloor;
	private static List<Monitor> listMonitor;
	private static AreaManager areaManager;
	private static MonitorManager monitorManager;
	private static BuildingManger buildingManager;
	private static FloorManager floorManager;
	private static AreaAdapter areaAdapter;
	private static MonitorAdapter monitorAdapter;
	private static BuildingAdapter buildingAdapter;
	private static FloorAdapter floorAdapter;
	private static int areaId=0;
	private static int floorId=0;
	private static int buildingId=0;
	private static Activity  activity;
	private Dialog deleteDialog;
	private static final int INIT_AREA=1;
	private static final int INIT_BUILDING=2;
	private static final int INIT_FLOOR=3;
	private static final int INIT_MONITOR=4;
	
	private static Handler handle=new Handler(){
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case INIT_AREA:
				areaAdapter =new AreaAdapter(activity,listArea,listMonitor);
				mLVStructure.setAdapter(areaAdapter);
				break;
			case INIT_BUILDING:
				
				break;
			case INIT_FLOOR:
	
				break;
			case INIT_MONITOR:
	
				break;
			}
		};
	};
	
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View view=inflater.inflate(R.layout.monitoring_fragment, null);
		initTitle(view);
		return view;
	}
	
	private void initTitle(View view){
		titleRelative = (RelativeLayout) view.findViewById(R.id.title);
		TextView titleTextView = (TextView) titleRelative.findViewById(R.id.title_text);
		titleTextView.setText(getResources().getString(R.string.monitoring));
		addImage =(ImageView) titleRelative.findViewById(R.id.image_add);
		addImage.setOnClickListener(this);
		init(view);
	}
	 
	private void init(View view) {
		activity=getActivity();
		mLVStructure=(ListView) view.findViewById(R.id.list_structure);
		TextView emptyTextView = (TextView) view.findViewById(R.id.noSmsData);
		mLVStructure.setEmptyView(emptyTextView);
		listArea=new ArrayList<Area>();
		listBuilding =new ArrayList<Building>();
		listFloor =new ArrayList<Floor>();
		listMonitor = new ArrayList<Monitor>();
		areaManager=AreaManager.getInstance(getActivity());
		monitorManager=MonitorManager.getInstance(getActivity());
		buildingManager =BuildingManger.getInstance(getActivity());
		floorManager = FloorManager.getInstance(getActivity());
		initData();
		mLVStructure.setOnItemClickListener(this);
		mLVStructure.setOnItemLongClickListener(this);
	}

	private void initData(){
		ThreadUtils.getInstance().execu(new Thread(){
			@Override
			public void run() {
				// TODO Auto-generated method stub
				super.run();
				listArea = areaManager.query();
				listMonitor = monitorManager.query();
				handle.sendEmptyMessage(INIT_AREA);
			}
		});
	}
	
	private static void initAreaList() {
		//TODO  获取数据库数据
		areaId=0;
		listArea = areaManager.query();
		listMonitor = monitorManager.query();
		areaAdapter =new AreaAdapter(activity,listArea,listMonitor);
		mLVStructure.setAdapter(areaAdapter);
	}
	
	private static void onAreaRefresh(){
		initAreaList();
		areaAdapter.setData(listArea);
		areaAdapter.setDataMonitor(listMonitor);
		areaAdapter.notifyDataSetChanged();
	}
	
	private static void initBuildingList(){
		buildingId=0;
		listBuilding = buildingManager.query(areaId);
		listMonitor = monitorManager.query(areaId+"");
		buildingAdapter = new BuildingAdapter(activity,listBuilding,listMonitor);
		mLVStructure.setAdapter(buildingAdapter);
	}
	
	private static void onBuildingRefresh() {
		initBuildingList();
		buildingAdapter.setData(listBuilding);
		buildingAdapter.setDataMonitor(listMonitor);
		buildingAdapter.notifyDataSetChanged();
	}
	
	private static void initFloorsList(){
		floorId =0;
		listFloor =floorManager.query(areaId, buildingId);
		listMonitor =monitorManager.query(areaId+"", buildingId+"");
		floorAdapter=new FloorAdapter(activity, listFloor,listMonitor);
		mLVStructure.setAdapter(floorAdapter);
	}
	
	private static void onFloorRefresh(){
		initFloorsList();
		floorAdapter.setData(listFloor);
		floorAdapter.setDataMonitor(listMonitor);
		floorAdapter.notifyDataSetChanged();
	}
	
	private static void initMonitorList(){
		listMonitor = monitorManager.query(areaId+"", buildingId+"", floorId+"");
		monitorAdapter =new MonitorAdapter(activity,listMonitor);
		mLVStructure.setAdapter(monitorAdapter);
	}
	
	private static void onMonitorRefresh(){
		initMonitorList();
		monitorAdapter.setData(listMonitor);
		monitorAdapter.notifyDataSetChanged();
	}
	
	@Override
	public void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
	}
	
	
	@Override
	public void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		
		mLVStructure=null;
		
		listArea=null;
		areaManager=null;
		areaAdapter=null;
		areaId=0;
		
		listMonitor=null;
		monitorManager=null;
		monitorAdapter =null;
		
		floorId=0;
		listFloor=null;
		floorAdapter =null;
		floorManager =null;
		
		buildingId=0;
		buildingManager=null;
		listBuilding=null;
		buildingAdapter=null;
		
		activity=null;
	}

	@Override
	public void onClick(View view) {
		switch(view.getId()){
			case R.id.image_add:
				if(DialogUtils.popupIsShow()){
					DialogUtils.popupClose();
				}else{
					showPopupWindow();
				}	
				break;
			case R.id.text_add_1:
				//添加结构
				if(DialogUtils.popupIsShow()){
					DialogUtils.popupClose();
				}
				View dialogView =LayoutInflater.from(getActivity()).inflate(R.layout.monitor_add_dialog, null);
				final Dialog dialog=DialogUtils.showEditAdd(getActivity(), dialogView);
				final EditText edit=(EditText) dialogView.findViewById(R.id.eidt);
				Button cancel =(Button) dialogView.findViewById(R.id.cancel);
				Button confirm = (Button) dialogView.findViewById(R.id.confirm);
				dialog.show();
				
				cancel.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						// TODO Auto-generated method  stub
						if(dialog!=null){
							dialog.dismiss();
						}
					}
				});
				confirm.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						//TODO  添加区域数据
						String name=edit.getText().toString();
						if(areaId==0){
							//添加区域	
							areaManager.insert(name);
							onAreaRefresh();
						}else if(buildingId==0){
							//添加building层
							buildingManager.insert(name, areaId);
							onBuildingRefresh();
						}else if(floorId==0){
							//添加floor层
							floorManager.insert(name, areaId, buildingId);
							onFloorRefresh();
						}
						if(dialog!=null){
							dialog.dismiss();
						}
					}
				});
				break;
			case R.id.text_add_2:
				if(DialogUtils.popupIsShow()){
					DialogUtils.popupClose();
				}
				View dialogViewUrl =LayoutInflater.from(getActivity()).inflate(R.layout.monitor_add_monitor_dialog, null);
				final Dialog dialogMonitor=DialogUtils.showEditAdd(getActivity(), dialogViewUrl);
				final EditText editName=(EditText) dialogViewUrl.findViewById(R.id.eidt);
				final EditText editUrl=(EditText) dialogViewUrl.findViewById(R.id.edit_url);
				Button cancelMonitor =(Button) dialogViewUrl.findViewById(R.id.cancel);
				Button confirmMonitor = (Button) dialogViewUrl.findViewById(R.id.confirm);
				dialogMonitor.show();
				
				cancelMonitor.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						// TODO Auto-generated method stub
						if(dialogMonitor!=null){
							dialogMonitor.dismiss();
						}
					}
				});
				confirmMonitor.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						String name =editName.getText().toString();
						String url=editUrl.getText().toString();
						
						if(url.startsWith(ConstantConfig.RTSP)||url.startsWith(ConstantConfig.HTTP)
								|| url.startsWith(ConstantConfig.RTP) || url.startsWith(ConstantConfig.FTP)){
							//TODO 添加数据
							if(areaId==0){
								//说明是第一阶段
								monitorManager.insert(name, url);
								onAreaRefresh();	
							}else if(buildingId==0){
								//第二阶段的数据
								monitorManager.insert(name, url,areaId+"");
								onBuildingRefresh();
							}else if(floorId==0){
								//第三阶段的数据
								monitorManager.insert(name,url,areaId+"",buildingId+"");
								onFloorRefresh();
							}else{
								//楼层下的id
								monitorManager.insert(name, url,areaId+"",buildingId+"",floorId+"");
								onMonitorRefresh();
							}
							if(dialogMonitor!=null){
								dialogMonitor.dismiss();
							}
						}else{
							if(dialogMonitor!=null){
								dialogMonitor.dismiss();
							}
							MessageBox.show(getActivity(), getActivity().getResources().getString(R.string.prompt), getActivity().getResources().getString(R.string.start_with)+"'rtsp://', 'http://', 'rtp://', and 'ftp://'.");
						}
					}
				});
				break;
		}
	}
	
	@SuppressLint("NewApi") 
	private void showPopupWindow(){
		
		View contentView= LayoutInflater.from(getActivity()).inflate(R.layout.popup_monitor_add, null);
		DialogUtils.popupWindowShow(getActivity(), addImage, contentView);
		TextView addTextView1=(TextView) contentView.findViewById(R.id.text_add_1);
		TextView addTextView2=(TextView) contentView.findViewById(R.id.text_add_2);
		addTextView1.setOnClickListener(this);
		addTextView2.setOnClickListener(this);
		if(floorId!=0&&addTextView1.isClickable()){
			addTextView1.setClickable(false);
			addTextView1.setTextColor(Color.GRAY);
		}else if(!addTextView1.isClickable()){
			addTextView1.setClickable(true);
			addTextView1.setTextColor(Color.BLACK);
		}
	}
	
	public static boolean goBack(){
		
		if(floorId!=0){
			mLVStructure.setAdapter(null);
			floorId =0;
			initFloorsList();
			return true;
		}else if(buildingId!=0){
			mLVStructure.setAdapter(null);
			buildingId =0;
			initBuildingList();
			return true;
		}else if(areaId!=0){
			mLVStructure.setAdapter(null);
			areaId=0;
			initAreaList();
			return true;
		}else{
			return false;
		}		
	}
	
	private void startPlayer(String url,int mediaType){
		GLPlayActivity.startActivity(getActivity(), url, mediaType);
	}
	
	@Override
	public void onItemClick(AdapterView<?> parent, View view, int position,
			long id) {
		if(areaId==0){
			//区域层
			if(position>=listArea.size()){
				String url =listMonitor.get(position-listArea.size()).getUrl();
				startPlayer(url,0);
			}else{
				//跳转到building层次
				areaId = listArea.get(position).getId();
				mLVStructure.setAdapter(null);
				initBuildingList();
			}
		}else if(buildingId==0){
			if(position>=listBuilding.size()){
				String url =listMonitor.get(position-listBuilding.size()).getUrl();
				startPlayer(url,0);
			}else{
				buildingId = listBuilding.get(position).getId();
				mLVStructure.setAdapter(null);
				initFloorsList();
			}
			//building层
		}else if(floorId==0){
			//floorId层
			if(position>=listFloor.size()){
				String url =listMonitor.get(position-listFloor.size()).getUrl();
				startPlayer(url,0);
			}else{
				floorId =listFloor.get(position).getId();
				mLVStructure.setAdapter(null);
				initMonitorList();
			}
		}else{
			String url =listMonitor.get(position).getUrl();
			startPlayer(url,0);
		}
	}

	@Override
	public boolean onItemLongClick(AdapterView<?> parent, View view,
			int position, long id) {
		//popupWindow显示
		longClickDialog(position);
		return true;
	}
	
	private void longClickDialog (final int position){  //showCenterDialog
		View contentView= LayoutInflater.from(getActivity()).inflate(R.layout.long_click_view, null);
		deleteDialog=DialogUtils.showCenterDialog(getActivity(), contentView);
		TextView textDelete =(TextView) contentView.findViewById(R.id.text_delete);
		TextView textUpdate = (TextView) contentView.findViewById(R.id.text_update);
		textDelete.setOnClickListener(new OnClickListener() {  //删除
			
			@Override
			public void onClick(View v) {
				if(areaId==0){
					if(position>=listArea.size()){
						monitorManager.delete(listMonitor.get(position-listArea.size()).getId()+"");
					}else{
						//说明是区域
						areaManager.delete(listArea.get(position).getId());
					}
					onAreaRefresh();
				}else if(buildingId==0){
					if(position>=listBuilding.size()){
						//说明是监视器
						monitorManager.delete(listMonitor.get(position-listBuilding.size()).getId()+"");
					}else{
						//说明是区域
						buildingManager.delete(areaId,listBuilding.get(position).getId());
					}
					onBuildingRefresh();
				}else if(floorId==0){
					if(position>=listFloor.size()){
						//说明是监视器
						monitorManager.delete(listMonitor.get(position-listFloor.size()).getId()+"");
					}else{
						//说明是区域
						floorManager.delete(areaId,buildingId,listFloor.get(position).getId());
					}
					onFloorRefresh();
				}else{
					//监视器
					monitorManager.delete(listMonitor.get(position).getId()+"");
					onMonitorRefresh();
				}
				
				if(deleteDialog!=null&&deleteDialog.isShowing()){
					deleteDialog.dismiss();
				}
			}
		});
		textUpdate.setOnClickListener(new OnClickListener() {  //更新数据
			
			@Override
			public void onClick(View v) {
				if(deleteDialog!=null&&deleteDialog.isShowing()){
					deleteDialog.dismiss();
				}
				if(areaId==0){
					//更改area 层
					if(position>=listArea.size()){
						showMonitorUpdate(position-listArea.size());
					}else{
						showOtherUpdate(position);
					}
				}else if(buildingId==0){
					if(position>=listBuilding.size()){
						showMonitorUpdate(position-listBuilding.size());
					}else{
						showOtherUpdate(position);
					}
				}else if(floorId==0){
					if(position>listFloor.size()){
						showMonitorUpdate(position-listFloor.size());
					}else{
						showOtherUpdate(position);
					}
				}else{
					showMonitorUpdate(position);
				}
			}
		});
	}
	
	private void showMonitorUpdate(final int position){
		
		View dialogViewUrl =LayoutInflater.from(getActivity()).inflate(R.layout.monitor_add_monitor_dialog, null);
		final Dialog dialogMonitor=DialogUtils.showEditAdd(getActivity(), dialogViewUrl);
		final EditText editName=(EditText) dialogViewUrl.findViewById(R.id.eidt);
		final EditText editUrl=(EditText) dialogViewUrl.findViewById(R.id.edit_url);
		Button cancelMonitor =(Button) dialogViewUrl.findViewById(R.id.cancel);
		Button confirmMonitor = (Button) dialogViewUrl.findViewById(R.id.confirm);
		dialogMonitor.show();
		cancelMonitor.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				if(dialogMonitor!=null){
					dialogMonitor.dismiss();
				}
			}
		});
		confirmMonitor.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				String name =editName.getText().toString();
				String url=editUrl.getText().toString();
				
				if(url.startsWith(ConstantConfig.RTSP)||url.startsWith(ConstantConfig.HTTP)
						|| url.startsWith(ConstantConfig.RTP) || url.startsWith(ConstantConfig.FTP)){
					//TODO 更改数据
					monitorManager.update(name, url, listMonitor.get(position).getId()+"");
					if(areaId==0){
						onAreaRefresh();
					}else if(buildingId==0){
						onBuildingRefresh();
					}else if(floorId==0){
						onFloorRefresh();
					}else{
						onMonitorRefresh();
					}
					if(dialogMonitor!=null){
						dialogMonitor.dismiss();
					}
				}else{
					if(dialogMonitor!=null){
						dialogMonitor.dismiss();
					}
					MessageBox.show(getActivity(), getActivity().getResources().getString(R.string.prompt), getActivity().getResources().getString(R.string.start_with)+"'rtsp://', 'http://', 'rtp://', and 'ftp://'.");
				}
			}
		});
	}
	
	private void showOtherUpdate(final int position){
		View dialogView =LayoutInflater.from(getActivity()).inflate(R.layout.monitor_add_dialog, null);
		final Dialog dialog=DialogUtils.showEditAdd(getActivity(), dialogView);
		final EditText edit=(EditText) dialogView.findViewById(R.id.eidt);
		Button cancel =(Button) dialogView.findViewById(R.id.cancel);
		Button confirm = (Button) dialogView.findViewById(R.id.confirm);
		dialog.show();
		
		cancel.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method  stub
				if(dialog!=null){
					dialog.dismiss();
				}
			}
		});
		confirm.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				//TODO  更改数据
				String name=edit.getText().toString();
				if(areaId==0){
					areaManager.update(name, listArea.get(position).getId());
					onAreaRefresh();
				}else if(buildingId==0){
					buildingManager.update(name, listBuilding.get(position).getId());
					onBuildingRefresh();
				}else if(floorId==0){
					floorManager.update(name, listFloor.get(position).getId());
					onFloorRefresh();
				}
				if(dialog!=null){
					dialog.dismiss();
				}
			}
		});
	}

}
