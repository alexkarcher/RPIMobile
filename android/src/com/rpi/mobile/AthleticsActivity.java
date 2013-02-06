package com.rpi.mobile;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

public class AthleticsActivity extends RPIActivity {
	
	private ArrayList<Button> mensTeams;
	private ArrayList<Button> womensTeams;
	
	LinearLayout container;
	@Override
	public void onCreate(Bundle savedInstance){
		super.onCreate(savedInstance);
		setContentView(R.layout.baselayout);
		super.setUpButtons();
		
		container = (LinearLayout) findViewById(R.id.contentContainer);
		
		
		LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		inflater.inflate(R.layout.athleticsteamlistlayout, container);
		
		
		
		Button menteamButton = (Button) findViewById(R.id.menteams);
		Button womenteamButton = (Button) findViewById(R.id.womenteams);
		
		menteamButton.setOnClickListener(new MenClickListener());
		womenteamButton.setOnClickListener(new WomenClickListener());
		
		listTeams();
	}
	
	
	private void listTeams(){
		InputStream in = getResources().openRawResource(R.raw.athletics);
		
		
		try{
			BufferedReader reader = new BufferedReader(new InputStreamReader(in));
			StringBuilder full = new StringBuilder();
			String line;
			while ((line = reader.readLine()) != null) {
			    full.append(line);
			}
			
			
			JSONTokener jsontok = new JSONTokener(full.toString());
			
			JSONObject obj = (JSONObject) jsontok.nextValue();
			
			JSONArray mens = obj.getJSONArray("men");
			JSONArray womens = obj.getJSONArray("women");
			
			mensTeams = new ArrayList<Button>();
			womensTeams = new ArrayList<Button>();
			
			
			//Array is in the form of "FULL NAME":"SPORT CODE" therefore we use .names() to get all the names of json objects
			for(int i = 0; i < mens.length(); i++){
				JSONObject sport = mens.getJSONObject(i);
				String sportName = sport.names().getString(0);
				
				String sportCode = sport.getString(sportName);				
				AthleticsClickListener clickHandler = new AthleticsClickListener(sportCode, sportName);
				
				Button sportButton = new Button(getApplicationContext());
				
				sportButton.setOnClickListener(clickHandler);
				sportButton.setText(sportName);
				mensTeams.add(sportButton);
			}
			
			for(int i = 0; i < womens.length(); i++){
				JSONObject sport = womens.getJSONObject(i);
				String sportName = sport.names().getString(0);
				
				String sportCode = sport.getString(sportName);				
				AthleticsClickListener clickHandler = new AthleticsClickListener(sportCode, sportName);
				
				Button sportButton = new Button(getApplicationContext());
				
				sportButton.setOnClickListener(clickHandler);
				sportButton.setText(sportName);
				womensTeams.add(sportButton);
			}
			
		} catch(IOException e){
			TextView errorMessage = new TextView(getApplicationContext());
			errorMessage.setText(e.toString());
			LinearLayout container = (LinearLayout) findViewById(R.id.contentContainer);
			container.addView(errorMessage);
			return;
		} catch (JSONException e) {
			TextView errorMessage = new TextView(getApplicationContext());
			errorMessage.setText(e.toString());
			LinearLayout container = (LinearLayout) findViewById(R.id.contentContainer);
			container.addView(errorMessage);
			return;
		}
		
		
		//Default to displaying mens teams
		displayTeam(0);
		
	}
	
	
	
	//arg which - 0 for men, 1 for women
	private void displayTeam(int which){
		List<Button> usingWhat;
		if(which == 0){
			usingWhat = mensTeams;
		}else{
			usingWhat = womensTeams;
		}
		
		LinearLayout teamlist = (LinearLayout) findViewById(R.id.teamlist);
		teamlist.removeAllViews();
		
		for(int i = 0; i < usingWhat.size(); i++){
			teamlist.addView(usingWhat.get(i));
		}
	}
	
	
	//Athletics on click listener since you cannot pass any additional arguments to the onclick
	public class AthleticsClickListener implements View.OnClickListener {
		private String team;
		private String humanreadable;
		public AthleticsClickListener(String teamid, String readable){
			team = teamid;
			humanreadable = readable;
		}
		
		public void onClick(View v){
			Intent sportActivity = new Intent(v.getContext(), SportActivity.class);
			sportActivity.putExtra("readable", humanreadable);
			sportActivity.putExtra("sportcode", team);
			sportActivity.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			v.getContext().startActivity(sportActivity);
		}
	}

	
	
	
	//Men and womens button to show different sports THESE MUST STAY AS SUB CLASSES
	private class MenClickListener implements View.OnClickListener {
		public void onClick(View v){
			displayTeam(0);
		}
	}
	
	
	private class WomenClickListener implements View.OnClickListener {
		public void onClick(View v){
			displayTeam(1);
		}
	}
	
	
}
