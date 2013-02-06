package com.rpi.mobile;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;


public class SportActivity extends RPIActivity {
	String humanReadable;
	String code;
	LinearLayout container;
	ImageGetter setImage = null;
	Boolean inWhat = false;
	
	
	final private int ROSTER = 0;
	final private int SCHEDULE = 1; 
	
	public void onCreate(Bundle savedInstance){
		super.onCreate(savedInstance);
		setContentView(R.layout.baselayout);
		super.setUpButtons();
		
		//Get the intent that launched this activity to get the information it sent
		Intent incomingIntent = getIntent();
		
		container = (LinearLayout) findViewById(R.id.contentContainer);
		
		
		humanReadable = incomingIntent.getStringExtra("readable");
		code = incomingIntent.getStringExtra("sportcode");
		
		
		setDefaultView();
	}

	
	private void setDefaultView(){
		//Set up the default layout for a team page.
		container.removeAllViews();
		
		LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		inflater.inflate(R.layout.teamlayout, container);
		
		TextView teamName = (TextView) findViewById(R.id.teamname);
		ImageView teamImage = (ImageView) findViewById(R.id.teamimage);
		
		teamName.setText(humanReadable);
		
		
		
		
		
		
		//Check if image has already been gotten if so then don't get again otherwise try to get it
		if(setImage != null && setImage.image != null){
			teamImage.setImageBitmap(setImage.image);
		}else{
			TeamPic teampicurlretriever = new TeamPic(teamImage);
			teampicurlretriever.execute("http://mobilerpi.jcmcmillan.com/v1/teampic/" + code);
		}
	}
	
	
	//Custom back button handler so that we don't need a new activity for each of the different buttons involved for a sport
	@Override
	public void onBackPressed(){
		if(inWhat == false){
			super.onBackPressed();
		}else{
			setDefaultView();
			inWhat = false;
		}
	}
	
	
	
	public void athleticsNews(View v){
		
		inWhat = true;
	}
	
