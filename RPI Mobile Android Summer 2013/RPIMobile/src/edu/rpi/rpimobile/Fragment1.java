package edu.rpi.rpimobile;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.AsyncTask.Status;
import android.os.Bundle;
import android.os.Looper;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.actionbarsherlock.app.SherlockFragment;
import com.actionbarsherlock.view.Menu;
import com.actionbarsherlock.view.MenuInflater;
import com.actionbarsherlock.view.MenuItem;

import edu.rpi.rpimobile.model.Weathervars;
 
//Weather Fragment
public class Fragment1 extends SherlockFragment {
    
	
	//All variables to be used throughout the function
	private TextView tempview;
	private TextView cityview;
	private TextView hilowview;
	private ImageView iconview;
	private JSONObject jObj;
	private Weathervars today;
	private MenuItem refreshbutton;
	private SharedPreferences prefs;
	private JSONWeatherTask downloadtask;
	
	
	//Initial function
	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
		//Inflate the layout into the parent view of container view of the parent class
        View rootView = inflater.inflate(R.layout.fragment1, container, false);
        
        logcat( "Begin onCreate Fragment1");
        
        //Allow this fragment to interact with the menu
        setHasOptionsMenu(true);
        
        //Assign view variables to their respective views
        tempview = (TextView) rootView.findViewById(R.id.Temperature);
        cityview = (TextView) rootView.findViewById(R.id.City);
        hilowview = (TextView) rootView.findViewById(R.id.hilow);
        //iconview = (ImageView) rootView.findViewById(R.id.weathericon);
        
        //populate the "today" weather item with an instance of the Weathervars class and intital values
        today = new Weathervars();
        
        
        today.temperature = (float) 255.372; //0f in Kelvin
        today.location = "Loading Weather"; //placeholder text
        today.temphigh = (float) 255.372;
        today.templow = (float) 255.372;
        this.SetDisplay();
        
        //Code to eventually be used to cache weather data
      /*  String prefName = "savedweather";
		getActivity();
		prefs = getActivity().getSharedPreferences("RPI" , FragmentActivity.MODE_PRIVATE);
		today = prefs.
		
		
		Tutorial 
		http://androidcodemonkey.blogspot.com/2011/07/store-and-get-object-in-android-shared.html
		//*/
         
