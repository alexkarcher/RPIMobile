package rpi.edu.rpimobile;

import java.util.ArrayList;
import java.util.List;

import com.actionbarsherlock.app.SherlockFragment;

import org.mcsoxford.rss.RSSFeed;
import org.mcsoxford.rss.RSSItem;
import org.mcsoxford.rss.RSSReader;
import org.mcsoxford.rss.RSSReaderException;

import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;


//Todo: create view xml documents for this list and for the items within.

public class Fragment4 extends SherlockFragment {

//bunch of global variables to be used by various threads in the application
	private ArrayList<String> titles;
	private ArrayList<String> links;
	private ArrayList<String> times;
	private ListView rsslist;
	private RSSListAdapter rssadapter;
	
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.rsslayout, container, false);

       //initialize data
        titles = new ArrayList<String>();
        links = new ArrayList<String>();
        times = new ArrayList<String>();
        
        //set list adapters and such
        rsslist = (ListView) rootView.findViewById(R.id.rsslist);
        rssadapter = new RSSListAdapter(this.getActivity(), titles, links, times);
        rsslist.setAdapter(rssadapter);//*/
        
        //download the data
        new Fragment4.Download().execute(5.0);
        
        
        
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
			
			Log.d("RPI", "Begin doInBackground");
			try {
				Log.d("RPI", "Initializing variables");
				RSSReader reader = new RSSReader();
				String uri = "http://www.rpiathletics.com/rss.aspx";
				Log.d("RPI", "Downloading feed items");
				RSSFeed feed = reader.load(uri);
				Log.d("RPI", "Assigning list");
				List<RSSItem> feedlist = feed.getItems();
				Log.d("RPI", "Parsing feed");
				for(int i = 0; i<feedlist.size(); i++){	
					titles.add(feedlist.get(i).getTitle());
					links.add(feedlist.get(i).getLink().toString());
					times.add(feedlist.get(i).getPubDate().toString());
					
					//Log.d("RPI", "Title: "+ feedlist.get(i).getTitle()+" Content: "+feedlist.get(i).getContent()+"Link: "+feedlist.get(i).getLink().toString());
				}
				Log.d("RPI", "Feed parsed");
			} catch (RSSReaderException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
	        
	        Log.d("RPI", "Exiting AsynchTask");
			return true;
		}
		
		protected void onPostExecute(Boolean results) {
			//Notify your view that you've updated its information
			Log.d("RPI", "Notifying list");
			
			rssadapter.notifyDataSetChanged();
			//dialog.dismiss();
			//return true;
		}//*/ 

		
		
	}
    
  
    
}