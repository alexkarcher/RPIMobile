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

import android.os.AsyncTask;
import android.os.Bundle;
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
    
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment2, container, false);
        
        buildings = new ArrayList<Building>();
        
        buildinglist = (ListView) rootView.findViewById(R.id.laundrylist);
        listadapter = new LaundryListAdapter(this.getActivity(), buildings);
        buildinglist.setAdapter(listadapter);
        
        new Fragment2.Download().execute(5.0);
        
        
        return rootView;
    }
 

    private class Download extends AsyncTask<Double, Void, Boolean>{
    	/*	final ProgressDialog dialog = ProgressDialog.show(Fragment3.this, "", 
    	            "Loading. Please wait...", true);
    		
    		protected void onPreExecute() {
    			// TODO Auto-generated method stub
    			
    			dialog.show();	
    		}//*/
    		
    		@Override
    		protected Boolean doInBackground(Double... params) {
    			// TODO Auto-generated method stub
    			Building temp = new Building();
    			
    			String source = "";
    			
    			Log.d("RPI", "Beginning download");
    			
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
    			
    			Log.d("RPI", "Source download Length: "+source.length());
    			//Log.d("RPI", source);
    			String[] results = source.split("\\s+");
    			int counter = 0;
    			for(int i=0; i<results.length; i++){
    				if(results[i].contains("sans-serif")){
    					counter++;
    					if(counter>8&&!(results[i+1].equals("On")&&results[i+2].equals("site"))){
	    					temp = new Building();
	    					
	    					temp.tag = results[i].substring(12);
	    					
	    					Log.d("RPI", temp.tag);
	    					
	    					i++;
	    					while(!results[i].contains("font")){
	    						Log.d("RPI", "Concatinating: "+results[i]);
	    						temp.tag = temp.tag+" "+results[i];
	    						i++;
	    					}
	    					Log.d("RPI", temp.tag);
	    					
	    					while(!results[i].contains("sans-serif")) i++;
	    					i++;
	    					temp.available_washers=Integer.parseInt(results[i]);
	    					Log.d("RPI", ""+temp.available_washers);
	    					
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
    			
    			
    			
    			
    	        Log.d("RPI", "Exiting AsynchTask");
    			return true;
    		}
    		
    		protected void onPostExecute(Boolean results) {
    			
    			Log.d("RPI", "Notifying list");
    			listadapter.notifyDataSetChanged();
    			//dialog.dismiss();
    			//return true;
    		}//*/ 

    		
    		
    	}







}

