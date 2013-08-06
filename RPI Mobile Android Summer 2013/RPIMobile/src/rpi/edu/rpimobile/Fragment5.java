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
import android.widget.ListView;
import android.widget.Toast;
 
//Events Calendar fragment
public class Fragment5 extends SherlockFragment {
    
	//All variables to be used throughout the function
	private JSONObject jObj;
	private ArrayList<CalEvent> events;
	private CalendarListAdapter listadapter;
	private MenuItem refreshbutton;
	private JSONCalendarTask downloadtask;
	
	
	//Initial function
	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
    	//Inflate the layout into the parent view of container view of the parent class
		View rootView = inflater.inflate(R.layout.fragment5, container, false);
		
		//Allow this fragment to interact with the menu
        setHasOptionsMenu(true);
        
        //initialize data
        events = new ArrayList<CalEvent>();
        
        //set an adapter up for the listview to handle displaying the data
        ListView callist = (ListView) rootView.findViewById(R.id.calendarlist);
        listadapter = new CalendarListAdapter(this.getActivity(), events);
        callist.setAdapter(listadapter);
        
        //Start the download of the calendar data
        downloadtask = new JSONCalendarTask();
		downloadtask.execute(new String[]{"http://events.rpi.edu/webcache/v1.0/jsonDays/31/list-json/no--filter/no--object.json"});
        
       return rootView;
    }
	
	
	//Class to be run when the fragment is terminated
	@Override
	public void onStop(){
    	super.onStop();
    	//this class, for some reason, didn't like the logcat() function. Very strange.
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Running onStop()");
    	//check the state of the Download() task
    	if(downloadtask != null && downloadtask.getStatus() == Status.RUNNING){
    		//if there is a download running stop it
    		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Stopping Thread");	
    		downloadtask.cancel(true);
    		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Thread Stopped");
    	}
    }
	
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater){
		//Class called when the options menu is populated
		super.onCreateOptionsMenu(menu, inflater);
		//Add a refresh button and set its icon and visibility
		refreshbutton = menu.add("Refresh");
		refreshbutton.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS);
		refreshbutton.setIcon(R.drawable.navigation_refresh);
	}
	//Class called when an options item is selected
	public boolean onOptionsItemSelected(MenuItem item) {
		//If the refresh button was pressed
        if (item == refreshbutton){
        	//refresh the data
        	downloadtask = new JSONCalendarTask();
    		downloadtask.execute(new String[]{"http://events.rpi.edu/webcache/v1.0/jsonDays/31/list-json/no--filter/no--object.json"});
        	
        }
      //This passes the call back up the chain to the main class, which also handles onOptionsitemSeleced events
        return super.onOptionsItemSelected(item);
    }
	
	
	
	
	
	//AsyncTask thread to download calendar data
	private class JSONCalendarTask extends AsyncTask<String, Void, Boolean> {

		//before the thread is executed set the action bar to show indeterminate progress, usually a spinner
		protected void onPreExecute(){
			getActivity().setProgressBarIndeterminateVisibility(Boolean.TRUE);
		}
		
		//Class to be ran in another thread
		@Override
		protected Boolean doInBackground(String... params) {
			//If a looper hasn't already been prepared by another thread prepare one for this application
			if (Looper.myLooper()==null) {
				 Looper.prepare();
			 }
			logcat( "Begining Download");
			String data;
			CalEvent temp = new CalEvent();
			//Try to download data
			try {
			data = ( (new WeatherHttpClient()).getWeatherData(params[0]));//+"&units=imperial"));
			logcat( "downloaded data of length "+data.length());
			}
			catch(Exception e){
				//if the download failed quit the thread and notify the user
				e.printStackTrace();
				Toast.makeText(getActivity(), "Calendar Download Failed", Toast.LENGTH_SHORT).show();
				return true;
			}
			//Try to read all of the JSON objects into their respective variables
			try {
				jObj = new JSONObject(data);
				logcat( "Parsing items");
				
				JSONArray items = jObj.getJSONObject("bwEventList").getJSONArray("events");
				JSONObject tempJ;
				
				//loop through each of the event items in the array
				for(int i = 0; i<items.length(); i++){
					logcat( "Adding item #"+i);
					temp = new CalEvent();
					
					tempJ = items.getJSONObject(i);
					
					logcat( "Getting variables");
					
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
					
					logcat( "Item saved: "+temp.summary);
				}
				
				logcat( "Data pushed, Size: "+events.size());

			} catch (JSONException e) {				
				e.printStackTrace();
			}
			//Quit the looper now that we're done with it
			Looper.myLooper().quit();
			logcat( "Finished Download");
			return true;

	}




	@Override
		protected void onPostExecute(Boolean results) {	
		//code to be ran in the UI thread after the background thread has completed
			logcat( "Updating List");
			//Set the action bar back to normal
			getActivity().setProgressBarIndeterminateVisibility(Boolean.FALSE);
			
			try{
				//Notify the list of new data
				listadapter.notifyDataSetChanged();
			}
			catch(Exception e){
				logcat( e.toString());
			}
			
		}


	private void logcat(String logtext){
		//code to write a log.d message if the user allows it in preferences
		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false))
			Log.d("RPI", logtext);
	}




  }
	
	
}