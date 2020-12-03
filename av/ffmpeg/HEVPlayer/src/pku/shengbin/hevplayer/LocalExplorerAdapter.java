package pku.shengbin.hevplayer;

import java.io.File;
import pku.shengbin.hevplayer.R;
import pku.shengbin.utils.FileUtils;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * Adapter for the LocalExploreActivity's file list.
 */
public class LocalExplorerAdapter extends BaseAdapter {
	
	private File[] 							mFiles;
	private LayoutInflater 					mInflater;
	private Context 						mContext;
	private boolean							mHasParrent;

	

	public LocalExplorerAdapter(Context context, File[] files, boolean isRoot) {
		mFiles = files;
        mInflater = LayoutInflater.from(context);
        mContext = context;
        mHasParrent = !isRoot;
	}
	
	public int getCount() {
		return mFiles.length;
	}

	public Object getItem(int position) {
		return mFiles[position];
	}

	public long getItemId(int position) {
		return position;
	}
	
	private void setRow(final ViewHolder holder, int position) {
		File file = mFiles[position];
		holder.text.setText(file.getName());
		if (position == 0 && mHasParrent) {
			holder.icon.setImageDrawable(mContext.getResources().getDrawable(R.drawable.ic_menu_back));
			holder.text.setText("< Parent Directory > ");
		} else if (file.isDirectory()) {
			holder.icon.setImageDrawable(mContext.getResources().getDrawable(R.drawable.ic_menu_archive));
		} else {
			if (FileUtils.checkExtension(file)) {
				//TODO 加线程控制
//				path =file.getPath();
//				if(map.get(path)!=null){
//					Bitmap bitmap =map.get(path);
//					holder.icon.setImageBitmap(bitmap);
//				}else{
//					new Thread(){
//						@Override
//						public void run() {
//							super.run();
//							Bitmap bitmap=BitmapUtils.createVideoThumbnail(path);
//							map.put(path,bitmap);
//							Message msg=Message.obtain();
//							BitmapData bitmapData=new BitmapData();
//							bitmapData.setBitmap(bitmap);
//							bitmapData.setPath(path);
//							bitmapData.setImageView(holder.icon);
//							msg.obj = bitmapData;
//							msg.what=CREATE_BITMAP;
//							handler.sendMessage(msg);
//						}
//					}.start();;
//					holder.icon.setImageDrawable(mContext.getResources().getDrawable(R.drawable.ic_menu_gallery));
//				}
				
//				Bitmap bitmap = BitmapUtils.createVideoThumbnail(file.getPath());
//				if (bitmap != null) {
//					holder.icon.setImageBitmap(bitmap);
//				} else {
					holder.icon.setImageDrawable(mContext.getResources().getDrawable(R.drawable.ic_menu_gallery));
//				}
			} else {
				holder.icon.setImageDrawable(mContext.getResources().getDrawable(R.drawable.ic_menu_block));
			}
		}
	}
	private static ViewHolder holder;
	public View getView(int position, View convertView, ViewGroup parent) {
		// A ViewHolder keeps references to children views to avoid unneccessary calls
        // to findViewById() on each row.
		
        // When convertView is not null, we can reuse it directly, there is no need
        // to re-inflate it. We only inflate a new View when the convertView supplied
        // by ListView is null.
        if (convertView == null) {
            convertView = mInflater.inflate(R.layout.movie_explorer_row, parent, false);

            // Creates a ViewHolder and store references to the two children views
            // we want to bind data to.
            holder = new ViewHolder();
            holder.text = (TextView) convertView.findViewById(R.id.textview_rowtext);
            holder.icon = (ImageView) convertView.findViewById(R.id.imageview_rowicon);

            convertView.setTag(holder);
        } else {
            // Get the ViewHolder back to get fast access to the TextView
            // and the ImageView.
            holder = (ViewHolder) convertView.getTag();
        }

		// Bind the data efficiently with the holder.
		setRow(holder, position);
		
        return convertView;
	}
	
	private static class ViewHolder {
	    TextView text;
	    ImageView icon;
	}
}