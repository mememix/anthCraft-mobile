package com.cyou.cma.clauncher.theme;

import com.cyou.cma.clauncher.common.Const;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.widget.Toast;

public class ThemeApplyBroadcastReceiver extends BroadcastReceiver {

	private final Handler mHandler;

	public ThemeApplyBroadcastReceiver(Handler handler) {
		mHandler = handler;
	}

	@Override
	public void onReceive(final Context context, final Intent intent) {
		final boolean success = intent.getBooleanExtra("status", false);
		mHandler.post(new Runnable() {

			@Override
			public void run() {
				if (success) {
					Toast.makeText(context, "Apply theme succeed",
							Toast.LENGTH_LONG).show();
					// call CLauncher to start up
					Intent redirectIntent = new Intent(Intent.ACTION_MAIN);
					redirectIntent.addCategory(Intent.CATEGORY_LAUNCHER);
					redirectIntent.setPackage(Const.CLAUNCHER_PKG_NAME);
					redirectIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK
							| Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
					context.startActivity(redirectIntent);
				} else {
					Toast.makeText(context, "Apply theme failed",
							Toast.LENGTH_LONG).show();
				}
			}
		});
	}
}
