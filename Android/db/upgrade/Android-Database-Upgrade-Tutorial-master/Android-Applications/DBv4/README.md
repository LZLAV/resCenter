Database helper class
----
````java
package com.database.database;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

/**
 * Shayan Rais (http://shanraisshan.com)
 * created on 8/26/2016
 */
public class DBHelper extends SQLiteOpenHelper {

    //https://developer.android.com/training/basics/data-storage/databases.html

    // If you change the database schema, you must increment the database version.
    public static final int DATABASE_VERSION = 4;
    public static final String DATABASE_NAME = "Alphabets.db";

    //Tables and Columns
    public static final String TABLE_NAME = "alpha";
    public static final String COLUMN_A = "A";
    public static final String COLUMN_B = "B";
    public static final String COLUMN_C = "C";
    public static final String COLUMN_D = "D";

    //Queries
    private static final String SQL_CREATE_TABLE_v4 = "CREATE TABLE " + TABLE_NAME
            + " (" + COLUMN_A + " TEXT, " + COLUMN_B + " TEXT, " + COLUMN_C + " TEXT, " + COLUMN_D + " TEXT)";

    private static final String SQL_ALTER_TABLE_v2 = "ALTER TABLE " + TABLE_NAME + " ADD COLUMN " + COLUMN_B + " TEXT";
    private static final String SQL_ALTER_TABLE_v3 = "ALTER TABLE " + TABLE_NAME + " ADD COLUMN " + COLUMN_C + " TEXT";
    private static final String SQL_ALTER_TABLE_v4 = "ALTER TABLE " + TABLE_NAME + " ADD COLUMN " + COLUMN_D + " TEXT";



    //______________________________________________________________________________________________
    public DBHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        Log.e(getClass().getSimpleName(), "DBHelper");
    }

    public void onCreate(SQLiteDatabase db) {
        Log.e(getClass().getSimpleName(), "onCreate");
        db.execSQL(SQL_CREATE_TABLE_v4);
    }

    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        Log.e(getClass().getSimpleName(), "onUpgrade");
        int moveToNextVersion = oldVersion+1;
        switch(moveToNextVersion) {
            case 1:
                //[database_: user had this version from start of his life - DO NOTHING]
            case 2:
                db.execSQL(SQL_ALTER_TABLE_v2);
            case 3:
                db.execSQL(SQL_ALTER_TABLE_v3);
            case 4:
                db.execSQL(SQL_ALTER_TABLE_v4);
                break;
        }
    }
}
````
