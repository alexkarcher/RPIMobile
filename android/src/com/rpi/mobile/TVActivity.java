package com.rpi.mobile;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.widget.LinearLayout;
import android.widget.Toast;

public class TVActivity extends RPIActivity {
	
	LinearLayout container;
	
	@Override
	public void onCreate(Bundle savedInstance){
		super.onCreate(savedInstance);
		setContentView(R.layout.baselayout);
		super.setUpButtons();
		
		container = (LinearLayout) findViewById(R.id.contentContainer);
		
		
		LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		inflater.inflate(R.layout.tvlineup, container);
		
		JSONReciever lineupReciever = new JSONReciever();
		lineupReciever.execute("http://mobilerpi.jcmcmillan.com/v1/tv");
		
	}
	
	
	private void displayLineups(String json){
		Toast.makeText(getApplicationContext(), json, Toast.LENGTH_LONG).show();
	}
	
	//Used to get the channel line ups
	private class JSONReciever extends urlResponder {
		@Override
		protected void onPostExecute(String result){
			displayLineups(result);
		}
	}
	
	
	
}