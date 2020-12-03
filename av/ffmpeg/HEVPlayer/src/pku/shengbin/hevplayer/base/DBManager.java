package pku.shengbin.hevplayer.base;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

/**
 * area数据库操作
 * @author rpts
 */
public class DBManager {
	
	private static DBManager dbManager;
	
	public static DBManager getInstance(Context context){
		if(dbManager==null){
			dbManager=new DBManager();
		}
		return dbManager;
	}
	
	//TODO  数据库的增删改查功能
	/**
	 * 执行SQL语句进行查询
	 * @param db
	 * @param sql
	 */
	public static void execSql(SQLiteDatabase db,String sql){
		if(db!=null){
			if(!"".equals(sql)&&sql!=null){
				db.execSQL(sql);
			}
		}
	}
	/**
	 * 采用api中提供的方法插入数据
	 * @param db
	 * @param table
	 * @param nullColumnHack
	 * @param values
	 * @return
	 */
	public static long insert(SQLiteDatabase db,String table,String nullColumnHack,ContentValues values){
		long count=0;
		if(db!=null){
			count = db.insert(table, nullColumnHack, values);
		}
		return count;
	}
	/**
	 * 根据api提供的方法修改数据
	 * @param db
	 * @param table
	 * @param values
	 * @param whereClause
	 * @param whereArgs
	 * @return
	 */
	public static int update(SQLiteDatabase db,String table,ContentValues values,String whereClause,String[] whereArgs){
		int count=0;
		if(db!=null){
			count=db.update(table,values,whereClause,whereArgs);
		}
		return count;
	}
	/**
	 * 采用api方式删除数据
	 * @param db
	 * @param table
	 * @param whereClause
	 * @param whereArgs
	 * @return
	 */
	public static int delete(SQLiteDatabase db,String table,String whereClause,String[] whereArgs){
		int count=0;
		if(db!=null){
			count=db.delete(table, whereClause, whereArgs);
		}
		return count;
	}
	/**
	 * 通过sql语句查询数据表
	 * @param db
	 * @param sql
	 * @param selectionArgs
	 * @return
	 */
	public static Cursor query(SQLiteDatabase db,String sql,String[] selectionArgs){
		Cursor cursor=null;
		if(db!=null){
			cursor =db.rawQuery(sql, selectionArgs);
		}
		return cursor;
	}
	/**
	 * 通过api方式查询数据表
	 * @param db
	 * @param table
	 * @param columns
	 * @param selection
	 * @param selectionArgs
	 * @param groupBy
	 * @param having
	 * @param orderBy
	 * @return
	 */
	public static Cursor query(SQLiteDatabase db,String table,String[] columns,String selection,String[] selectionArgs,String groupBy,String having,String orderBy){
		Cursor cursor=null;
		if(db!=null){
			cursor = db.query(table, columns, selection, selectionArgs, groupBy, having, orderBy);
		}
		return cursor;
	}
	/**
	 * 关闭数据库
	 * @param db
	 */
	public static void close(SQLiteDatabase db){
		if(db!=null){
			db.close();
		}
	}
}
