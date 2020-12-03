package pku.shengbin.hevplayer.adapter;

import java.util.List;

import pku.shengbin.hevplayer.R;
import pku.shengbin.hevplayer.bean.Monitor;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class MonitorAdapter extends BaseAdapter {

	private List<Monitor> list;
	private LayoutInflater inflater;
	
	public MonitorAdapter(Context context,List<Monitor> list){
		inflater = LayoutInflater.from(context);
		this.list=list;
	}
	
	@Override
	public int getCount() {
		
		return list.size();
	}

	@Override
	public Object getItem(int position) {

		return list.get(position);
	}

	@Override
	public long getItemId(int position) {

		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder;
		if(convertView==null){
			viewHolder = new ViewHolder();
			convertView =inflater.inflate(R.layout.structure_item, null);
			viewHolder.image = (ImageView) convertView.findViewById(R.id.image);
			viewHolder.text =(TextView) convertView.findViewById(R.id.text);
			convertView.setTag(viewHolder);
		}else{
			viewHolder=(ViewHolder) convertView.getTag();
		}
		//Êý¾ÝÏÔÊ¾
		viewHolder.image.setImageResource(R.drawable.ic_monitor);
		viewHolder.text.setText(list.get(position).getName());
		return convertView;
	}
	
	public void setData(List<Monitor> list){
		this.list=list;
	}
	
	static class ViewHolder{
		public ImageView image;
		public TextView text;
	}
}
