package rpi.edu.rpimobile;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.actionbarsherlock.app.SherlockFragment;
import com.actionbarsherlock.view.Menu;
import com.actionbarsherlock.view.MenuInflater;
import com.actionbarsherlock.view.MenuItem;

import rpi.edu.rpimobile.model.CalEvent;

import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Looper;
import android.os.AsyncTask.Status;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
 
public class Fragment5 extends SherlockFragment {
    
	private TextView tempview;
	private TextView cityview;
	private JSONObject jObj;
	private ArrayList<CalEvent> events;
	private CalendarListAdapter listadapter;
	private MenuItem refreshbutton;
	private JSONCallendarTask downloadtask;
	
	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment5, container, false);
        setHasOptionsMenu(true);
        
        events = new ArrayList<CalEvent>();
        
        ListView callist = (ListView) rootView.findViewById(R.id.calendarlist);
        listadapter = new CalendarListAdapter(this.getActivity(), events);
        callist.setAdapter(listadapter);
        
        downloadtask = new JSONCallendarTask();
		downloadtask.execute(new String[]{"http://events.rpi.edu/webcache/v1.0/jsonDays/31/list-json/no--filter/no--object.json"});
        
		
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
        
        
        
       return rootView;
    }
	
	@Override
	public void onStop(){
    	super.onStop();
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Running onStop()");
    	//check the state of the Download() task
    	if(downloadtask != null && downloadtask.getStatus() == Status.RUNNING){
    		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Stopping Thread");	
    		downloadtask.cancel(true);
    		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Thread Stopped");
    	}
    }
	
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater){
		super.onCreateOptionsMenu(menu, inflater);
		refreshbutton = menu.add("Refresh");
		refreshbutton.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS);
		refreshbutton.setIcon(R.drawable.navigation_refresh);
	}
	
	public boolean onOptionsItemSelected(MenuItem item) {
		 
        if (item == refreshbutton){
        	
        	downloadtask = new JSONCallendarTask();
    		downloadtask.execute(new String[]{"http://events.rpi.edu/webcache/v1.0/jsonDays/31/list-json/no--filter/no--object.json"});
        	
        }
 
        return super.onOptionsItemSelected(item);
    }
	
	
	
	
	
	
	private class JSONCallendarTask extends AsyncTask<String, Void, Boolean> {

		
		protected void onPreExecute(){
			getActivity().setProgressBarIndeterminateVisibility(Boolean.TRUE);
		}
		
		
		@Override
		protected Boolean doInBackground(String... params) {
			if (Looper.myLooper()==null) {
				 Looper.prepare();
			 }
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Begining Download");
			String data;
			CalEvent temp = new CalEvent();
			//Weather weather = new Weather();
			try {
			data = ( (new WeatherHttpClient()).getWeatherData(params[0]));//+"&units=imperial"));
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "downloaded data of length "+data.length());
			}
			catch(Exception e){
				e.printStackTrace();
				Toast.makeText(getActivity(), "Calendar Download Failed", Toast.LENGTH_SHORT).show();
				return true;
			}
			try {
				//weather = JSONWeatherParser.getWeather(data);
				jObj = new JSONObject(data);
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Parsing items");
				
				JSONArray items = jObj.getJSONObject("bwEventList").getJSONArray("events");
				JSONObject tempJ;
				
				
				for(int i = 0; i<items.length(); i++){
					if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Adding item #"+i);
					temp = new CalEvent();
					
					tempJ = items.getJSONObject(i);
					
					if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Getting variables");
					
					temp.summary = tempJ.getString("summary");
					temp.link = tempJ.getString("eventlink");
					temp.allday = tempJ.getJSONObject("start").getBoolean("allday");
					temp.startdate = tempJ.getJSONObject("start").getString("shortdate");
					temp.starttime = tempJ.getJSONObject("start").getString("time");
					temp.enddate = tempJ.getJSONObject("end").getString("shortdate");
					temp.endtime = tempJ.getJSONObject("end").getString("time");
					temp.location = tempJ.getJSONObject("location").getString("address");
					temp.description = tempJ.getString("description");
					
					events.add(temp);
					
					if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Item saved: "+temp.summary);
				}
				
				
				
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Data pushed, Size: "+events.size());
				//today.icon = (new WeatherHttpClient()).getImage(tempicon);

			} catch (JSONException e) {				
				e.printStackTrace();
				//Toast.makeText(getActivity(), "Weather Download Failed", Toast.LENGTH_SHORT).show();
			}
			Looper.myLooper().quit();
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Finished Download");
			return true;

	}




	@Override
		protected void onPostExecute(Boolean results) {			
			//super.onPostExecute(weather);
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Updating List");
			getActivity().setProgressBarIndeterminateVisibility(Boolean.FALSE);
			
			try{
				listadapter.notifyDataSetChanged();
			}
			catch(Exception e){
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", e.toString());
			}
			
		}







  }
	
	
}