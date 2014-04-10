package com.cyou.cma.clauncher.common;

import java.io.File;
import java.util.List;

import android.app.ActivityManager;
import android.app.ActivityManager.RunningTaskInfo;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Environment;
import android.util.DisplayMetrics;

public final class Util {

	/**
	 * check task active status
	 * 
	 * @param context
	 * @param pkgName
	 * @return
	 */
	public static boolean isApplicationTaskRunning(Context context,
			String pkgName) {
		ActivityManager am = (ActivityManager) context
				.getSystemService(Context.ACTIVITY_SERVICE);
		List<RunningTaskInfo> appTask = am.getRunningTasks(Integer.MAX_VALUE);
		for (RunningTaskInfo runningTaskInfo : appTask) {
			if (runningTaskInfo.baseActivity.getPackageName().equalsIgnoreCase(
					pkgName)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * check sdcard available
	 * 
	 * @return
	 */
	public static boolean isExternalStorageWritable() {
		String state = android.os.Environment.getExternalStorageState();
		if (android.os.Environment.MEDIA_MOUNTED.equals(state)
				&& android.os.Environment.getExternalStorageDirectory()
						.canWrite()) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * check network available
	 * 
	 * @param context
	 * @return
	 */
	public static boolean isNetworkAvailable(Context context) {
		ConnectivityManager connectivity = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		if (connectivity == null) {
			return false;
		} else {
			NetworkInfo[] info = connectivity.getAllNetworkInfo();
			if (info != null) {
				for (NetworkInfo element : info) {
					if (element.getState() == NetworkInfo.State.CONNECTED) {
						return true;
					}
				}
			}
		}
		return false;
	}

	/**
	 * make file on the storage space
	 * 
	 * @param context
	 * @param relativePath
	 * @param filename
	 * @return filePath: Absolute Path
	 */
	public static String formatStoragePath(Context context,
			String relativePath, String filename) {
		
		File fileDir;
		boolean sdCardAvailable = isExternalStorageWritable();
		if (sdCardAvailable) {
			// external storage space
			fileDir = new File(Environment.getExternalStorageDirectory()
					.getPath() + File.separator + relativePath);
		} else {
			// internal storage space
			fileDir = context.getDir(relativePath, Context.MODE_PRIVATE);
		}
		
		String filePath = null;
		if (fileDir.isDirectory() || fileDir.mkdirs()) {
			filePath = fileDir.getPath() + File.separator + filename;
		}
		return filePath;
	}

	/**
	 * fetch an installed application's uid
	 * 
	 * @param context
	 * @param pkgName
	 * @return
	 */
	public static int getInstalledAppUid(Context context, String pkgName) {
		final PackageManager pm = context.getPackageManager();
		List<ApplicationInfo> pkgs = pm
				.getInstalledApplications(PackageManager.GET_META_DATA);
		int uid = 0;
		for (ApplicationInfo packageInfo : pkgs) {
			if (packageInfo.packageName.equals(pkgName)) {
				// get the uid for the pkgname
				uid = packageInfo.uid;
			}
		}
		return uid;
	}

	/**
	 * get the device's density dpi.
	 * 
	 * @param context
	 * @return
	 */
	public static int getDeviceDpi(Context context) {
		DisplayMetrics dm = new DisplayMetrics();
		dm = context.getResources().getDisplayMetrics();
		return dm.densityDpi;
	}

	/**
	 * get the device's window width.
	 * 
	 * @param context
	 * @return
	 */
	public static int getDeviceWidth(Context context) {
		DisplayMetrics dm = new DisplayMetrics();
		dm = context.getResources().getDisplayMetrics();
		return dm.widthPixels;
	}

}
