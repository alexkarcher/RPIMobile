package com.rpi.mobile;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.graphics.Typeface;
import android.os.Bundle;
import android.view.ViewGroup.LayoutParams;
import android.widget.LinearLayout;
import android.widget.TextView;

public class LaundryActivity extends RPIActivity {
	public void onCreate(Bundle savedInstance){
		super.onCreate(savedInstance);
		setContentView(R.layout.baselayout);
		super.setUpButtons();
		
		System.out.println("before creation");
		LaundryInfo laundry = new LaundryInfo();
		System.out.println("after creation");
		laundry.container = (LinearLayout) findViewById(R.id.contentContainer);
		System.out.println("before start");
		laundry.execute("http://mobilerpi.jcmcmillan.com/v1/laundry");
	}
	
	
	
	public class LaundryInfo extends urlResponder {
		public LinearLayout container;
		
		public void onPreExecute(){
			//System.out.println("Starting pre");
			TextView loading = new TextView(container.getContext());
			loading.setText("Loading...");
			container.addView(loading);
		}
		
		
		public void onPostExecute(String result){
			
			System.out.println("Starting post");
			
			if(result == null){
				//Error display error message and quit
				TextView errorMessage = new TextView(container.getContext());
				errorMessage.setText(errorString);
				
				container.addView(errorMessage);
				
				return;
			}
			
			
			try{
				JSONArray roomArray = (JSONArray) (((JSONObject) new JSONTokener(result).nextValue()).getJSONArray("rooms"));
				container.removeAllViews();
				for(int i = 0; i < roomArray.length(); i++){
					TextView roomText = new TextView(getApplicationContext());
					LinearLayout ll = new LinearLayout(getApplicationContext());
					

					ll.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT));
					
					//Need layout params so that each section in 'table' of laundry machines is the same width
					LinearLayout.LayoutParams buttonParams = new LinearLayout.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT, 1.0f);
					
					TextView washersAvail = new TextView(getApplicationContext());
					TextView washersUsed = new TextView(getApplicationContext());
					TextView dryersAvail = new TextView(getApplicationContext());
					TextView dryersUsed= new TextView(getApplicationContext());
					washersAvail.setLayoutParams(buttonParams);
					washersUsed.setLayoutParams(buttonParams);
					dryersAvail.setLayoutParams(buttonParams);
					dryersUsed.setLayoutParams(buttonParams);
					
					JSONObject roomInfo = roomArray.getJSONObject(i);
					
					
					roomText.setText(roomInfo.getString("Room"));
					
					roomText.setTextColor(0xFF000000);
					roomText.setTypeface(Typeface.create((String) null, Typeface.BOLD));
					
					
					washersAvail.setText("Washers Available:\n" + roomInfo.getString("WashersAvailable"));
					washersUsed.setText("Washers In Use:\n" + roomInfo.getString("WashersInUse"));
					dryersAvail.setText("Dryers Available:\n" + roomInfo.getString("DryersAvailable"));
					dryersUsed.setText("Dryers In Use:\n" + roomInfo.getString("DryersInUse"));
					
					washersAvail.setTextColor(0xFF000000);
					washersUsed.setTextColor(0xFF000000);
					dryersAvail.setTextColor(0xFF000000);
					dryersUsed.setTextColor(0xFF000000);
					
					ll.addView(washersAvail);
					ll.addView(washersUsed);
					ll.addView(dryersAvail);
					ll.addView(dryersUsed);
					
					
					container.addView(roomText);
					container.addView(ll);
				}	
				
				
				
			}catch(JSONException e){
				//Error display error message and quit
				TextView errorMessage = new TextView(container.getContext());
				errorMessage.setText(errorString);
				container.removeAllViews();
				container.addView(errorMessage);
				
				return;
			}
			
		}
	}
		
}
