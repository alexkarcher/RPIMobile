package com.rpi.mobile;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.view.Display;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public abstract class RPIActivity extends Activity {
	
	protected boolean menuOpen = false;
	
	protected NewsHandler newsButtonHandler;
	protected AthleticsHandler athleticsButtonHandler;
	protected SettingsHandler settingsButtonHandler;
	protected WeatherHandler weatherButtonHandler;
	protected LaundryHandler laundryButtonHandler;
	protected TVHandler tvButtonHandler;
	protected DirectoryHandler directoryButtonHandler;
	protected Button newsButton;
	protected Button athleticsButton;
	protected Button settingsButton;
	protected Button weatherButton;
	protected Button laundryButton;
	protected Button tvButton;
	protected Button dirButton;
	public void setUpButtons(){
		newsButton = (Button) findViewById(R.id.newsButton);
        athleticsButton = (Button) findViewById(R.id.athleticsButton);
        settingsButton = (Button) findViewById(R.id.settingsButton);
        weatherButton = (Button) findViewById(R.id.weatherButton);
        laundryButton = (Button) findViewById(R.id.laundryButton);
        tvButton = (Button) findViewById(R.id.tvButton);
        dirButton = (Button) findViewById(R.id.directoryButton);
        newsButtonHandler = new NewsHandler();
        athleticsButtonHandler = new AthleticsHandler();
        settingsButtonHandler = new SettingsHandler();
        weatherButtonHandler = new WeatherHandler();
        laundryButtonHandler = new LaundryHandler();
        tvButtonHandler = new TVHandler();
        directoryButtonHandler = new DirectoryHandler(); 
        newsButton.setOnClickListener(newsButtonHandler);
        athleticsButton.setOnClickListener(athleticsButtonHandler);
        settingsButton.setOnClickListener(settingsButtonHandler);
        weatherButton.setOnClickListener(weatherButtonHandler);
        laundryButton.setOnClickListener(laundryButtonHandler);
        tvButton.setOnClickListener(tvButtonHandler);
        dirButton.setOnClickListener(directoryButtonHandler);
        newsButton.setEnabled(false);
        athleticsButton.setEnabled(false);
        settingsButton.setEnabled(false);
        weatherButton.setEnabled(false);
        laundryButton.setEnabled(false);
        tvButton.setEnabled(false);
        dirButton.setEnabled(false);
	}
	
	
	public void showMenuButton(View v){
    	View mainScreen = findViewById(R.id.mainLayout);
    	
    	
    	Display disp = getWindowManager().getDefaultDisplay();
        //Using deprecated methods because we are targeting for android version >= 2.2
        int width = disp.getWidth();
        //height = disp.getHeight();
        
        //Set up size constraints for animating the menu opener
        final int slideToX = (int) (.85 * width);
    	
    	
    	/*if(this.menuOpen == false){
	    	new CountDownTimer(1000, 20){
	    		View mainScreen = findViewById(R.id.mainLayout);
	    		int movementSpeed = slideToX/(1000/20);
	    		@Override
	    		public void onTick(long millitillfinished){
	    				int xpos = mainScreen.getScrollX();
	    				mainScreen.scrollTo(xpos - movementSpeed, 0);
	    		}
				@Override
				public void onFinish() {
						//Toast.makeText(getApplicationContext(), "test", Toast.LENGTH_SHORT).show();
				}
	    	}.start();
	    	this.menuOpen = true;
    	}else{
    		new CountDownTimer(1000, 20){
	    		View mainScreen = findViewById(R.id.mainLayout);
	    		int movementSpeed = slideToX/(1000/20);
	    		@Override
	    		public void onTick(long millitillfinished){
	    				int xpos = mainScreen.getScrollX();
	    				mainScreen.scrollTo(xpos + movementSpeed, 0);
	    		}
				@Override
				public void onFinish() {
						//Toast.makeText(getApplicationContext(), "test", Toast.LENGTH_SHORT).show();
				}
	    	}.start();
    		this.menuOpen = false;
    	}
    	
    	*/
    	
    	if(this.menuOpen == false){
			mainScreen.scrollTo( -slideToX, 0);
    		this.menuOpen = true;
    		newsButton.setEnabled(true);
            athleticsButton.setEnabled(true);
            settingsButton.setEnabled(true);
            weatherButton.setEnabled(true);
            laundryButton.setEnabled(true);
            tvButton.setEnabled(true);
            dirButton.setEnabled(true);
    	}else{
			mainScreen.scrollTo( 0, 0);
    		this.menuOpen = false;
    		newsButton.setEnabled(false);
            athleticsButton.setEnabled(false);
            settingsButton.setEnabled(false);
            weatherButton.setEnabled(false);
            laundryButton.setEnabled(false);
            tvButton.setEnabled(false);
            dirButton.setEnabled(false);
    	}
    }
	
	
	
	//Class must be sub classed in order to be used, specific on post execute must be defined
	protected abstract class urlResponder extends AsyncTask<String, Void, String> {
		String errorString;
		String responseString;
		
		@Override
		protected final String doInBackground(String... urlString) {
			try{
				//Will only ever be called with one string
				URL url;
				HttpURLConnection urlConnection;
				BufferedReader reader;
				url = new URL(urlString[0]);
				urlConnection = (HttpURLConnection) url.openConnection();
				
				//Not a fan of this reading method, probably cause I like C, found on stack overflow for quickly getting this running, look into input streams in java
				reader = new BufferedReader(new InputStreamReader(urlConnection.getInputStream()));
				StringBuilder full = new StringBuilder();
				String line;
				while ((line = reader.readLine()) != null) {
				    full.append(line);
				}
				responseString = full.toString();
				return responseString;
			}catch(MalformedURLException e){
				errorString = e.toString();
				return null;
			}catch(IOException e){
				errorString = e.toString();
				return null;
			}
		}
		
		
	}
	
	
	public class LaundryHandler implements View.OnClickListener {

		public void onClick(View v) {
			Intent weatherActivity = new Intent(v.getContext(), LaundryActivity.class);
			v.getContext().startActivity(weatherActivity);
		}
		
	}
	
	public class TVHandler implements View.OnClickListener {

		public void onClick(View v) {
			Intent tvActivity = new Intent(v.getContext(), TVActivity.class);
			v.getContext().startActivity(tvActivity);
		}
		
	}

	public class WeatherHandler implements View.OnClickListener {

		public void onClick(View v) {
			Intent weatherActivity = new Intent(v.getContext(), WeatherActivity.class);
			v.getContext().startActivity(weatherActivity);
		}
		
	}
	
	public class SettingsHandler implements View.OnClickListener {
		public void onClick(View v){
			Intent settingsActivity = new Intent(v.getContext(), SettingsActivity.class);
			v.getContext().startActivity(settingsActivity);
		}
	}

	public class NewsHandler implements OnClickListener {
		public NewsHandler(){
			
		}
		public void onClick(View v){
			Intent newsActivity = new Intent(v.getContext(), NewsActivity.class);
			v.getContext().startActivity(newsActivity);
		}
	}

	public class AthleticsHandler implements View.OnClickListener {
		public void onClick(View v){
			Intent athleticsActivity = new Intent(v.getContext(), AthleticsActivity.class);
			v.getContext().startActivity(athleticsActivity);
		}
	}
	
	public class DirectoryHandler implements View.OnClickListener {
		public void onClick(View v){
			Intent dirActivity = new Intent(v.getContext(), DirectoryActivity.class);
			v.getContext().startActivity(dirActivity);
		}
	}
}
