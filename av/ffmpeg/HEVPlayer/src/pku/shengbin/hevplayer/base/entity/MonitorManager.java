package pku.shengbin.hevplayer.base.entity;

import java.util.ArrayList;
import java.util.List;

import pku.shengbin.hevplayer.base.DBManager;
import pku.shengbin.hevplayer.base.DBUtils;
import pku.shengbin.hevplayer.base.DatabaseOpenHelper;
import pku.shengbin.hevplayer.bean.Monitor;
import pku.shengbin.utils.LogUtils;
import pku.shengbin.utils.StringUtils;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.widget.Toast;

public class MonitorManager {

	private static DatabaseOpenHelper helper;
	private static DBManager dbManager;
	private static MonitorManager monitorManager;
	private SQLiteDatabase db;
	private Context context;
	private static String TAG="MonitorManager";
	
	
	public static MonitorManager getInstance(Context context){
		helper=DatabaseOpenHelper.getInstance(context);
		dbManager = DBManager.getInstance(context);
		if(monitorManager==null){
			monitorManager=new MonitorManager(context);
		}
		return monitorManager;
	}
	
	private MonitorManager(Context context){
		this.context = context;
		db=helper.getWritableDatabase();
	}
	
	
	public boolean isOpen(){
		if(db!=null&&db.isOpen()){
			return true;
		}
		return false;
	}
	
	public void open(){
		db = helper.getWritableDatabase();
	}
	
	public List<Monitor> query(){
		return query(0+"",0+"",0+"");
	}
	
	public List<Monitor> query(String areaId){
		return query(areaId,0+"",0+"");
	}
	
	public List<Monitor> query(String areaId,String buildingId){
		return query(areaId,buildingId,0+"");
	}
	
	public List<Monitor> query(String areaId,String buildingId,String floorId){
		if(!isOpen()){
			open();
		}
		List<Monitor> list= new ArrayList<Monitor>();
		try{
			String selection="areaId=? and buildingId=? and floorId=?";
			String[] selectionArgs=new String[]{areaId,buildingId,floorId};
			Cursor cursor = DBManager.query(db, DBUtils.TABLE_NAME_4,null, selection, selectionArgs, null, null, null);
			list =cursorToList(cursor);
			DBManager.close(db);
		}catch(Exception e){
			if(isOpen()){
				DBManager.close(db);
			}
			LogUtils.e(TAG,"查询数据失败!");
		}
		
		return list;
	}
	
	private List<Monitor> cursorToList(Cursor cursor){
		List<Monitor> list=new ArrayList<Monitor>();
		Monitor monitor;
		if(cursor!=null){
			while(cursor.moveToNext()){
				int index =cursor.getColumnIndex(DBUtils.MONITOR_ID);
				int id=cursor.getInt(index);
				String name=cursor.getString(cursor.getColumnIndex(DBUtils.MONITOR_NAME));
				String areaId = cursor.getString(cursor.getColumnIndex(DBUtils.MONITOR_FLOOR_AREA_ID));
				String buildingId =cursor.getString(cursor.getColumnIndex(DBUtils.MONITOR_FLLOR_BUILDING_ID));
				String floorId =cursor.getString(cursor.getColumnIndex(DBUtils.MONITOR_FLOOR_ID));
				String url=cursor.getString(cursor.getColumnIndex(DBUtils.MONITOR_URL));
				monitor=new Monitor();
				monitor.setId(id);
				monitor.setName(name);
				monitor.setAreaId(areaId);
				monitor.setBuildingId(buildingId);
				monitor.setFloorId(floorId);
				monitor.setUrl(url);
				list.add(monitor);
			}
		}
		return list;
	}
	
	public void insert(String name,String url){
		insert(name,url,0+"",0+"",0+"");
	} 
	
	public void insert(String name,String url,String areaId){
		insert(name,url,areaId,0+"",0+"");
	}
	
	public void insert(String name,String url,String areaId,String buildingId){
		insert(name,url,areaId,buildingId,0+"");
	}
	
	public void insert(String name,String url,String areaId,String buildingId,String floorId){
		if(StringUtils.isEmpty(name)||StringUtils.isEmpty(url)){
			Toast.makeText(context, "名字和链接都不能为空",Toast.LENGTH_SHORT).show();
			if(isOpen()){
				DBManager.close(db);
			}
			return;
		}else{
			
			if(!isOpen()){
				open();
			}
			try{
				ContentValues values=new ContentValues();
				values.put(DBUtils.MONITOR_NAME,name);
				values.put(DBUtils.MONITOR_URL, url);
				values.put(DBUtils.MONITOR_FLOOR_AREA_ID,areaId);
				values.put(DBUtils.MONITOR_FLLOR_BUILDING_ID,buildingId);
				values.put(DBUtils.MONITOR_FLOOR_ID,floorId);
				long count=DBManager.insert(db, DBUtils.TABLE_NAME_4,null, values);
				if(count>0){
					Toast.makeText(context, "插入数据成功", Toast.LENGTH_SHORT).show();
				}else{
					Toast.makeText(context,"插入数据失败",Toast.LENGTH_SHORT).show();
				}
				DBManager.close(db);
			}catch(Exception e){
				if(isOpen()){
					DBManager.close(db);
				}
				LogUtils.e(TAG,"插入数据失败!");
			}
			
		}
	}
	//直接点击的是监控器
	public void update(String name,String url,String monitorId){
		//更新数据
		if(StringUtils.isEmpty(name)||StringUtils.isEmpty(url)){
			Toast.makeText(context, "名称和链接不能为空!",Toast.LENGTH_SHORT).show();
			if(isOpen()){
				DBManager.close(db);
			}
			return;
		}
		try{
			if(!isOpen()){
				open();
			}
			ContentValues values=new ContentValues();
			values.put(DBUtils.MONITOR_NAME,name);
			values.put(DBUtils.MONITOR_URL,url);
			String whereClause="_id=?";
			String[] whereArgs=new String[]{monitorId+""};
			int count = DBManager.update(db, DBUtils.TABLE_NAME_4, values, whereClause, whereArgs);
		}catch(Exception e){
			if(isOpen()){
				DBManager.close(db);
			}
			LogUtils.e(TAG,"更新数据失败!");
		}
	}
	
	//删除区域的
	public void delete(int areaId){
		delete(areaId,0,0,0);
	}
	//区域以外的Monitor
	public void delete(String monitorId){
		delete("_id",monitorId+"");
	}
	public void delete(int areaId,int buildingId){
		delete(areaId,buildingId,0,0);
	}
	public void delete(int areaId,int buildingId,int floorId){
		delete(areaId,buildingId,floorId,0);
	}
	public void delete(int areaId,int buildingId,int floorId,int monitorId){
		if(monitorId!=0){
			delete("_id",monitorId+"");
		}else if(floorId!=0){
			delete("floorId",floorId+"");
		}else if(buildingId!=0){
			delete("buildingId",buildingId+"");
		}else if(areaId!=0){
			delete("areaId",areaId+"");
		}
	}
	public void delete(String name,String monitorId){
		try{
			if(!isOpen()){
				open();
			}
			String whereClause=name+"=?";
			String[] whereArgs=new String[]{monitorId};
			int count =DBManager.delete(db, DBUtils.TABLE_NAME_4,whereClause, whereArgs);
			if(count>0){
				Toast.makeText(context,"删除数据成功!",Toast.LENGTH_SHORT).show();
			}
			DBManager.close(db);
		}catch(Exception e){
			if(isOpen()){
				DBManager.close(db);
			}
			LogUtils.e("delete","MonitorManagerDelete删除数据失败!");
		}
	}
}
