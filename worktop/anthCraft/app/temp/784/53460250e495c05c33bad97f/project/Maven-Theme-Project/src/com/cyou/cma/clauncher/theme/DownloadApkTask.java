package com.cyou.cma.clauncher.theme;

import java.io.Closeable;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import com.cyou.cma.clauncher.common.Const;

import android.os.AsyncTask;

public class DownloadApkTask extends AsyncTask<URL, Integer, Integer> {

	private final String mApkPath;
	private int mStatus;
	private final int INTERVAL = 1000; // update UI interval 1000ms
	private final int BUFFER_SIZE = 10 * 1024; // buffer size for readStream

	public DownloadApkTask(String apkPath) {
		super();
		mApkPath = apkPath;
	}

	@Override
	protected Integer doInBackground(URL... urls) {
		URL url = urls[0];
		int progress = 0;
		FileOutputStream fos = null;
		InputStream is = null;

		mStatus = Const.DOWNLOAD_START;

		try {
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.connect();
			if (conn.getResponseCode() != 200) {
				return Const.DOWNLOAD_CONNECTION_FAIL;
			}

			// get some content from network
			int totalSize = conn.getContentLength();
			int currentSize = 0;
			is = conn.getInputStream();

			// local file
			fos = new FileOutputStream(mApkPath);

			// start to download
			byte buf[] = new byte[BUFFER_SIZE];
			long currentTime = System.currentTimeMillis();
			mStatus = Const.DOWNLOAD_PROGRESS;
			while (!isCancelled()) {
				int numread = is.read(buf);
				if (numread < 0) {
					break;
				}
				fos.write(buf, 0, numread);
				currentSize += numread;
				if (System.currentTimeMillis() - currentTime > INTERVAL) {
					currentTime = System.currentTimeMillis();
					progress = currentSize * 100 / totalSize;
					publishProgress(progress);
				}
			}

			// check download success
			if (currentSize == totalSize) {
				publishProgress(100);
				mStatus = Const.DOWNLOAD_SUCCESS;
			} else {
				mStatus = Const.DOWNLOAD_FAIL;
			}
		} catch (Exception e) {
			mStatus = Const.DOWNLOAD_FAIL;
		} finally {
			closeStream(fos);
			closeStream(is);
		}

		return mStatus;
	}

	/**
	 * close stream
	 * @param stream
	 */
	private void closeStream(Closeable stream) {
		if (stream == null)
			return;
		try {
			stream.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
