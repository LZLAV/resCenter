package pku.shengbin.hevplayer.base.entity;

import java.util.ArrayList;
import java.util.List;

import pku.shengbin.hevplayer.base.DBManager;
import pku.shengbin.hevplayer.base.DBUtils;
import pku.shengbin.hevplayer.base.DatabaseOpenHelper;
import pku.shengbin.hevplayer.bean.Building;
import pku.shengbin.utils.LogUtils;
import pku.shengbin.utils.StringUtils;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.widget.Toast;

public class BuildingManger {

	private static DatabaseOpenHelper helper;
	private static BuildingManger buildingManager;
	private FloorManager floorManager;
	private SQLiteDatabase db;
	private Context context;
	private static String TAG="BuildingManager";
	
	public static BuildingManger getInstance(Context context){
		helper=DatabaseOpenHelper.getInstance(context);
		if(buildingManager==null){
			buildingManager=new BuildingManger(context);
		}
		return buildingManager;
	}
	
	private BuildingManger(Context context){
		this.context =context;
		db=helper.getWritableDatabase();
	}
	
	private void initFloorManager(){
		if(floorManager==null){
			floorManager=FloorManager.getInstance(context);
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
	
	public void insert(String name,int areaId){
		try{
			if(StringUtils.isEmpty(name)){
				Toast.makeText(context, "名称不能为空！", Toast.LENGTH_SHORT).show();
				if(isOpen()){
					DBManager.close(db);
				}
				return;
			}
			if(!isOpen()){
				open();
			}
			ContentValues values = new ContentValues();
			values.put(DBUtils.BUILDING_NAME,name);
			values.put(DBUtils.BUILDING_AREA_ID,areaId);
			long count=DBManager.insert(db,DBUtils.TABLE_NAME_2, null, values);
			if(count>0){
				Toast.makeText(context,"添加数据成功!", Toast.LENGTH_SHORT).show();
			}else{
				Toast.makeText(context, "添加数据失败!",Toast.LENGTH_SHORT).show();
			}
			DBManager.close(db);
		}catch(Exception e){
			if(isOpen()){
				DBManager.close(db);
			}
			LogUtils.e(TAG,"添加数据失败!");
		}
		
	}
	
	public List<Building> query(int areaId){
		List<Building> list=new ArrayList<Building>();
		try{
			if(!isOpen()){
				open();
			}
			String selection ="areaId=?";
			String[] selectionArgs=new String[]{areaId+""};
			Cursor cursor = DBManager.query(db, DBUtils.TABLE_NAME_2, null, selection, selectionArgs, null,null,null);
			list = cursorToList(cursor);
			
		}catch(Exception e){
			if(isOpen()){
				DBManager.close(db);
			}
			LogUtils.e(TAG,"查询数据失败!");
		}
		return list;
	}

	private List<Building> cursorToList(Cursor cursor) {
		List<Building> list=new ArrayList<Building>();
		Building building;
		while(cursor.moveToNext()){
			int id=cursor.getInt(cursor.getColumnIndex(DBUtils.BUILDING_ID));
			String name=cursor.getString(cursor.getColumnIndex(DBUtils.BUILDING_NAME));
			String areaId = cursor.getString(cursor.getColumnIndex(DBUtils.BUILDING_AREA_ID));
			building = new Building();
			building.setId(id);
			building.setName(name);
			building.setAreaId(areaId);
			list.add(building);
		}
		return list;
	}
	
	
	public void delete(int areaId){  //删除含有areaId字段的building表
		delete(areaId,0);
	}
	
	public void delete(int areaId,int buildingId){ //删除改building表所对应的buildingId这一项
		initFloorManager();
		floorManager.delete(areaId,buildingId);
		if(buildingId!=0){
			//删除building表中所对应的buildingId数据
			delete("_id",buildingId+"");
		}else if(areaId!=0){
			delete("areaId",areaId+"");
		}
	}
	
	public void delete(String name,String value){
		try{
			if(!isOpen()){
				open();
			}
			String whereClause =name+"=?";
			String[] whereArgs =new String[]{value};
			int count=DBManager.delete(db, DBUtils.TABLE_NAME_2, whereClause, whereArgs);
		}catch(Exception e){
			LogUtils.e("delete","BuildingManager删除数据失败!");
			if(isOpen()){
				DBManager.close(db);
			}
		}
	}
	
	public void update(String name,int buildingId){
		try{
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
			values.put(DBUtils.BUILDING_NAME,name);
			String whereClause="_id=?";
			String[] whereArgs=new String[]{buildingId+""};
			int count = DBManager.update(db, DBUtils.TABLE_NAME_2, values, whereClause, whereArgs);
		}catch(Exception e){
			if(isOpen()){
				DBManager.close(db);
			}
			LogUtils.e(TAG,"更新数据失败!");
		}
		
	}
}
