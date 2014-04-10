package com.cyou.cma.clauncher.theme;

import java.io.UnsupportedEncodingException;

import org.json.JSONException;
import org.json.JSONObject;

import com.cyou.cma.clauncher.common.Const;
import com.cyou.cma.clauncher.net.CHttpClient;
import com.cyou.cma.clauncher.net.Request;
import com.cyou.cma.clauncher.net.Response;

import android.app.IntentService;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;

public class VersionCheckService extends IntentService  {
	
	private Request mRequest;

	public VersionCheckService() {
		this("VersionCheckService");
	}
	
	public VersionCheckService(String name) {
		super(name);
	}

	@Override
	protected void onHandleIntent(Intent intent) {
		String httpUrl = Const.CLAUNCHER_SERVER_API_URL;
		Bundle params = intent.getExtras();
		mRequest = new Request(Request.Method.GET, httpUrl);
		for (String key : params.keySet()) {
			mRequest.param(key, params.get(key));
		}
		
		CHttpClient cHttpClient = new CHttpClient();
		Response response = cHttpClient.get(mRequest);
		String downloadUrl = null;
		String md5Str = "";
		String exception = "";
		int statusCode = 0;
		if (response != null && response.status > 0) {
			statusCode = response.status;
		}
		
		// request status code
		if (statusCode / 100 == 2) {
			try {
				String responseBody = new String(response.body, "UTF-8");
				JSONObject obj = new JSONObject(responseBody);
				JSONObject data = obj.optJSONObject("data");
				int code = data.optInt("code");
				if (code == 100) {
					md5Str = data.optString("md5");
					downloadUrl = data.optString("url");
				} else {
					exception += "Response-Code: ";
					exception += code;
				}
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			} catch (JSONException e) {
				e.printStackTrace();
			}
		} else if (response != null) {
			{
				exception += "Http-Message: ";
				exception += response.message;
			}
		}
		
		Intent callback = new Intent();
		callback.setPackage(getPackageName());
		callback.setAction(Const.ACTION_CHECK_VERSION_CALLBACK);
		callback.putExtra("http_status_code", statusCode);
		if (TextUtils.isEmpty(downloadUrl)) {
			callback.putExtra("http_exception", exception);
		} else {
			callback.putExtra("md5", md5Str);
			callback.putExtra("download_url", downloadUrl);
		}
		// send broadcast to notify main thread to start download
		sendBroadcast(callback);
	}

}
