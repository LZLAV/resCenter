package pku.shengbin.hevplayer;

import java.util.ArrayList;
import java.util.List;

import pku.shengbin.hevplayer.fragment.FriendFragment;
import pku.shengbin.hevplayer.fragment.MonitoringFragment;
import pku.shengbin.hevplayer.fragment.SettingFragment;
import pku.shengbin.hevplayer.fragment.VideoFragment;
import pku.shengbin.utils.LogUtils;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Toast;

/**
 * 程序主界面
 */
public class MainActivity extends FragmentActivity implements OnClickListener,OnPageChangeListener{

	private Button monitoringButton;  //监控
	private Button friendButton;  //朋友
	private Button videoButton;  //视频
	private Button settingButton;  //我
	private ViewPager viewpager;
	private FragmentManager manager;
	private FragmentTransaction transaction;
	private List<Fragment> fragmentList;
	private MonitoringFragment monitorFragment;
	private FriendFragment friendFragment;
	private VideoFragment videoFragment;
	private SettingFragment settingFragment;
	private LinearLayout linearTab;
	private static String TAG="MainActivity";
	
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_main);
        initView();
        initList();
        viewpager.setAdapter(new MyFragmentPagerAdapter(manager));
        viewpager.setOnPageChangeListener(this);
    }
    
    private void initList() {
    	fragmentList.add(monitorFragment);
    	fragmentList.add(friendFragment);
    	fragmentList.add(videoFragment);
    	fragmentList.add(settingFragment);
	}

	private void initView(){
    	monitoringButton=(Button) findViewById(R.id.monitoring);
    	friendButton =(Button) findViewById(R.id.friend);
    	videoButton = (Button) findViewById(R.id.video);
    	settingButton =(Button) findViewById(R.id.setting);
    	viewpager=(ViewPager) findViewById(R.id.viewpager);
    	viewpager.setOffscreenPageLimit(3);
    	linearTab = (LinearLayout) findViewById(R.id.ll_tabs);
    	manager=getSupportFragmentManager();
    	fragmentList = new ArrayList<Fragment>();
    	monitorFragment=new MonitoringFragment();
    	friendFragment=new FriendFragment();
    	videoFragment =new VideoFragment();
    	settingFragment= new SettingFragment();
    	monitoringButton.setSelected(true);
    	monitoringButton.setOnClickListener(this);
    	friendButton.setOnClickListener(this);
    	videoButton.setOnClickListener(this);
    	settingButton.setOnClickListener(this);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.activity_main, menu);
        return false;
    }

	@Override
	public void onClick(View view) {
		
		switch(view.getId()){
			case R.id.monitoring:
				viewpager.setCurrentItem(0,false);
				btnSelection(0);
				//点击监控
				break;
			case R.id.friend:
				viewpager.setCurrentItem(1,false);
				btnSelection(1);
				break;
			case R.id.video:
				viewpager.setCurrentItem(2,false);
				btnSelection(2);
				break;
			case R.id.setting:
				viewpager.setCurrentItem(3,false);
				btnSelection(3);
				break;
		}
	}
	
	class MyFragmentPagerAdapter extends FragmentPagerAdapter{

		public MyFragmentPagerAdapter(FragmentManager fm) {
			super(fm);
		}

		@Override
		public Fragment getItem(int position) {
			// TODO Auto-generated method stub
			return fragmentList.get(position);
		}

		@Override
		public int getCount() {
			// TODO Auto-generated method stub
			return fragmentList.size();
		}
		
	}

	@Override
	public void onPageScrollStateChanged(int arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onPageScrolled(int arg0, float arg1, int arg2) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onPageSelected(int position) {
		// TODO Auto-generated method stub
		btnSelection(position);
	}
	
	private void btnSelection(int position) {
		switch(position){
			case 0:
				monitoringButton.setSelected(true);
				friendButton.setSelected(false);
				videoButton.setSelected(false);
				settingButton.setSelected(false);
				break;
			case 1:
				monitoringButton.setSelected(false);
				friendButton.setSelected(true);
				videoButton.setSelected(false);
				settingButton.setSelected(false);
				break;
			case 2:
				monitoringButton.setSelected(false);
				friendButton.setSelected(false);
				videoButton.setSelected(true);
				settingButton.setSelected(false);
				break;
			case 3:
				monitoringButton.setSelected(false);
				friendButton.setSelected(false);
				videoButton.setSelected(false);
				settingButton.setSelected(true);
				break;
		}
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if(keyCode==KeyEvent.KEYCODE_BACK&&event.getRepeatCount()==0){
			if(viewpager.getCurrentItem()==2){
				if(VideoFragment.goBack()){
					return true;
				}
			}
			
			if(viewpager.getCurrentItem()==0){
				MonitoringFragment fragment=new MonitoringFragment();
				if(fragment.goBack()){
					return true;
				}
			}
		}
		return super.onKeyDown(keyCode, event);
	}
}
