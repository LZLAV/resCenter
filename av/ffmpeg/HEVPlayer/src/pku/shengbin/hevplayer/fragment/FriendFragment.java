package pku.shengbin.hevplayer.fragment;

import pku.shengbin.hevplayer.R;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class FriendFragment extends Fragment {

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View view=inflater.inflate(R.layout.friend_fragment, null);
		initTitle(view);
		return view;
	}

	private void initTitle(View view) {
		RelativeLayout titleRelative=(RelativeLayout) view.findViewById(R.id.title);
		TextView titleTextView =(TextView) titleRelative.findViewById(R.id.title_text);
		titleTextView.setText(getResources().getString(R.string.friend));
//		titleTextView.setTextSize(20);
	}
}
