package com.rpi.mobile;

import android.os.Bundle;
import android.view.Menu;

public class NewsActivity extends RPIActivity {

	@Override
	public void onCreate(Bundle savedInstance){
		super.onCreate(savedInstance);
		setContentView(R.layout.baselayout);
		super.setUpButtons();
		
		
		
	}
	
	@Override
    public boolean onCreateOptionsMenu(Menu menu) {
        //getMenuInflater().inflate(R.menu.activity_main_navigation, menu);
        return true;
    }
}
