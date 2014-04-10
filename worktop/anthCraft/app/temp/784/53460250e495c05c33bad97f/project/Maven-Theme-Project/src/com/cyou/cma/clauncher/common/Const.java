package com.cyou.cma.clauncher.common;

public class Const {
	// Package Name of CLauncher
	public static final String CLAUNCHER_PKG_NAME = "com.cyou.cma.clauncher";

	// Minimum require Android-SDK VersionCode for CLauncher
	public static final int MINIMUM_SDK_VERSION_CODE = 15; // ANDROID-4.0.3-4.0.4

	// server url
	public static final String CLAUNCHER_SERVER_API_URL = "http://api.c-launcher.com/client/apk/get.do";

	// Download Directory
	public static final String DOWNLOAD_STORAGE_DIR = "apps";

	// Download Status
	public static final int DOWNLOAD_IDLE = -1;
	public static final int DOWNLOAD_SUCCESS = 0;
	public static final int DOWNLOAD_FAIL = 1;
	public static final int DOWNLOAD_PROGRESS = 2;
	public static final int DOWNLOAD_START = 3;
	public static final int DOWNLOAD_CONNECTION_FAIL = 4;
	public static final int DOWNLOAD_CANCLE = 5;

	// Broadcast Intent Fileter
	public static final String ACTION_CHECK_VERSION_CALLBACK = "cyou.cma.clauncher.theme.callback";
	public static final String ACTION_APPLY_THEME_REQUEST_ACTIVE = "cyou.cma.clauncher.theme.apply.active";
	public static final String ACTION_APPLY_THEME_RESULT = "cyou.cma.clauncher.theme.apply.result";

	// Notification ID
	public static final int DOWNLOAD_CLAUNCHER_NOTIFYID = 0x7858; // refer to CLauncher 0x7857

}
