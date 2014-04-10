package com.cyou.cma.clauncher.theme;

import java.util.ArrayList;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

public class PreviewPagerAdapter extends FragmentPagerAdapter {

	private ArrayList<Fragment> fragments;

	public PreviewPagerAdapter(FragmentManager fm,
			ArrayList<Fragment> fragmentsList) {
		super(fm);
		fragments = fragmentsList;
	}

	public PreviewPagerAdapter(FragmentManager fm) {
		super(fm);
	}

	@Override
	public int getCount() {
		return fragments.size();
	}

	@Override
	public Fragment getItem(int position) {
		return fragments.get(position);
	}

	@Override
	public int getItemPosition(Object object) {
		return super.getItemPosition(object);
	}
}
