package pku.shengbin.utils;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;

/**
 * Utility class which show a message box to the user.
 */
public class MessageBox {

	public static void show(Context context, String title, String msg,
			DialogInterface.OnClickListener ok_listener) {
		new AlertDialog.Builder(context).setMessage(msg).setTitle(title)
				.setCancelable(false)
				.setPositiveButton(android.R.string.ok, ok_listener).show();
	}

	public static void show(Context context, String title, String msg) {
		new AlertDialog.Builder(context).setMessage(msg).setTitle(title)
				.setCancelable(false)
				.setPositiveButton(android.R.string.ok, null).show();
	}
}