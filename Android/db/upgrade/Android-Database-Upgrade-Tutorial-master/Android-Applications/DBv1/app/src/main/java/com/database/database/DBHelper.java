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
    public static final int DATABASE_VERSION = 1;
    public static final String DATABASE_NAME = "Alphabets.db";

    //Tables and Columns
    public static final String TABLE_NAME = "alpha";
    public static final String COLUMN_A = "A";

    //Queries
    private static final String SQL_CREATE_TABLE_v1 = "CREATE TABLE " + TABLE_NAME + " (" + COLUMN_A + " TEXT )";

    //______________________________________________________________________________________________
    public DBHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
        Log.e(getClass().getSimpleName(), "DBHelper");
    }

    public void onCreate(SQLiteDatabase db) {
        Log.e(getClass().getSimpleName(), "onCreate");
        db.execSQL(SQL_CREATE_TABLE_v1);
    }

    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        Log.e(getClass().getSimpleName(), "onUpgrade");
    }
}