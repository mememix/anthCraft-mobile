package com.cyou.cma.clauncher.theme;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.res.AssetManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.NotificationCompat;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.cyou.cma.clauncher.common.Const;
import com.cyou.cma.clauncher.common.PropertyParser;
import com.cyou.cma.clauncher.common.Util;
import com.cyou.cma.clauncher.common.FileUtil;
import com.cyou.cma.clauncher.component.CustomAlertDialog;

public class ThemePreviewActivity extends FragmentActivity {

	private static final long BUTTON_PRESS_INTERVAL = 5000; // press button
															// interval: 5s
	private static final long DOWNLOAD_LOCK_TIME = 60 * 1000; // lock time:
																// 1min
	private ViewPager mPager;
	private PagerAdapter mPagerAdapter;
	private ProgressBar mProgressBar;
	private Button mDownloadBtn;
	private NotificationManager mNotificationManager;
	private NotificationCompat.Builder mBuilder;

	private ThemeInfo mThemeInfo;
	private String[] mPreviewImages;
	private int mDownloadStatus;
	private CustomAlertDialog mAlertDialog;
	private DownloadApkTask mDownloadTask;
	private ThemeApplyBroadcastReceiver mThemeApplayBR;
	private VersionCheckBroadcastReceiver mVersionCheckBR;
	private long mLastClickTime;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.theme_preview_activity);
		mDownloadBtn = (Button) findViewById(R.id.download_btn);
		mProgressBar = (ProgressBar) findViewById(R.id.download_progress_bar);
		mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
		mBuilder = new NotificationCompat.Builder(getApplicationContext());
		initThemeInfo();
		initTopBar();
		initialViewPager();
	}

	@Override
	protected void onResume() {
		super.onResume();
		mLastClickTime = 0;
		registerThemeApplyBroadcast();
		registerVersionCheckBroadcast();
	}

	@Override
	protected void onPause() {
		if (mVersionCheckBR != null) {
			unregisterReceiver(mVersionCheckBR);
		}
		if (mThemeApplayBR != null) {
			unregisterReceiver(mThemeApplayBR);
		}
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
	}

	private void registerThemeApplyBroadcast() {
		mThemeApplayBR = new ThemeApplyBroadcastReceiver(new Handler(
				Looper.getMainLooper()));
		IntentFilter filter = new IntentFilter();
		filter.addAction(Const.ACTION_APPLY_THEME_RESULT);
		registerReceiver(mThemeApplayBR, filter);
	}

	private void registerVersionCheckBroadcast() {
		mVersionCheckBR = new VersionCheckBroadcastReceiver();
		IntentFilter filter = new IntentFilter();
		filter.addAction(Const.ACTION_CHECK_VERSION_CALLBACK);
		registerReceiver(mVersionCheckBR, filter);
	}

	/**
	 * initialize theme information
	 */
	private void initThemeInfo() {
		PropertyParser parser = new PropertyParser(getApplicationContext());
		parser.load("customize_theme.properties");
		mThemeInfo = new ThemeInfo();
		mThemeInfo.title = parser.get("title");
		mThemeInfo.author = parser.get("author");
		mThemeInfo.category = parser.get("category");
		mThemeInfo.description = parser.get("description");
		mThemeInfo.date = parser.get("date");
		mThemeInfo.version = parser.get("version_code");
	}

	/**
	 * initialize some customize theme's meta
	 */
	private void initTopBar() {
		TextView title = (TextView) findViewById(R.id.theme_title);
		TextView author = (TextView) findViewById(R.id.theme_author);
		title.setText(mThemeInfo.title);
		author.setText(mThemeInfo.author);
	}

	/**
	 * initialize the ViewPager and create the PagerAdapter.
	 */
	private void initialViewPager() {
		mPager = (ViewPager) findViewById(R.id.view_pager);
		ArrayList<Fragment> fragments = new ArrayList<Fragment>();
		AssetManager am = getAssets();
		try {
			mPreviewImages = am.list("preview");
		} catch (IOException e) {
			e.printStackTrace();
		}
		int pageNum = mPreviewImages.length;
		formatFragment(fragments);
		mPagerAdapter = new PreviewPagerAdapter(getSupportFragmentManager(),
				fragments);
		mPager.setAdapter(mPagerAdapter);
		mPager.setCurrentItem(pageNum / 2);
	}

	private void formatFragment(List<Fragment> fragments) {
		for (String previewImage : mPreviewImages) {
			Bundle bundle = new Bundle();
			bundle.putString("type", "image");
			bundle.putString("filepath", "preview" + File.separator + previewImage);
			fragments.add(PreviewFragment.newInstance(this, bundle));
		}
	}

	/**
	 * onClisk apply button method
	 * 
	 * @param view
	 */
	public void onClick_Apply(View view) {
		// check user's mobile android system version
		if (Integer.parseInt(android.os.Build.VERSION.SDK) < Const.MINIMUM_SDK_VERSION_CODE) {
			String text = getString(R.string.system_version_tip);
			Toast.makeText(getApplicationContext(), text, Toast.LENGTH_LONG)
					.show();
			return;
		}

		// detect user's device: Pad or Phone
		boolean pad = getResources().getBoolean(R.bool.detect_pad);
		if (pad) {
			String text = getString(R.string.device_pad_tip);
			Toast.makeText(getApplicationContext(), text, Toast.LENGTH_LONG)
					.show();
			return;
		}

		// if download hasn't in progress then start
		SharedPreferences sPref = getSharedPreferences("Download-Task",
				Context.MODE_PRIVATE);
		mDownloadStatus = sPref.getInt("status", mDownloadStatus);
		long updateInterval = System.currentTimeMillis()
				- sPref.getLong("update_time", 0);
		if ((mDownloadStatus == Const.DOWNLOAD_START || mDownloadStatus == Const.DOWNLOAD_PROGRESS)
				&& updateInterval < DOWNLOAD_LOCK_TIME) {
			String text = getString(R.string.downolad_in_progress_tip);
			Toast.makeText(getApplicationContext(), text, Toast.LENGTH_LONG)
					.show();
			return;
		}

		if (mLastClickTime <= 0) {
			mLastClickTime = System.currentTimeMillis();
		} else {
			if (mLastClickTime + BUTTON_PRESS_INTERVAL > System
					.currentTimeMillis()) {
				String text = getString(R.string.try_again_later_tip);
				Toast.makeText(getApplicationContext(), text, Toast.LENGTH_LONG)
						.show();
				return;
			} else {
				mLastClickTime = System.currentTimeMillis();
			}
		}

		int versionCode = FileUtil.getPkgVersion(getApplicationContext(),
				Const.CLAUNCHER_PKG_NAME);
		boolean needUpdate = FileUtil.needUpdate(getApplicationContext(),
				versionCode);
		if (needUpdate) {
			String title = "CLauncher Tips";
			int msgResId = versionCode < 0 ? R.string.dialog_download_tip
					: R.string.dialog_update_tip;
			String msg = getString(msgResId);
			showCustomDialog(title, msg, versionCode);
		} else {
			boolean running = Util.isApplicationTaskRunning(
					getApplicationContext(), Const.CLAUNCHER_PKG_NAME);
			Intent intent = new Intent();
			String pkgName = getPackageName();
			String zipFile = Util.getDeviceDpi(getApplicationContext())
					+ ".amr";
			intent.putExtra("package", pkgName);
			intent.putExtra("filename", zipFile);
			intent.putExtra("property", "customize_theme.properties");
			intent.putExtra("preview", mPreviewImages);
			intent.setPackage(Const.CLAUNCHER_PKG_NAME);
			intent.setAction(Const.ACTION_APPLY_THEME_REQUEST_ACTIVE);
			if (running) {
				sendBroadcast(intent);
			} else {
				// send sticky broadcast before start up CLauncher
				sendStickyBroadcast(intent);

				// start up CLauncher
				Intent redirectIntent = new Intent(Intent.ACTION_MAIN);
				redirectIntent.addCategory(Intent.CATEGORY_LAUNCHER);
				redirectIntent.setPackage(Const.CLAUNCHER_PKG_NAME);
				redirectIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK
						| Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
				startActivity(redirectIntent);
			}
		}
	}

	/**
	 * Show custom dialog
	 */
	private void showCustomDialog(String title, String msg,
			final int versionCode) {
		mAlertDialog = CustomAlertDialog.create(ThemePreviewActivity.this);
		// set dialog width to be 90% of the device width
		int deviceWidth = Util.getDeviceWidth(getApplicationContext());
		Window dialogWindow = mAlertDialog.getWindow();
		WindowManager.LayoutParams lp = dialogWindow.getAttributes();
		lp.width = (int) (deviceWidth * 0.9);
		dialogWindow.setAttributes(lp);

		mAlertDialog.setTitle(title);
		mAlertDialog.setMessage(msg);
		mAlertDialog.setOnCancleClick(new OnClickListener() {
			public void onClick(View v) {
				mAlertDialog.dismiss();
			}
		});
		mAlertDialog.setOnConfirmClick(new OnClickListener() {
			public void onClick(View v) {
				mAlertDialog.dismiss();
				checkApkVersion(versionCode);
			}
		});

		mAlertDialog.show();
	}

	/**
	 * callback form IntentService with BroadcastReceiver
	 * 
	 * @author Connor
	 */
	private class VersionCheckBroadcastReceiver extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			int httpStatusCode = intent.getIntExtra("http_status_code", 0);
			if (httpStatusCode / 100 == 2) {
				String downloadUrl = intent.getStringExtra("download_url");
				String md5 = intent.getStringExtra("md5");
				String fileName = downloadUrl.substring(downloadUrl
						.lastIndexOf('/') + 1);
				String filePath = Util.formatStoragePath(
						getApplicationContext(), Const.DOWNLOAD_STORAGE_DIR,
						fileName);
				if (TextUtils.isEmpty(filePath)) {
					String text = getString(R.string.create_file_failure);
					Toast.makeText(getApplicationContext(), text,
							Toast.LENGTH_LONG).show();
				} else {
					File file = new File(filePath);
					if (file.exists()) {
						if (FileUtil.contains(filePath, md5)) {
							installApk(filePath);
						} else {
							if (FileUtil.isModifying(filePath)) {
								return;
							} else {
								file.delete();
							}
						}
					} else {
						try {
							file.createNewFile();
						} catch (IOException e) {
							e.printStackTrace();
							return;
						}
						if (!Util.isExternalStorageWritable()) {
							FileUtil.chmod("666", filePath); // internal storage
																// space
						}
						startDownloadApk(downloadUrl, filePath);
					}
				}
			} else {
				String exception = intent.getStringExtra("http_exception");
				Toast.makeText(getApplicationContext(), exception,
						Toast.LENGTH_LONG).show();
			}
		}
	}

	/**
	 * download CLauncher with the fetched downloadUrl
	 * 
	 * @param downloadUrl
	 */
	private void startDownloadApk(String downloadUrl, final String filePath) {
		if (!TextUtils.isEmpty(downloadUrl)) {
			mDownloadTask = new DownloadApkTask(filePath) {
				@Override
				protected Integer doInBackground(URL... urls) {
					mDownloadStatus = Const.DOWNLOAD_PROGRESS;
					return super.doInBackground(urls);
				}

				@Override
				protected void onPreExecute() {
					super.onPreExecute();
					mDownloadBtn.setVisibility(View.GONE);
					mProgressBar.setVisibility(View.VISIBLE);
					mProgressBar.setProgress(0);
					mDownloadStatus = Const.DOWNLOAD_START;
					mBuilder = new NotificationCompat.Builder(
							ThemePreviewActivity.this)
							.setSmallIcon(R.drawable.ic_launcher_home)
							.setContentTitle("Download CLauncher")
							.setContentText("Download in progress 0%");
					mBuilder.setAutoCancel(true);
					SharedPreferences spref = getSharedPreferences(
							"Download-Task", Context.MODE_PRIVATE);
					Editor editor = spref.edit();
					editor.putInt("status", mDownloadStatus);
					editor.putLong("update_time", System.currentTimeMillis());
					editor.commit();
				}

				@Override
				protected void onProgressUpdate(Integer... progress) {
					super.onProgressUpdate(progress);
					mProgressBar.setProgress(progress[0]);
					mBuilder.setProgress(100, progress[0], false);
					mBuilder.setContentText("Download in progress "
							+ progress[0] + "%");
					mNotificationManager
							.notify(Const.DOWNLOAD_CLAUNCHER_NOTIFYID,
									mBuilder.build());
				}

				@Override
				protected void onPostExecute(Integer status) {
					super.onPostExecute(status);
					mDownloadBtn.setVisibility(View.VISIBLE);
					mProgressBar.setVisibility(View.GONE);
					mNotificationManager
							.cancel(Const.DOWNLOAD_CLAUNCHER_NOTIFYID);
					if (status == Const.DOWNLOAD_SUCCESS) {
						mDownloadStatus = Const.DOWNLOAD_SUCCESS;
						mDownloadBtn.setText(R.string.apply_theme);
						installApk(filePath);
					} else {
						mDownloadStatus = Const.DOWNLOAD_FAIL;
						String text = null;
						switch (status) {
						case Const.DOWNLOAD_CONNECTION_FAIL:
							text = getString(R.string.http_request_failure);
							break;
						case Const.DOWNLOAD_FAIL:
							text = getString(R.string.download_failure);
							break;
						case Const.DOWNLOAD_PROGRESS:
							text = getString(R.string.download_exception);
							break;
						default:
							break;
						}
						Toast.makeText(getApplicationContext(), text,
								Toast.LENGTH_LONG).show();
					}
					SharedPreferences spref = getSharedPreferences(
							"Download-Task", Context.MODE_PRIVATE);
					Editor editor = spref.edit();
					editor.putInt("status", mDownloadStatus);
					editor.commit();
				}

				@Override
				protected void onCancelled() {
					super.onCancelled();
					mDownloadStatus = Const.DOWNLOAD_CANCLE;
					SharedPreferences spref = getSharedPreferences(
							"Download-Task", Context.MODE_PRIVATE);
					Editor editor = spref.edit();
					editor.putInt("status", mDownloadStatus);
					editor.commit();
				}
			};

			URL apkHttpGetUrl = null;
			try {
				apkHttpGetUrl = new URL(downloadUrl);
			} catch (MalformedURLException e) {
				e.printStackTrace();
			}
			mDownloadTask.execute(apkHttpGetUrl);
		}
	}

	/**
	 * Get apk download url
	 */
	private void checkApkVersion(int version) {
		if (!Util.isNetworkAvailable(getApplicationContext())) {
			String text = getString(R.string.newtwork_unavailable_tip);
			Toast.makeText(getApplicationContext(), text, Toast.LENGTH_LONG)
					.show();
			return;
		}

		Intent serviceIntent = new Intent(ThemePreviewActivity.this,
				VersionCheckService.class);
		Bundle extras = new Bundle();
		extras.putInt("version", version);
		extras.putString("apkType", "CLauncher");
		extras.putString("channel", "10002");
		serviceIntent.putExtras(extras);
		startService(serviceIntent);
	}

	/**
	 * @param apkFile
	 */
	private void installApk(String filePath) {
		Intent intent = new Intent();
		intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.setAction(Intent.ACTION_VIEW);
		String type = "application/vnd.android.package-archive";
		intent.setDataAndType(Uri.parse("file://" + filePath), type);
		startActivity(intent);
	}

}
