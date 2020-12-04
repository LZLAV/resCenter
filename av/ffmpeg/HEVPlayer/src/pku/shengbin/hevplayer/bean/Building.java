package pku.shengbin.hevplayer.bean;

import java.util.List;

/**
 * 大楼
 * @author rpts
 */
public class Building{
	
	private int id;  //主键
	private String name;
	private String areaId;  //根据areaId来筛选
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getAreaId() {
		return areaId;
	}
	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}
	@Override
	public String toString() {
		return "Building [id=" + id + ", name=" + name + ", areaId=" + areaId
				+ "]";
	}
	
}
