package pku.shengbin.hevplayer;
import android.app.Activity;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.Paint;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.opengl.GLSurfaceView;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.Surface;
import android.widget.TextView;
import android.widget.Toast;

/**
 * The Java MediaPlay class. It pairs with the C++ MediaPlay class in native layer.
 * Most of the real work is done in the C++ class. This Java class is mainly a wrapper.
 */
public class MediaPlayer {
    public static final int MEDIA_INFO_FRAMERATE_VIDEO = 900;
    public static final int MEDIA_INFO_END_OF_FILE = 909;
    public static final int MEDIA_INFO_WILL_PLAY_AGAIN = 908;

    private static Activity mOwnerActivity = null;
    private static Surface mSurface = null;
    private static GLSurfaceView mGLSurfaceView = null;
    private static TextView mInfoTextView = null;
    private static AudioTrack mAudioTrack;
    private static int mDisplayWidth = 0;
	private static int mDisplayHeight = 0;   
    private static int mDisplayFPS = -1;
    private static int mDisplayAvgFPS = -1;
	private static int mDecodeFPS = -1;
    private static int mBitrateVideo = -1;
	private static int mBitrateAudio = -1; 
    private static boolean mShowInfo = true;
    private static boolean mShowInfoGL = true;
    private static String mInfo = "";
    
    private native final void native_init();
    private native int native_open(String path, int threadNum, float fps);
    private native int native_start();
    private native int native_stop();
    private native int native_pause(); 
    private native int native_go();
    private native int native_seekTo(int msec);
    private native int native_close();
    
    static {
    	System.loadLibrary("lenthevcdec");
    	System.loadLibrary("ffmpeg");
    	System.loadLibrary("native_player");
    }

    public MediaPlayer(Activity activity) {
    	native_init();
        mOwnerActivity = activity;
    }
    
    public void setDisplay(GLSurfaceView glView, TextView tv) {
            mGLSurfaceView = glView;
            mInfoTextView = tv;
    }
    
    public void setDisplaySize(int w, int h) {
		mDisplayHeight = h;
		mDisplayWidth = w;
	}
    
    public native int getVideoWidth();
    public native int getVideoHeight();
    public native boolean isPlaying();
    public native int getCurrentPosition();
    public native int getDuration();
    public native void getAudioParams(int[] params);

    public int open(String path) {    
		SharedPreferences settings = PreferenceManager.getDefaultSharedPreferences(mOwnerActivity);  
		int num = Integer.parseInt(settings.getString("multi_thread", "0"));
		if (0 == num) {
			int cores = Runtime.getRuntime().availableProcessors();
			if (cores <= 1) {
				num = 1;
			} else {
				num = (cores < 4) ? (cores * 2) : 8;
			}
			Log.d("MediaPlayer", cores + " cores detected! use " + num + " threads.\n");
		}
		
		float loop = 0;
		if (settings.getBoolean("loop_play_switch", false)) {
			loop = 1;
		}
		int ret = native_open(path, num, loop);
		return ret;
    }
    
    public void close() {
        native_close();
    }
    
    public void start() {
    	// start audio play back   	
    	int[] params = {0,0,0};
    	getAudioParams(params);
    	if (params[0] > 0) {
    		int sampleRate = params[0];
    		int channelConfig = (params[1] == 1) ? AudioFormat.CHANNEL_OUT_MONO : 
    			((params[1] == 2) ? AudioFormat.CHANNEL_OUT_STEREO :
    				((params[1] == 4) ?AudioFormat.CHANNEL_OUT_QUAD:
    					((params[1] == 6) ?AudioFormat.CHANNEL_OUT_5POINT1 : AudioFormat.CHANNEL_OUT_7POINT1)));
    		int audioFormat = AudioFormat.ENCODING_PCM_16BIT;
    		int bufferSize = AudioTrack.getMinBufferSize(sampleRate, channelConfig, audioFormat);
        	mAudioTrack = new AudioTrack(AudioManager.STREAM_MUSIC, sampleRate, channelConfig, audioFormat, bufferSize, AudioTrack.MODE_STREAM);
        	mAudioTrack.play();
    	}
    	
    	native_start();
    }

    public void stop() {
    	native_stop();
    }

    public void pause() {
    	native_pause();
    }
    
    public void go() {
    	native_go();
    }
    
    public void seekTo(int msec) {
    	native_seekTo(msec);
    }
    
    public void setShowInfo (boolean show) {
    	mShowInfo = show;
    	if (mShowInfo == false && mInfoTextView != null) {
			mInfoTextView.setText("");
    	}
    }
    
	public static int audioTrackWrite (short[] data, int offset, int size) {
    	int ret = mAudioTrack.write(data, offset, size);
    	return ret;	
    }
		
	public static int drawFrame(int width, int height) {
        	
    	mGLSurfaceView.requestRender();
        if (mShowInfoGL) {
        	mInfo = "";
			Paint paint = new Paint();
			paint.setColor(Color.WHITE);
			paint.setTextSize(40);
			if (width > 0) {
				mInfo += ("Video Size:" + width + "x" + height);
			}
			if (mDisplayFPS > 0) {
				mInfo += ("    Display FPS:" + mDisplayFPS);
			}
			if (mDisplayAvgFPS > 0) {
				//mInfo += String.format("    Average FPS:%.2f", mDisplayAvgFPS / 4096.0);
			}
			
			mOwnerActivity.runOnUiThread(new Runnable() {
				@Override
				public void run() {
					// TODO Auto-generated method stub
						mInfoTextView.setText(mInfo);
					}
			});

			mShowInfoGL = false;
        }
        
        return 0;
	}
	
	
	/**
     * Called from native code when an interesting event happens.  This method
     * just uses the EventHandler system to post the event back to the main app thread.
     * We use a weak reference to the original MediaPlayer object so that the native
     * code is safe from the object disappearing from underneath it.  (This is
     * the cookie passed to native_setup().)
     */
	public static void postEventFromNative(int what, int arg1, int arg2) {
    	switch(what) {
    	case MEDIA_INFO_FRAMERATE_VIDEO:
    		mDisplayFPS = arg1;
    		mDisplayAvgFPS = arg2;
    		if (mShowInfo) {
    			mShowInfoGL = true;
    		}
    		break;
    	case MEDIA_INFO_END_OF_FILE:
    		mOwnerActivity.finish();
    		break;
		case MEDIA_INFO_WILL_PLAY_AGAIN:
			mOwnerActivity.runOnUiThread(new Runnable(){
				@Override
				public void run() {
					Toast.makeText(mOwnerActivity, "Loop play is ON. Will play again.", Toast.LENGTH_SHORT).show();
				}
			});
			break;
		}
	}
}
