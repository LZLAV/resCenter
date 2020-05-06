package duti.com.databaseupgrade.database;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

import duti.com.databaseupgrade.Student;

import static duti.com.databaseupgrade.database.FieldConstants.TABLE_ALL_STUDENT;
import static duti.com.databaseupgrade.database.FieldConstants.mStudentAddress;
import static duti.com.databaseupgrade.database.FieldConstants.mStudentId;
import static duti.com.databaseupgrade.database.FieldConstants.mStudentName;

public class DbManager {
    private static String TAG = DbManager.class.getSimpleName();

    private static DbManager instance;
    private Context mContext;

    private DbManager(Context context) {
        this.mContext = context;
    }

    public static DbManager getInstance(Context context) {
        if (instance == null) {
            instance = new DbManager(context);
        }
        return instance;
    }

    /* Insert single row into table*/
    public void insertIntoAllStudent(String studentId, String StudentName, String studentAddress){
        Log.i("duti","before insert");

        // 2. create ContentValues to add key "column"/value
        ContentValues values = new ContentValues();

        // 1. get reference to writable DB
        DbHelper dbHelper = new DbHelper(mContext);
        SQLiteDatabase db = dbHelper.getWritableDatabase();

        values.put(mStudentId, studentId);
        values.put(mStudentName, StudentName);
        values.put(mStudentAddress, studentAddress);

        // 3. insert
        db.insert(TABLE_ALL_STUDENT, null, values);
        // 4. close
        dbHelper.close();
        Log.i("duti", "After insert");
    }

    /* get all row table */
    public List<Student> getAllStudent() {
        List<Student> modelList = new ArrayList<Student>();
        DbHelper dbHelper = new DbHelper(mContext);
        SQLiteDatabase db = dbHelper.getWritableDatabase();
        String query = "select * from " + TABLE_ALL_STUDENT;
        Cursor cursor = db.rawQuery(query, null);
        Log.i("duti", "total number of Student: "+cursor.getCount());
        if (cursor.moveToFirst()) {
            do {
                Student model = new Student();
                model.setRecordId(cursor.getInt(0));
                model.setStudentId(cursor.getInt(1));
                model.setStudentName(cursor.getString(2));
                model.setStudentAddress(cursor.getString(3));
                modelList.add(model);
            } while (cursor.moveToNext());
        }
        cursor.close();
        dbHelper.close();
        return modelList;
    }

    public void clearDB(String tableName) {
        DbHelper dbHelper = new DbHelper(mContext);
        SQLiteDatabase db = dbHelper.getWritableDatabase();
        db.delete(tableName, null, null);
        dbHelper.close();
    }

}

