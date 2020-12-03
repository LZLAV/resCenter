package pku.shengbin.hevplayer.base;

import pku.shengbin.utils.StringUtils;
import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;
import android.widget.Toast;

public class DatabaseOpenHelper extends SQLiteOpenHelper {
	
	private static DatabaseOpenHelper helper;
	private String sql;
	private Context context;
	
	public static DatabaseOpenHelper getInstance(Context context){
		if(helper==null){
			helper=new DatabaseOpenHelper(context);
		}
		return helper;
	}
	
	public DatabaseOpenHelper(Context context, String name,
			CursorFactory factory, int version) {
		super(context, name, factory, version);
	}
	
	public DatabaseOpenHelper(Context context){
		super(context,DBUtils.DATABASE_NAME,null,DBUtils.DATABASE_VERSION);
		this.context =context;
	}

//	public void onCreate(String sql) {
//		this.sql=sql;
//	}
//	
	@Override
	public void onCreate(SQLiteDatabase db) {
//		try{
//			if(!StringUtils.isEmpty(sql)){
//				db.execSQL(sql);
//			}else{
//				Toast.makeText(context, "sql语句为空", Toast.LENGTH_SHORT).show();
//			}
//		}catch(Exception e){
//			Toast.makeText(context, "创建数据表出错", Toast.LENGTH_SHORT).show();
//		}
		db.execSQL("create table "+DBUtils.TABLE_NAME_1+"("+DBUtils.AREA_ID+" integer primary key autoincrement,"+DBUtils.AREA_NAME+" varchar(50))");
		db.execSQL("create table "+DBUtils.TABLE_NAME_2+"("+DBUtils.BUILDING_ID+" integer primary key autoincrement,"+DBUtils.BUILDING_NAME+" varchar(50),"+DBUtils.BUILDING_AREA_ID+" varchar(10))");
		db.execSQL("create table "+DBUtils.TABLE_NAME_3+"("+DBUtils.FLOOR_ID+" integer primary key autoincrement,"+DBUtils.FLOOR_NAME+" varchar(50),"+DBUtils.FLOOR_BUILDING_ID+" varchar(10),"+DBUtils.FLOOR_AREA_ID+" varchar(10))");
		db.execSQL("create table "+DBUtils.TABLE_NAME_4+"("+DBUtils.MONITOR_ID+" integer primary key autoincrement,"+DBUtils.MONITOR_NAME+
				" varchar(50),"+DBUtils.MONITOR_FLOOR_AREA_ID+" varchar(10),"+DBUtils.FLOOR_BUILDING_ID+" varchar(10),"+DBUtils.MONITOR_URL+" varchar(50),"
				+DBUtils.MONITOR_FLOOR_ID+" varchar(10))");
	}

	@Override
	public void onUpgrade(SQLiteDatabase arg0, int oldVersion, int newVersion) {
		//TODO  数据库版本更新是操作
		if(newVersion>oldVersion){
			//版本更新后的具体操作
		}
	}
	
	public static void closeDb(SQLiteDatabase db){
		if(db!=null){
			db.close();
		}
	}
}
