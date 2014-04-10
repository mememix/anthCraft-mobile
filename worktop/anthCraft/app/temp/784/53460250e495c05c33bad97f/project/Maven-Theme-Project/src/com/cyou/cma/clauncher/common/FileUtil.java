package com.cyou.cma.clauncher.common;

import java.io.File;
import java.io.IOException;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.text.TextUtils;

public class FileUtil {
	
	/**
	 * check the given filePath contains a complete file
	 * 
	 * @param filePath
	 * @param fileSize
	 * @return
	 */
	public static boolean contains(String filePath, String md5) {
		if (TextUtils.isEmpty(filePath)) {
			return false;
		}
		String existMd5 = MD5.md5sum(filePath);
		return md5.equals(existMd5);
	}
	
	/**
	 * check pkg versionCode
	 * 
	 * @param context
	 * @param pkgName
	 * @return 0: package not exist
	 */
	public static int getPkgVersion(Context context, String pkgName) {
		final PackageManager packageManager = context.getPackageManager();
		int versionCode = 0;
		PackageInfo pInfo;
		try {
			pInfo = packageManager.getPackageInfo(pkgName,
					PackageManager.COMPONENT_ENABLED_STATE_DEFAULT);
			if (pInfo != null) {
				versionCode = pInfo.versionCode;
			}
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		return versionCode;
	}
	
	/**
	 * check the current apk whether need update
	 * 
	 * @param context
	 * @param version
	 * @return
	 */
	public static boolean needUpdate(Context context, int version) {
		PropertyParser parser = new PropertyParser(context);
		parser.load("customize_theme.properties");
		String minVersion = parser.get("clauncher_version");
		return Integer.valueOf(minVersion) > version;
	}
	
	/**
	 * change the file mode
	 * 
	 * @param mode
	 * @param filePath
	 * @return
	 */
	public static boolean chmod(String mode, String filePath) {
		int status = -1;
		try {
			Process p = Runtime.getRuntime().exec("chmod " + mode + " " + filePath);
			status = p.waitFor();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return status == 0;
	}
	
	/**
	 * check the file whether in modifying
	 * 
	 * @param filePath
	 * @return
	 */
	public static boolean isModifying(String filePath) {
		if (TextUtils.isEmpty(filePath)) {
			return false;
		}
		long interval = 2000L;
		File file = new File(filePath);
		boolean modify = false;
		if (file.exists()) {
			long curTime = System.currentTimeMillis();
			long lasTime = file.lastModified();
			if (lasTime + interval > curTime) {
				modify = true;
			}
		}
		return modify;
	}

}
