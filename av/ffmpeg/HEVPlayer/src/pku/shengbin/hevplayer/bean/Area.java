package pku.shengbin.hevplayer.bean;

import java.util.List;

/**
 * 区域
 * @author rpts
 */
public class Area{
	
	private int id;  //主键
	private String name;  //名字
	private List<Monitor> list; //区域摄像头
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
	public List<Monitor> getList() {
		return list;
	}
	public void setList(List<Monitor> list) {
		this.list = list;
	}
	@Override
	public String toString() {
		return "Area [id=" + id + ", name=" + name + ", list=" + list + "]";
	}
	
}
