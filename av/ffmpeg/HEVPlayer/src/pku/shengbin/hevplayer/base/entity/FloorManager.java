package pku.shengbin.hevplayer.base.entity;

import java.util.ArrayList;
import java.util.List;

import pku.shengbin.hevplayer.base.DBManager;
import pku.shengbin.hevplayer.base.DBUtils;
import pku.shengbin.hevplayer.base.DatabaseOpenHelper;
import pku.shengbin.hevplayer.bean.Floor;
import pku.shengbin.utils.LogUtils;
import pku.shengbin.utils.StringUtils;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.widget.Toast;

public class FloorManager {

	private static DatabaseOpenHelper helper;
	private static DBManager dbManager;
	private static FloorManager floorManager;
	private static MonitorManager monitorManager;
	private SQLiteDatabase db;
	private Context context;
	private static String TAG="FloorManager";
	
	public static FloorManager getInstance(Context context){
		helper=DatabaseOpenHelper.getInstance(context);
		dbManager = DBManager.getInstance(context);
		if(floorManager==null){
			floorManager=new FloorManager(context);
		}
		return floorManager;
	}
	
	private FloorManager(Context context){
		this.context = context;
		db=helper.getWritableDatabase();
	}
	
	private void initMonitorManager(){
		if(monitorManager==null){
			monitorManager=MonitorManager.getInstance(context);
		}
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
	
	public void insert(String name,int areaId,int buildingId){
		try{
			if(!isOpen()){
				open();
			}
			if(StringUtils.isEmpty(name)){
				Toast.makeText(context, "名字不能为空!",Toast.LENGTH_SHORT).show();
				if(isOpen()){
					DBManager.close(db);
				}
				return;
			}
			ContentValues values =new ContentValues();
			values.put(DBUtils.FLOOR_AREA_ID,areaId);
			values.put(DBUtils.FLOOR_BUILDING_ID, buildingId);
			values.put(DBUtils.FLOOR_NAME,name);
			long count = DBManager.insert(db,DBUtils.TABLE_NAME_3,null,values);
			if(count>0){
				Toast.makeText(context,"添加数据成功!",Toast.LENGTH_SHORT).show();
			}else{
				Toast.makeText(context, "添加数据失败!", Toast.LENGTH_SHORT).show();
			}
			DBManager.close(db);
		}catch(Exception e){
			if(isOpen()){
				DBManager.close(db);
			}
			LogUtils.e(TAG,"添加数据失败!");
		}
		
	}
	
	public List<Floor> query(int areaId,int buildingId){
		List<Floor> list=new ArrayList<Floor>();
		try{
			if(!isOpen()){
				open();
			}
			String selection ="areaId=? and buildingId =?";
			String[] selectionArgs =new String[]{areaId+"",buildingId+""};
			Cursor cursor =DBManager.query(db,DBUtils.TABLE_NAME_3,null,selection,selectionArgs,null,null,null);
			list = cursorToList(cursor);
		}catch(Exception e){
			if(isOpen()){
				DBManager.close(db);
			}
			LogUtils.e(TAG,"查询数据失败!");
		}
		return list;
	}

	private List<Floor> cursorToList(Cursor cursor) {
		List<Floor> list =new ArrayList<Floor>();
		Floor  floor;
		while(cursor.moveToNext()){
			int id =cursor.getInt(cursor.getColumnIndex(DBUtils.FLOOR_ID));
			String name =cursor.getString(cursor.getColumnIndex(DBUtils.FLOOR_NAME));
			String areaId =cursor.getString(cursor.getColumnIndex(DBUtils.FLOOR_AREA_ID));
			String buildingId = cursor.getString(cursor.getColumnIndex(DBUtils.FLOOR_BUILDING_ID));
			floor = new Floor();
			floor.setAreaId(areaId);
			floor.setBuildingId(buildingId);
			floor.setId(id);
			floor.setName(name);
			list.add(floor);
		}
		return list;
	}

	public void update(String name,int floorId){
		try{
			//更新两个表的数据
			if(StringUtils.isEmpty(name)){
				Toast.makeText(context, "名称不能为空!",Toast.LENGTH_SHORT).show();
				if(isOpen()){
					DBManager.close(db);
				}
				return;
			}
			if(!isOpen()){
				open();
			}
			ContentValues values=new ContentValues();
			values.put(DBUtils.FLOOR_NAME,name);
			String whereClause="_id=?";
			String[] whereArgs=new String[]{floorId+""};
			int count=DBManager.update(db, DBUtils.TABLE_NAME_3, values, whereClause, whereArgs);
		}catch(Exception e){
			if(isOpen()){
				DBManager.close(db);
			}
			LogUtils.e(TAG,"更新数据失败!");
		}
	}
	
	public void delete(int areaId){
		delete(areaId,0,0);
	}
	public void delete(int areaId,int buildingId){
		delete(areaId,buildingId,0);
	}
	public void delete(int areaId,int buildingId,int floorId){
		initMonitorManager();
		monitorManager.delete(areaId, buildingId, floorId);  //删除监视器
		if(floorId!=0){
			delete("_id",floorId+"");   //删除floorId表数据
		}else if(buildingId!=0){
			delete("buildingId",buildingId+"");
		}else if(areaId!=0){
			delete("areaId",areaId+"");
		}
	}
	
	public void delete(String name,String nameValue){
		try{
			if(!isOpen()){
				open();
			}
			String whereClause =name+"=?";
			String[] whereArgs=new String[]{nameValue};
			int count =DBManager.delete(db, DBUtils.TABLE_NAME_3, whereClause, whereArgs);
		}catch(Exception e){
			LogUtils.e("delete","FloorManagerDelete删除数据失败!");
		}
		
	}
}
