package com.rpi.mobile;

import android.os.Bundle;

public class SettingsActivity extends RPIActivity {
	public void onCreate(Bundle savedInstance){
		super.onCreate(savedInstance);
		setContentView(R.layout.baselayout);
		super.setUpButtons();
	}
}
