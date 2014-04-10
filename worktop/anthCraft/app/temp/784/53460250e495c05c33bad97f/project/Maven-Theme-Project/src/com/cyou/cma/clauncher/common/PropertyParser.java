package com.cyou.cma.clauncher.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import android.content.Context;

public class PropertyParser {

	private final Properties mProp;
	private final Context mContext;
	
	public PropertyParser(Context context) {
		mContext = context;
		mProp = new Properties();
	}
	
	/**
	 * load properties from assets/${path}
	 * @param path
	 */
	public void load(String path) {
		try {
			InputStream in = mContext.getAssets().open(path);
			mProp.load(in);
			in.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * load properties from file.
	 */
	public void load(File file) {
		try {
			FileInputStream in = new FileInputStream(file);
			mProp.load(in);
			in.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 
	 * @param key
	 * @return value
	 */
	public String get(String key) {
		return mProp.getProperty(key);
	}
	
	/**
	 * 
	 * @param key
	 * @param value
	 */
	public void put(String key, String value) {
		mProp.put(key, value);
	}

}
