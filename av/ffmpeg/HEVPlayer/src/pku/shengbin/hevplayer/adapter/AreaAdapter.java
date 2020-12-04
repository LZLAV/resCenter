package pku.shengbin.hevplayer.adapter;

import java.util.List;

import pku.shengbin.hevplayer.R;
import pku.shengbin.hevplayer.bean.Area;
import pku.shengbin.hevplayer.bean.Monitor;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class AreaAdapter extends BaseAdapter {

	private List<Area> list;
	private List<Monitor> listMonitor;
	private LayoutInflater inflater;
	private int size1=0;  //集合1长度
	private int size2=0;  //集合2长度
	
	public AreaAdapter(Context context,List<Area> list,List<Monitor> listMonitor){
		this.list=list;
		this.listMonitor = listMonitor;
		size1 = list.size();
		size2=listMonitor.size();
		inflater = LayoutInflater.from(context);
	}
	
	@Override
	public int getCount() {
		// TODO Auto-generated method stub
		return size1+size2;
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		if(position>=size1){
			return listMonitor.get(position-size1);
		}else{
			return list.get(position);
		}
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder;
		if(convertView==null){
			viewHolder = new ViewHolder();
			convertView =inflater.inflate(R.layout.structure_item,null);
			viewHolder.image =(ImageView) convertView.findViewById(R.id.image);
			viewHolder.textView = (TextView) convertView.findViewById(R.id.text);
			convertView.setTag(viewHolder);
		}else{
			viewHolder = (ViewHolder) convertView.getTag();
		}
		if(position>=size1){
			viewHolder.image.setImageResource(R.drawable.ic_monitor);
			viewHolder.textView.setText(listMonitor.get(position-size1).getName());
		}else{
			viewHolder.image.setImageResource(R.drawable.building_1);
			viewHolder.textView.setText(list.get(position).getName());
		}
		return convertView;
	}
	
	public void setData(List<Area> list){
		this.list=list;
		size1 = list.size();
	}
	
	public void setDataMonitor(List<Monitor> listMonitor){
		this.listMonitor = listMonitor;
		size2 = listMonitor.size(); 
	}
	
	static class ViewHolder{
		public ImageView image;
		public TextView textView;
	}

}