        //Initialize a preference manager
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getActivity());
        
        //start the download of the weather data
        downloadtask = new JSONWeatherTask();
		downloadtask.execute(new String[]{prefs.getString("weatherlocation", "Troy")});
        
		logcat( "Fragment1: OnCreate ran");
       return rootView;
    }
	
    @Override
	public void onStop(){
    	super.onStop();
    	
    	//Class to be run when the fragment is terminated
    	
    	logcat( "Running onStop()");
    	//check the state of the Download() task
    	
    	//if there is a download running stop it
    	if(downloadtask != null && downloadtask.getStatus() == Status.RUNNING){
    		logcat( "Stopping Thread");	
    		downloadtask.cancel(true);
    		logcat( "Thread Stopped");
    	}
    }
	
	
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater){
		//Class called when the options menu is populated
		logcat( "Fragment1: Filling options menu");
		super.onCreateOptionsMenu(menu, inflater);
		
		//Add a refresh button and set its icon and visibility
		refreshbutton = menu.add("Refresh");
		refreshbutton.setNumericShortcut((char)2);
		refreshbutton.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS);
		refreshbutton.setIcon(R.drawable.navigation_refresh);
	}
	
	
	public boolean onOptionsItemSelected(MenuItem item) {
		
		//Class called when an options item is selected
		logcat( "Fragment1: onOptionsItemSelected");
		//If the refresh button was pressed
			
        if (item == refreshbutton){
        	
        	//Download the weather again
        	SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getActivity());
            
            downloadtask = new JSONWeatherTask();
    		downloadtask.execute(new String[]{prefs.getString("weatherlocation", "Troy")});
        	
        }
        //This passes the call back up the chain to the main class, which also handles onOptionsitemSeleced events
        return super.onOptionsItemSelected(item);
    }
	
	
	
	
	//AsyncTask thread to download weather data
	private class JSONWeatherTask extends AsyncTask<String, Void, Weathervars> {
		
		//before the thread is executed set the action bar to show indeterminate progress, usually a spinner
		protected void onPreExecute(){
			logcat( "Weather onPreExecute");
			getActivity().setProgressBarIndeterminateVisibility(Boolean.TRUE);
		}
		
		//Class to be ran in another thread
		@Override
		protected Weathervars doInBackground(String... params) {
			logcat( "WeatherdoInBackground started");
			//If a looper hasn't already been prepared by another thread prepare one for this application
			if (Looper.myLooper()==null) {
				 Looper.prepare();
			 }
			logcat( "Begining Download");
			String data;
			today = new Weathervars();
			//Try to download data
			try {
			data = ( (new WeatherHttpClient()).getWeatherData("http://api.openweathermap.org/data/2.5/weather?q="+params[0]));//+"&units=imperial"));
			logcat( "downloaded data of length "+data.length());
			}
			catch(Exception e){
				//if the download failed quit the thread
				e.printStackTrace();
				return today;
			}
			//Try to read all of the JSON objects into their respective variables
			try {
				jObj = new JSONObject(data);
				logcat( "Setting today variables");
				today.temperature = ((float)jObj.getJSONObject("main").getDouble("temp"));
				today.location = jObj.getString("name");
				today.temphigh = (float) jObj.getJSONObject("main").getDouble("temp_max");
				today.templow = (float) jObj.getJSONObject("main").getDouble("temp_min");
				today.condition = jObj.getJSONArray("weather").getJSONObject(0).getString("main");
				
				//The OpenWeatherMap API is really inconsistent about download a weather icon, so it's been disabled. 
				//String tempicon = jObj.getJSONArray("weather").getJSONObject(0).getString("icon");
				//logcat( "Downloading icon: "+tempicon);
				//today.icon = (new WeatherHttpClient()).getImage(tempicon);

			} catch (JSONException e) {				
				e.printStackTrace();
			}
			
			//Quit the looper now that we're done with it
			logcat( "Finished Download");
			Looper.myLooper().quit();
			return today;

	}




	@Override
		protected void onPostExecute(Weathervars weather) {			
		//code to be ran in the UI thread after the background thread has completed
			super.onPostExecute(weather);
			//Set the action bar back to normal
			getActivity().setProgressBarIndeterminateVisibility(Boolean.FALSE);
			//update the display
			SetDisplay();
		}

  }
	private void SetDisplay(){
		//code to update the UI with all of the variables in the "today" object
			//if anything was actually downloaded
		if(today.location != null && today.location.length()>0){
			logcat( "Setting temp to "+(today.temperature));
			//try to populate all views
			try{
			//temperature is converted to the proper units as it is populated
			tempview.setText(tempconvert(today.temperature));
			//The high/low is just one textview with a linebreak
			hilowview.setText("High: "+tempconvert(today.temphigh)+"\nLow: "+tempconvert(today.templow));
			//Same with the condition and location
			cityview.setText(today.condition+"\n"+today.location);
			
			//Additional code for parsing the icon when it is eventually used
			/*logcat( "Checking image");
			if (today.icon != null && today.icon.length > 0) {
				logcat( "Setting Image");
				Bitmap img = BitmapFactory.decodeByteArray(today.icon, 0, today.icon.length); 
				iconview.setImageBitmap(img);
			}
			else Toast.makeText(getActivity(), "Icon Download Failed", Toast.LENGTH_SHORT).show();
			//*/
			
			
			}
			catch(Exception e){
				logcat( e.toString());
			}
			}
			//if there isn't any data then alert the user
			else Toast.makeText(getActivity(), "Weather Download Failed", Toast.LENGTH_SHORT).show();
		

	}
	//class to convert temperature
	private String tempconvert(float temp){
		//read the preference for how the user would like to display the temperature
		SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getActivity());
		String temppref = prefs.getString("displaytemp", "f");
		String temperature;
		//conversions to each unit. The temperature is given in Kelvin, so that is an option as well. We're engineers
		if(temppref.equals("f")) temperature = "" + Math.round(((temp - 273.15)*1.8)+32) + "°F";
		else if(temppref.equals("c")) temperature = "" + Math.round(temp - 273.15) + "°C";
		else if(temppref.equals("k")) temperature = "" + Math.round(temp) + "°K";
		//handle an unrecognized temperature
		else temperature = "Invalid data";
		return temperature;
	}
	private void logcat(String logtext){
		//code to write a log.d message if the user allows it in preferences
		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false))
			Log.d("RPI", logtext);
	}
	
	
}