package rpi.edu.rpimobile;

import java.util.ArrayList;

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

//TV Guide Fragment
public class Fragment6 extends SherlockFragment {
    
	//All variables to be used throughout the function
    private ArrayList<Building> buildings;
    private ListView buildinglist;
    private LaundryListAdapter listadapter;
    private MenuItem refreshbutton;
    private AsyncTask downloadtask;
    
    
    //Initial function
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
    	
    	//Inflate the layout into the parent view of container view of the parent class
    	View rootView = inflater.inflate(R.layout.fragment2, container, false);
    	
    	//Allow this fragment to interact with the menu
    	setHasOptionsMenu(true);
    	
    	//Point the buildings variable to an arraylist of Building objects
        buildings = new ArrayList<Building>();
        
        //assign a list adapter to the listview to handle displaying the data
        buildinglist = (ListView) rootView.findViewById(R.id.laundrylist);
        listadapter = new LaundryListAdapter(this.getActivity(), buildings);
        buildinglist.setAdapter(listadapter);
        
        //download the Laundry data
        downloadtask = new Fragment6.Download().execute(5.0);
        
        
        return rootView;
    }
    
  //Class to be run when the fragment is terminated
    @Override
	public void onStop(){
    	super.onStop();
    	logcat( "Running onStop()");
    	//check the state of the Download() task
    	if(downloadtask != null && downloadtask.getStatus() == Status.RUNNING){
    		//if there is a download running stop it
    		logcat( "Stopping Thread");	
    		downloadtask.cancel(true);
    		logcat( "Thread Stopped");
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
	
	public boolean onOptionsItemSelected(MenuItem item) {
		//Class called when an options item is selected
		logcat( "Fragment2: onOptionsItemSelected");
		//If the refresh button was pressed
        if (item == refreshbutton){
        	
        	//Download the weather again
        	downloadtask = new Fragment6.Download().execute(5.0);
        	
        }
        
      //This passes the call back up the chain to the main class, which also handles onOptionsitemSeleced events
        return super.onOptionsItemSelected(item);
    }
	
	//AsynchTask thread to download laundry data
    private class Download extends AsyncTask<Double, Void, Boolean>{
    		
    	//before the thread is executed set the action bar to show indeterminate progress, usually a spinner
    	protected void onPreExecute(){
			getActivity().setProgressBarIndeterminateVisibility(Boolean.TRUE);
		}
    	
    		
    	//Class to be ran in another thread
    		@Override
    		protected Boolean doInBackground(Double... params) {

    			logcat( "Beginning download");
    			
    			//Perform Download code
    			
    	        logcat( "Exiting AsynchTask");
    			return true;
    		}
    		
    		protected void onPostExecute(Boolean results) {
    			//code to be ran in the UI thread after the background thread has completed
    			logcat( "Notifying list");
    			//Set the action bar back to normal
    			getActivity().setProgressBarIndeterminateVisibility(Boolean.FALSE);
    			try{ 
    				//if the fragment is visible update the list adapter
    				if(Fragment6.this.isVisible())
    					
    					//Code to update UI
    					listadapter.notifyDataSetChanged();
    				
    				else {
    					logcat( "Canceling view, Fragment 2 not visible");
    				}
    			}
    			catch(Exception e){
    				logcat( e.toString());
    			}
    		}

    		
    		
    	}


	private void logcat(String logtext){
		//code to write a log.d message if the user allows it in preferences
		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false))
			Log.d("RPI", logtext);
	}




}

