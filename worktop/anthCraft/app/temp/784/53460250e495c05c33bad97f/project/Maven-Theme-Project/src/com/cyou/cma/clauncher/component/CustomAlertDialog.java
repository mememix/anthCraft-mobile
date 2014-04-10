package com.cyou.cma.clauncher.component;

import com.cyou.cma.clauncher.theme.R;

import android.app.Dialog;
import android.content.Context;
import android.widget.Button;
import android.widget.TextView;

public class CustomAlertDialog extends Dialog {

	private Context mContext;
	private static CustomAlertDialog mAlertDialog = null;

	public CustomAlertDialog(Context context) {
		super(context);
		mContext = context;
	}

	public CustomAlertDialog(Context context, int theme) {
		super(context, theme);
		mContext = context;
	}

	public static CustomAlertDialog create(Context context) {
		mAlertDialog = new CustomAlertDialog(context, R.style.Common_Cma_Dialog);
		mAlertDialog.setContentView(R.layout.custom_alert_dialog);
		// mAlertDialog.setCancelable(false);
		return mAlertDialog;
	}

	public void setMessage(String msg) {
		TextView tv = (TextView) mAlertDialog
				.findViewById(R.id.alert_dialog_message);
		tv.setText(msg);
	}

	public void setMessage(int resId) {
		String msg = mContext.getString(resId);
		setMessage(msg);
	}

	public void setTitle(String title) {
		TextView tv = (TextView) mAlertDialog
				.findViewById(R.id.alert_dialog_title);
		tv.setText(title);
	}

	public void setTitle(int resId) {
		String title = mContext.getString(resId);
		setTitle(title);
	}

	public void setOnCancleClick(android.view.View.OnClickListener clickListener) {
		Button cancleBtn = (Button) mAlertDialog
				.findViewById(R.id.dialog_cancle);
		cancleBtn.setOnClickListener(clickListener);
	}

	public void setOnConfirmClick(
			android.view.View.OnClickListener clickListener) {
		Button confirmBtn = (Button) mAlertDialog
				.findViewById(R.id.dialog_confirm);
		confirmBtn.setOnClickListener(clickListener);
	}
}
