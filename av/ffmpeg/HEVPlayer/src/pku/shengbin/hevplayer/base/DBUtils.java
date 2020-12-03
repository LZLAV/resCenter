package pku.shengbin.hevplayer.base;

public class DBUtils {
	public static final String DATABASE_NAME="monitor";  //数据库名称
	public static final int DATABASE_VERSION=1;  //数据库版本
	
	public static final String TABLE_NAME_1="area"; //area表
	public static final String AREA_ID="_id";  //自增
	public static final String AREA_NAME="name";  //区域名称
	
	public static final String TABLE_NAME_2="building";  //building表
	public static final String BUILDING_ID="_id";
	public static final String BUILDING_NAME="name";
	public static final String BUILDING_AREA_ID="areaId";
	
	public static final String TABLE_NAME_3="floor";   	//楼道
	public static final String FLOOR_ID="_id";
	public static final String FLOOR_NAME="name";
	public static final String FLOOR_AREA_ID="areaId";
	public static final String FLOOR_BUILDING_ID="buildingId";
	
	public static final String TABLE_NAME_4="monitors";  //摄像头目录
	public static final String MONITOR_ID="_id";
	public static final String MONITOR_NAME="name";
	public static final String MONITOR_URL="url";
	public static final String MONITOR_FLOOR_ID="floorId";
	public static final String MONITOR_FLOOR_AREA_ID="areaId";
	public static final String MONITOR_FLLOR_BUILDING_ID="buildingId";
	
	
}
