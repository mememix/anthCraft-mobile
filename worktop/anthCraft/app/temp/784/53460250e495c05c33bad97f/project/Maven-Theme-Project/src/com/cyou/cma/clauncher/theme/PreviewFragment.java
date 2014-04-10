package com.cyou.cma.clauncher.theme;

import java.io.IOException;
import java.io.InputStream;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.text.method.ScrollingMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

public class PreviewFragment extends Fragment {

	private Context mContext;
	
	private String mFragmentType; // "IMAGE" or "TEXT"
	private ThemeInfo mThemeInfo;
	private String mPreviewPath;

	static PreviewFragment newInstance(Context context, Bundle bundle) {
		PreviewFragment newFragment = new PreviewFragment();
		newFragment.setContext(context);
		newFragment.setArguments(bundle);
		return newFragment;
	}

	private void setContext(Context context) {
		mContext = context;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Bundle themeData = getArguments();
		mFragmentType = themeData.getString("type");
		if (mFragmentType.equalsIgnoreCase("IMAGE")) {
			mPreviewPath = themeData.getString("filepath");
		} else if (mFragmentType.equalsIgnoreCase("TEXT")) {
			mThemeInfo = new ThemeInfo();
			mThemeInfo.author = themeData.getString("author");
			mThemeInfo.category = themeData.getString("category");
			mThemeInfo.date = themeData.getString("date");
			mThemeInfo.description = themeData.getString("description");
		}
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		View frView = inflater.inflate(R.layout.preview_slide_page, container, false);
		ViewGroup prevImageGrp = (ViewGroup) frView.findViewById(R.id.preview_imageview);
		ViewGroup prevTextGrp = (ViewGroup) frView.findViewById(R.id.preview_textview);
		if (mFragmentType.equalsIgnoreCase("IMAGE")) {
			AssetManager am = mContext.getAssets();
			ImageView imgView = (ImageView) prevImageGrp.findViewById(R.id.preview_theme_image);
			Bitmap bm = null;
			try {
				InputStream in = am.open(mPreviewPath);
				bm = BitmapFactory.decodeStream(in);
			} catch (IOException e) {
				e.printStackTrace();
			}
			imgView.setImageBitmap(bm);
			prevImageGrp.setVisibility(View.VISIBLE);
			prevTextGrp.setVisibility(View.GONE);
		} else if (mFragmentType.equalsIgnoreCase("TEXT")) {
			TextView author = (TextView) prevTextGrp.findViewById(R.id.preview_theme_author);
			TextView category = (TextView) prevTextGrp.findViewById(R.id.preview_theme_category);
			TextView date = (TextView) prevTextGrp.findViewById(R.id.preview_theme_date);
			TextView desc = (TextView) prevTextGrp.findViewById(R.id.preview_theme_description);
			
			author.setText(mThemeInfo.author);
			category.setText(mThemeInfo.category);
			date.setText(mThemeInfo.date);
			desc.setText(mThemeInfo.description);
			desc.setMovementMethod(ScrollingMovementMethod.getInstance());
			
			prevImageGrp.setVisibility(View.GONE);
			prevTextGrp.setVisibility(View.VISIBLE);
		}
		
		return frView;
	}

}
