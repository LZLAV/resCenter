package pku.shengbin.hevplayer.fragment;

import pku.shengbin.hevplayer.R;
import pku.shengbin.hevplayer.SettingsActivity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class SettingFragment extends Fragment implements OnClickListener{
	
	private TextView settingText;  //…Ë÷√
	private static final int REQ_SYSTEM_SETTINGS = 0;
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View view=inflater.inflate(R.layout.setting_fragment, null);
		settingText = (TextView) view.findViewById(R.id.text);
		settingText.setOnClickListener(this);
		initTitle(view);
		return view;
	}

	private void initTitle(View view) {
		RelativeLayout titleRelative=(RelativeLayout) view.findViewById(R.id.title);
		TextView titleTextView =(TextView) titleRelative.findViewById(R.id.title_text);
		titleTextView.setText(getResources().getString(R.string.setting));
//		titleTextView.setTextSize(20);
	}

	@Override
	public void onClick(View view) {
		switch(view.getId()){
			case R.id.text:
				getActivity().startActivityForResult(new Intent(getActivity(), SettingsActivity.class), REQ_SYSTEM_SETTINGS);  
				break;
		}
	}
	
	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		if (requestCode == REQ_SYSTEM_SETTINGS) {   
	    	//restart activity to apply the setting changes
            getActivity().finish();
            startActivity(new Intent(getActivity(), getActivity().getClass()));
        }
	}
}