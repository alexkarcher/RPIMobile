package edu.rpi.rpimobile;

import com.google.android.gms.maps.SupportMapFragment;
import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import com.actionbarsherlock.app.SherlockFragment;
import com.actionbarsherlock.view.Menu;
import com.actionbarsherlock.view.MenuInflater;
import com.actionbarsherlock.view.MenuItem;

import edu.rpi.rpimobile.model.Shuttle;
import twitter4j.internal.org.json.JSONArray;

import android.content.SharedPreferences;
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
import android.widget.TextView;
import android.widget.Toast;
 
//Shuttle Fragment
public class Fragment7 extends SherlockFragment {
    
        private ArrayList<Shuttle> shuttles;
        private AsyncTask<Void, Void, ArrayList<Shuttle>> downloadtask;
        
        private MenuItem refreshbutton;
        
        //Initial function
        @Override
        public View onCreateView(LayoutInflater inflater, ViewGroup container,
                        Bundle savedInstanceState) {
        	
                //Inflate the layout into the parent view of container view of the parent class
                View rootView = inflater.inflate(R.layout.fragment7, container, false);
                
                //Allow this fragment to interact with the menu
                setHasOptionsMenu(true);
                
                //Point the shuttles variable to an arraylist of Shuttle objects
                shuttles = new ArrayList<Shuttle>();
                
                //download the shuttle data
                downloadtask = new Fragment7.ShuttleDownload().execute();
                
                return rootView;
        }
        
        public void onCreateOptionsMenu(Menu menu, MenuInflater inflater){
            //Class called when the options menu is populated
            logcat( "Fragment7: Filling options menu");
            super.onCreateOptionsMenu(menu, inflater);
            
            //Add a refresh button and set its icon and visibility
            refreshbutton = menu.add("Refresh");
            refreshbutton.setNumericShortcut((char)2);
            refreshbutton.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS);
            refreshbutton.setIcon(R.drawable.navigation_refresh);
        }
        
        public boolean onOptionsItemSelected(MenuItem item) {
            
            //Class called when an options item is selected
            logcat( "Fragment7: onOptionsItemSelected");
            //If the refresh button was pressed
                    
            if (item == refreshbutton){
            	downloadtask = new ShuttleDownload();
            	downloadtask.execute();
    		}
    		//This passes the call back up the chain to the main class, which also handles onOptionsitemSeleced events
    		return super.onOptionsItemSelected(item);
        }
        
        private class ShuttleDownload extends AsyncTask<Void, Void, ArrayList<Shuttle>>{

                //before the thread is executed, set the action bar to show indeterminate progress
                protected void onPreExecute(){
                        getActivity().setProgressBarIndeterminateVisibility(Boolean.TRUE);
                }
                
                @Override
                protected ArrayList<Shuttle> doInBackground(Void... params) {
                        
                        logcat("Accessing Shuttle Data...");
                        
                        try {
                                //Get data from shuttles.rpi.edu/vehicles/current.js
                                HttpClient httpClient = new DefaultHttpClient();
                                HttpGet get = new HttpGet("http://shuttles.rpi.edu/vehicles/current.js");
                                HttpResponse response = httpClient.execute(get);
                                
                                //Convert data from string to JSON 
                                String raw_data = EntityUtils.toString(response.getEntity());
                                JSONArray shuttleJSON = new JSONArray(raw_data);
                                
                                logcat("Shuttle Data: " + raw_data);
                                
                                //Iterate through vehicles in JSONArray
                                for (int i = 0; i < shuttleJSON.length(); i++) {
                                        
                                        Shuttle temp = new Shuttle();
                                        
                                        //Access vehicle object and nested details
                                        twitter4j.internal.org.json.JSONObject obj = shuttleJSON.getJSONObject(i);
                                        
                                        //Save new data in a vehicle model and store in shuttle ArrayList
                                        
                                        //Vehicle data
                                        twitter4j.internal.org.json.JSONObject aVehicle = obj.getJSONObject("vehicle");
                                        temp.id  = aVehicle.getInt("id");
                                        temp.name = aVehicle.getString("name");
                                        
                                        //Vehicle latest position 
                                        twitter4j.internal.org.json.JSONObject latestPosition = aVehicle.getJSONObject("latest_position");
                                        temp.heading = latestPosition.getInt("heading");
                                        temp.latitude = latestPosition.getString("latitude");
                                        temp.longitude = latestPosition.getString("longitude");
                                        temp.speed = latestPosition.getInt("speed");
                                        temp.timestamp = latestPosition.getString("timestamp");
                                        temp.cardinal_point = latestPosition.getString("cardinal_point");
                                        temp.public_status_msg = latestPosition.getString("public_status_msg");
                                        
                                        //Add shuttle to ArrayList
                                        shuttles.add(temp);
                                        logcat(temp.name);
                                }
                                
                        } catch (ClientProtocolException e) {
                                e.printStackTrace();
                        } catch (IOException e) {
                                e.printStackTrace();
                        } catch (Exception e) {
                                e.printStackTrace();
                        }
                        
                        logcat("Finished getting shuttle data");
                                
                        return shuttles;
                }
                
                protected void onPostExecute(ArrayList<Shuttle> shuttles) {
                        getActivity().setProgressBarIndeterminateVisibility(Boolean.FALSE);
                        setDisplay();
                }
                
        }
        
        public void setDisplay() {
        	//Display shuttle locations only if they are available
        	if (shuttles.size() > 0) {
        		
        		
        	}
			
		}
        
        private void logcat(String logtext){
                if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false))
                        Log.d("RPI", logtext);
        }
        
}