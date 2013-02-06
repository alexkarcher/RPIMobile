package com.rpi.mobile;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.os.Bundle;
import android.widget.ScrollView;
import android.widget.TextView;

public class WeatherActivity extends RPIActivity {
	public void onCreate(Bundle savedInstance){
		super.onCreate(savedInstance);
		setContentView(R.layout.baselayout);
		super.setUpButtons();
		
		getWeather();
	}
	
	private void getWeather(){
		//Toast.makeText(getApplicationContext(), "test", Toast.LENGTH_SHORT).show();
		/*try {
			String response = getURLResponse("http://free.worldweatheronline.com/feed/weather.ashx?q=12180&format=json&num_of_days=5&key=050d3d0eff023116122808");
			parseResponse(response);
		} catch (MalformedURLException e) {
			TextView failureMessage = new TextView(getApplicationContext());
			failureMessage.setText("Failure to load weather");
			ScrollView sv = (ScrollView) findViewById(R.id.mainScrollView);
			sv.addView(failureMessage);
		} catch (IOException e) {
			TextView failureMessage = new TextView(getApplicationContext());
			failureMessage.setText("Failure to load weather");
			ScrollView sv = (ScrollView) findViewById(R.id.mainScrollView);
			sv.addView(failureMessage);
		}catch(JSONException jsone){
			TextView failureMessage = new TextView(getApplicationContext());
			failureMessage.setText(jsone.toString());
			ScrollView sv = (ScrollView) findViewById(R.id.mainScrollView);
			sv.addView(failureMessage);
		}
		*/
	}
	
	private void parseResponse(String responseString) throws JSONException{
			JSONTokener weatherReport = new JSONTokener(responseString.toString());
			JSONObject data = ((JSONObject) weatherReport.nextValue()).getJSONObject("data");
			
			JSONObject currentConditions = data.getJSONArray("current_condition").getJSONObject(0);
			JSONObject byDateConditions = data.getJSONArray("weather").getJSONObject(0);
			
			TextView successsMessage = new TextView(getApplicationContext());
			successsMessage.setText(currentConditions.toString(1));
			
			ScrollView sv = (ScrollView) findViewById(R.id.mainScrollView);
			sv.addView(successsMessage);
	}
}