package pku.shengbin.utils;

import pku.shengbin.hevplayer.R;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.ViewGroup.LayoutParams;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.PopupWindow;
import android.widget.TextView;

public class DialogUtils {
	
	private static PopupWindow popupWindow;
	private static Dialog dialog;
	
	public static void showEditAdd(Context context,int viewId){
		LayoutInflater inflater=LayoutInflater.from(context);
		LinearLayout linear=(LinearLayout) inflater.inflate(viewId,null);
		
		final Dialog dialog =new AlertDialog.Builder(context).create();
		dialog.show();
		dialog.getWindow().setContentView(linear);
	}
	
	public static Dialog showEditAdd(Context context,View dialogView){
		Dialog dialog=new Dialog(context,R.style.Translucent_Notitle);
		final EditText editAdd=(EditText) dialogView.findViewById(R.id.eidt);
		Window window = dialog.getWindow();
        window.setGravity(Gravity.CENTER);
        WindowManager.LayoutParams layoutParams = window.getAttributes();
        ViewGroup.LayoutParams params=new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
        window.setAttributes(layoutParams);
        dialog.setContentView(dialogView,params);
        return dialog;
	}
	
	
	public static Dialog showCenterDialog(Context context,View dialogView){
        dialog = new Dialog(context, R.style.Translucent_Notitle);// ui样式
        Window window = dialog.getWindow();
        window.setGravity(Gravity.CENTER);// window位置
        // ViewGroup.LayoutParams.MATCH_PARENT 只能拿到view的最大宽高
        ViewGroup.LayoutParams vLayoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        dialog.setContentView(dialogView, vLayoutParams);
        dialog.show();
        return dialog;
    }
	 
//	public static void hideSoftKeyBroad(Context context, EditText view) {
//	        Logger.i("----->","隐藏软键盘");
//	        InputMethodManager imm = (InputMethodManager) context
//	                .getSystemService(Context.INPUT_METHOD_SERVICE);
//	        if (view != null) {
//	            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
//	        }
//	    }
//
//	    /**
//	     * 显示软键盘
//	     */
//	    public static void showSoftKeyBroad(Context context, EditText view) {
//	        InputMethodManager imm = (InputMethodManager) context
//	                .getSystemService(Context.INPUT_METHOD_SERVICE);
//	        if (view != null) {
//	            imm.showSoftInput(view, 0);
//	        }
//	    }
	
	public static void popupWindowShow(Context context,View dropView,View contentView){
		popupWindow = new  PopupWindow(context);
		popupWindow.setContentView(contentView);
		popupWindow.setWidth(LayoutParams.WRAP_CONTENT);
		popupWindow.setHeight(LayoutParams.WRAP_CONTENT);
		popupWindow.setOutsideTouchable(true);
		popupWindow.setFocusable(true);
		popupWindow.showAsDropDown(dropView);
	}
	
	public static boolean popupIsShow(){
		if(popupWindow!=null&&popupWindow.isShowing()){
			return true;
		}
		return false;
	}
	
	public static void popupClose(){
		if(popupWindow!=null&&popupWindow.isShowing()){
			popupWindow.dismiss();
		}
	}
	
	public static void dialogClose(){
		if(dialog!=null&&dialog.isShowing()){
			dialog.dismiss();
		}
		return;
	}
}