	public void athleticsRoster(View v){
		//Show the team roster
		
		
		container.removeAllViews();
		
		TextView loading = new TextView(getApplicationContext());
		loading.setText("Loading...");
		
		container.addView(loading);
		
		JSONReciever getRoster = new JSONReciever(ROSTER);
		getRoster.execute("http://mobilerpi.jcmcmillan.com/v1/roster/" + code);
		inWhat = true;
	}
	
	
	private void displayRoster(String jsonResponse, String errors){
		container.removeAllViews();
		
		System.out.println("Errors:" + errors);
		
		
		if(errors != null && !(errors.equals(""))){
			TextView errorMsg = new TextView(getApplicationContext());
			errorMsg.setText(errors);
			container.addView(errorMsg);	
		}
		
		try{
			JSONArray rosterArray = (JSONArray) (((JSONObject) new JSONTokener(jsonResponse).nextValue()).getJSONArray("players"));
			
			for(int i = 0; i < rosterArray.length(); i++){
				//For each player get their information and display it
				JSONObject player = rosterArray.getJSONObject(i);
				String playername = player.getString("name");
				String playertown = player.getString("hometown");
				String playerimageurl = player.getString("image");
				
				LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.FILL_PARENT); 
				params.setMargins(0, 7, 0, 7);
				
				
				
				LinearLayout playerlayout = new LinearLayout(getApplicationContext());
				playerlayout.setLayoutParams(params);
				
				
				TextView nameTownText = new TextView(getApplicationContext());
				ImageView playerimage = new ImageView(getApplicationContext());
				
				nameTownText.setTextColor(0xFF000000);
				nameTownText.setText(playername + "\n" + playertown);
				
				playerlayout.addView(playerimage);
				playerlayout.addView(nameTownText);
				
				container.addView(playerlayout);
				
				//Put in a horizontal rule to better separate
				View ruler = new View(getApplicationContext());
				ruler.setBackgroundColor(0xFF000000);
				container.addView(ruler, new ViewGroup.LayoutParams( ViewGroup.LayoutParams.FILL_PARENT, 2));
				
				
				//get the image in a new thread
				ImageGetter rosterImage = new ImageGetter(playerimageurl, playerimage);
				rosterImage.execute();
			}
		}catch(JSONException e){
			//TODO add error handling
			TextView errorMsg = new TextView(getApplicationContext());
			errorMsg.setText(e.toString());
			container.addView(errorMsg);
		}
	}
	
	
	
	public void athleticsSchedule(View v){
		
		container.removeAllViews();
		
		TextView loading = new TextView(getApplicationContext());
		loading.setText("Loading...");
		
		container.addView(loading);
		
		JSONReciever getRoster = new JSONReciever(SCHEDULE);
		getRoster.execute("http://mobilerpi.jcmcmillan.com/v1/schedule/" + code);
		
		
		inWhat = true;
	}
	

	private void displaySchedule(String jsonResponse, String errors){
		container.removeAllViews();
		
		if(errors != null && !(errors.equals(""))){
			TextView errorMsg = new TextView(getApplicationContext());
			errorMsg.setText(errors);
			container.addView(errorMsg);
		}
		
		try{
			JSONArray scheduleArray = (JSONArray) (((JSONObject) new JSONTokener(jsonResponse).nextValue()).getJSONArray("events"));
			
			for(int i = 0; i < scheduleArray.length(); i++){
				//For each player get their information and display it
				JSONObject event = scheduleArray.getJSONObject(i);
				String teamName = event.getString("team");
				String teamLogoUrl = event.getString("image");
				String score = event.getString("score");
				String eventLocation = event.getString("location");
				
				if(eventLocation.indexOf("\n") != -1){
					eventLocation = eventLocation.substring(0, eventLocation.indexOf("\n"));
				}
				
				System.out.println(eventLocation);
				
				
				LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, LinearLayout.LayoutParams.FILL_PARENT); 
				params.setMargins(0, 7, 0, 7);
				
				
				
				LinearLayout eventLayout = new LinearLayout(getApplicationContext());
				eventLayout.setLayoutParams(params);
				
				
				TextView information = new TextView(getApplicationContext());
				ImageView teamImage = new ImageView(getApplicationContext());
				
				information.setTextColor(0xFF000000);
				
				
				//Only display a score if there is actually a score to report
				String scoreString = "";
				if(!score.equals("None")){
					scoreString = "\nScore: " + score;
				}
				
				information.setText(teamName + "\nTime: " + event.getString("time") + " - " + event.getString("date") + "\nAt: "  + eventLocation + scoreString);
				
				eventLayout.addView(teamImage);
				eventLayout.addView(information);
				
				
				container.addView(eventLayout);
				
				
				
				//Put in a horizontal rule to better separate
				View ruler = new View(getApplicationContext());
				ruler.setBackgroundColor(0xFF000000);
				container.addView(ruler, new ViewGroup.LayoutParams( ViewGroup.LayoutParams.FILL_PARENT, 2));
				
				
				
				
				//get the image in a new thread
				ImageGetter rosterImage = new ImageGetter(teamLogoUrl, teamImage);
				rosterImage.execute();
			}
		}catch(JSONException e){
			//TODO add error handling
			TextView errorMsg = new TextView(getApplicationContext());
			errorMsg.setText(e.toString());
			container.addView(errorMsg);
		}
		
		
	}
	
	public void athleticsArchives(View v){
		
		inWhat = true;	
	}
	
	
	
	
	//Class to get images and set the proper image view
	private class ImageGetter extends AsyncTask<Void, Void, Void> {

		private String imageUrl;
		private ImageView setView;
		public String errorString;
		
		public Bitmap image;
		
		public ImageGetter(String url, ImageView view){
			imageUrl = url;
			setView = view;
			errorString = "";
			image = null;
		}
		
		@Override
		protected Void doInBackground(Void... arg0) {
			try{
				//Will only ever be called with one string
				URL url;
				HttpURLConnection urlConnection;
				url = new URL(imageUrl);
				urlConnection = (HttpURLConnection) url.openConnection();
				
				Bitmap b = BitmapFactory.decodeStream(urlConnection.getInputStream());
				
				image = b;
			}catch(MalformedURLException e){
				errorString = e.toString();
				return null;
			}catch(IOException e){
				errorString = e.toString();
				return null;
			}
			
			return null;
		}
		
		
		protected void onPostExecute(Void args){
			if(errorString.equals("")){
				setView.setImageBitmap(image);
			}else{
				//There was an error reading the image or there was no image located display error image
				setView.setImageDrawable(setView.getContext().getResources().getDrawable(android.R.drawable.ic_dialog_alert));
			}
		}
	}
		
	
	private class JSONReciever extends urlResponder {
		private int callwhat;
		public JSONReciever(int where){
			callwhat = where;
		}
		protected void onPostExecute(String result){
			if(callwhat == ROSTER){
				displayRoster(result, this.errorString);
			}else if(callwhat == SCHEDULE){
				displaySchedule(result, this.errorString);
			}
		}
	}
	
	
	
	private class TeamPic extends urlResponder {
		ImageView teamImage;
		public TeamPic(ImageView v){
			teamImage = v;
		}
		protected void onPostExecute(String result){
			String teamPic = "";
			try{
				teamPic = ((JSONObject) new JSONTokener(result).nextValue()).getString("url");
				
			}catch(JSONException e){
				//TODO figure out what to do on error
			}
			setImage = new ImageGetter(teamPic, teamImage);
			setImage.execute();
			
		}
	}
}
