package rpi.edu.rpimobile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import com.actionbarsherlock.app.SherlockFragment;
import com.actionbarsherlock.view.Menu;
import com.actionbarsherlock.view.MenuInflater;
import com.actionbarsherlock.view.MenuItem;

import android.os.AsyncTask;
import android.os.Bundle;
import android.os.AsyncTask.Status;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import rpi.edu.rpimobile.model.Building;


public class Fragment2 extends SherlockFragment {
    
    private ArrayList<Building> buildings;
    private ListView buildinglist;
    private LaundryListAdapter listadapter;
    private MenuItem refreshbutton;
    private AsyncTask downloadtask;
    
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
    	View rootView = inflater.inflate(R.layout.fragment2, container, false);
    	setHasOptionsMenu(true);
    	
        buildings = new ArrayList<Building>();
        
        buildinglist = (ListView) rootView.findViewById(R.id.laundrylist);
        listadapter = new LaundryListAdapter(this.getActivity(), buildings);
        buildinglist.setAdapter(listadapter);
        
        downloadtask = new Fragment2.Download().execute(5.0);
        
        
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
        	
        	downloadtask = new Fragment2.Download().execute(5.0);
        	
        }
 
        return super.onOptionsItemSelected(item);
    }
	

    private class Download extends AsyncTask<Double, Void, Boolean>{
    		
    	protected void onPreExecute(){
			getActivity().setProgressBarIndeterminateVisibility(Boolean.TRUE);
		}
    	
    	
    		@Override
    		protected Boolean doInBackground(Double... params) {
    			// TODO Auto-generated method stub
    			Building temp = new Building();
    			
    			String source = "";
    			
    			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Beginning download");
    			
    			try {
    				HttpClient httpClient = new DefaultHttpClient();
        			HttpGet get = new HttpGet("http://www.laundryalert.com/cgi-bin/rpi2012/LMPage?CallingPage=LMRoom&RoomPersistence=&MachinePersistenceA=023&MachinePersistenceB=");
        			
					HttpResponse response = httpClient.execute(get);
					
					source = EntityUtils.toString(response.getEntity());
				} catch (ClientProtocolException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
    			
    			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Source download Length: "+source.length());
    			//if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", source);
    			String[] results = source.split("\\s+");
    			int counter = 0;
    			for(int i=0; i<results.length; i++){
    				if(results[i].contains("sans-serif")){
    					counter++;
    					if(counter>8&&!(results[i+1].equals("On")&&results[i+2].equals("site"))){
	    					temp = new Building();
	    					
	    					temp.tag = results[i].substring(12);
	    					
	    					if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", temp.tag);
	    					
	    					i++;
	    					while(!results[i].contains("font")){
	    						if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Concatinating: "+results[i]);
	    						temp.tag = temp.tag+" "+results[i];
	    						i++;
	    					}
	    					if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", temp.tag);
	    					
	    					while(!results[i].contains("sans-serif")) i++;
	    					i++;
	    					temp.available_washers=Integer.parseInt(results[i]);
	    					if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", ""+temp.available_washers);
	    					
	    					while(!results[i].contains("sans-serif")) i++;
	    					i++;
	    					temp.available_dryers=Integer.parseInt(results[i]);
	    					
	    					while(!results[i].contains("sans-serif")) i++;
	    					i++;
	    					temp.used_washers=Integer.parseInt(results[i]);
	    					
	    					while(!results[i].contains("sans-serif")) i++;
	    					i++;
	    					temp.used_dryers=Integer.parseInt(results[i]);
	    					
	    					buildings.add(temp);
	    				}
    				}
    			}
    			
    			
    			
    			
    	        if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Exiting AsynchTask");
    			return true;
    		}
    		
    		protected void onPostExecute(Boolean results) {
    			
    			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Notifying list");
    			getActivity().setProgressBarIndeterminateVisibility(Boolean.FALSE);
    			try{ 
    				if(Fragment2.this.isVisible())
    					listadapter.notifyDataSetChanged();
    				else {
    					if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Canceling view, Fragment 2 not visible");
    				}
    			}
    			catch(Exception e){
    				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", e.toString());
    			}
    			//dialog.dismiss();
    			//return true;
    		}//*/ 

    		
    		
    	}







}

