package rpi.edu.rpimobile;

import org.json.JSONException;
import org.json.JSONObject;

import com.actionbarsherlock.app.SherlockFragment;
import com.actionbarsherlock.view.Menu;
import com.actionbarsherlock.view.MenuInflater;
import com.actionbarsherlock.view.MenuItem;

import rpi.edu.rpimobile.model.Weathervars;

import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Looper;
import android.os.AsyncTask.Status;
import android.preference.PreferenceManager;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
 
public class Fragment1 extends SherlockFragment {
    
	private TextView tempview;
	private TextView cityview;
	private TextView hilowview;
	private ImageView iconview;
	private JSONObject jObj;
	private Weathervars today;
	private MenuItem refreshbutton;
	private SharedPreferences prefs;
	private JSONWeatherTask downloadtask;
	
	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment1, container, false);
        
        if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Begin onCreate Fragment1");
        
        setHasOptionsMenu(true);
        
        tempview = (TextView) rootView.findViewById(R.id.Temperature);
        cityview = (TextView) rootView.findViewById(R.id.City);
        hilowview = (TextView) rootView.findViewById(R.id.hilow);
        //iconview = (ImageView) rootView.findViewById(R.id.weathericon);
        
        today = new Weathervars();
        
        today.temperature = (float) 255.372;
        today.location = "Loading Weather";
        this.SetDisplay();
      /*  String prefName = "savedweather";
		getActivity();
		prefs = getActivity().getSharedPreferences("RPI" , FragmentActivity.MODE_PRIVATE);
		today = prefs.
		
		
		Tutorial 
		http://androidcodemonkey.blogspot.com/2011/07/store-and-get-object-in-android-shared.html
		//*/
         
        
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getActivity());
        
        downloadtask = new JSONWeatherTask();
		downloadtask.execute(new String[]{prefs.getString("weatherlocation", "Troy")});
        
      /*  WebView webv = (WebView) rootView.findViewById(R.id.WeatherWebView);
        webv.getSettings().setJavaScriptEnabled(true);
        webv.setWebViewClient(new WebViewClient());
        
        /*XML to add again
            <WebView
        android:id="@+id/WeatherWebView"
        android:layout_width="fill_parent"
        android:layout_height="fill_parent"
 			/> *//*
        
        
        webv.loadUrl("http://m.weather.com/weather/today/12180");
        //webv.loadUrl("http://www.google.com");*/
        
        
		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Fragment1: OnCreate ran");
       return rootView;
    }
	
    @Override
	public void onStop(){
    	super.onStop();
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Running onStop()");
    	//check the state of the Download() task
    	if(downloadtask != null && downloadtask.getStatus() == Status.RUNNING){
    		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false))
    			Log.d("RPI", "Stopping Thread");	
    		downloadtask.cancel(true);
    		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false))
    			Log.d("RPI", "Thread Stopped");
    	}
    }
	
	@Override
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater){
		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Fragment1: Filling options menu");
		super.onCreateOptionsMenu(menu, inflater);
		refreshbutton = menu.add("Refresh");
		refreshbutton.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS);
		refreshbutton.setIcon(R.drawable.navigation_refresh);
	}
	
	public boolean onOptionsitemSelected(MenuItem item) {
		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Fragment1: onOptionsItemSelected");
        if (item == refreshbutton){
        	
        	SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getActivity());
            
            downloadtask = new JSONWeatherTask();
    		downloadtask.execute(new String[]{prefs.getString("weatherlocation", "Troy")});
        	
        }
 
        return super.onOptionsItemSelected(item);
    }
	
	
	
	
	
	private class JSONWeatherTask extends AsyncTask<String, Void, Weathervars> {
		
		protected void onPreExecute(){
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Weather onPreExecute");
			getActivity().setProgressBarIndeterminateVisibility(Boolean.TRUE);
		}

		@Override
		protected Weathervars doInBackground(String... params) {
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "WeatherdoInBackground started");
			if (Looper.myLooper()==null) {
				 Looper.prepare();
			 }
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Begining Download");
			String data;
			today = new Weathervars();
			//Weather weather = new Weather();
			try {
			data = ( (new WeatherHttpClient()).getWeatherData("http://api.openweathermap.org/data/2.5/weather?q="+params[0]));//+"&units=imperial"));
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "downloaded data of length "+data.length());
			}
			catch(Exception e){
				e.printStackTrace();
				//Toast.makeText(getActivity(), "Weather Download Failed", Toast.LENGTH_SHORT).show();
				return today;
			}
			try {
				//weather = JSONWeatherParser.getWeather(data);
				jObj = new JSONObject(data);
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Setting today variables");
				today.temperature = ((float)jObj.getJSONObject("main").getDouble("temp"));
				today.location = jObj.getString("name");
				today.temphigh = (float) jObj.getJSONObject("main").getDouble("temp_max");
				today.templow = (float) jObj.getJSONObject("main").getDouble("temp_min");
				//today.percepchance = (float) jObj.
				today.condition = jObj.getJSONArray("weather").getJSONObject(0).getString("main");
				// Let's retrieve the icon
				String tempicon = jObj.getJSONArray("weather").getJSONObject(0).getString("icon");
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Downloading icon: "+tempicon);
				//today.icon = (new WeatherHttpClient()).getImage(tempicon);

			} catch (JSONException e) {				
				e.printStackTrace();
				//Toast.makeText(getActivity(), "Weather Download Failed", Toast.LENGTH_SHORT).show();
			}
			
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Finished Download");
			Looper.myLooper().quit();
			return today;

	}




	@Override
		protected void onPostExecute(Weathervars weather) {			
			super.onPostExecute(weather);
			getActivity().setProgressBarIndeterminateVisibility(Boolean.FALSE);
			/*if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Checking image");
			if (today.icon != null && today.icon.length > 0) {
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Setting Image");
				Bitmap img = BitmapFactory.decodeByteArray(today.icon, 0, today.icon.length); 
				iconview.setImageBitmap(img);
			}
			else Toast.makeText(getActivity(), "Icon Download Failed", Toast.LENGTH_SHORT).show();
			//*/

			SetDisplay();
		}

  }
	private void SetDisplay(){
		if(this.isVisible()){
		if(today.location != null && today.location.length()>0){
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Setting temp to "+(today.temperature));
			
			try{
			tempview.setText(tempconvert(today.temperature));
			hilowview.setText("High: "+tempconvert(today.temphigh)+"\nLow: "+tempconvert(today.templow));
			cityview.setText(today.condition+"\n"+today.location);
			
			}
			catch(Exception e){
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", e.toString());
			}
			}
			else Toast.makeText(getActivity(), "Weather Download Failed", Toast.LENGTH_SHORT).show();
		}
		else{ 
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Canceling view, Fragment 1 not visible");
			}
	}
	
	private String tempconvert(float temp){
		SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getActivity());
		String temppref = prefs.getString("displaytemp", "f");
		String temperature;
		if(temppref.equals("f")) temperature = "" + Math.round(((temp - 273.15)*1.8)+32) + "°F";
		else if(temppref.equals("c")) temperature = "" + Math.round(temp - 273.15) + "°C";
		else if(temppref.equals("k")) temperature = "" + Math.round(temp) + "°K";
		else temperature = "Invalid data";
		return temperature;
	}
	
}