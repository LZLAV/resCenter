package pku.shengbin.hevplayer.bean;

import java.util.List;

/**
 * 监视器的实体类
 * @author rpts
 */
public class Monitor{

	private int id;
	private String name;
	private String areaId;  //区域Id
	private String buildingId;  //楼层Id
	private String floorId;  //根据floorId来进行筛选
	private String url;
	private boolean isPlay;
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
	
	public String getFloorId() {
		return floorId;
	}
	public void setFloorId(String floorId) {
		this.floorId = floorId;
	}
	public boolean isPlay() {
		return isPlay;
	}
	public void setPlay(boolean isPlay) {
		this.isPlay = isPlay;
	}
	public String getAreaId() {
		return areaId;
	}
	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}
	public String getBuildingId() {
		return buildingId;
	}
	public void setBuildingId(String buildingId) {
		this.buildingId = buildingId;
	}
	
	
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	@Override
	public String toString() {
		return "Monitor [id=" + id + ", name=" + name + ", areaId=" + areaId
				+ ", buildingId=" + buildingId + ", floorId=" + floorId
				+ ", url=" + url + ", isPlay=" + isPlay + "]";
	}
	
	
	
}
