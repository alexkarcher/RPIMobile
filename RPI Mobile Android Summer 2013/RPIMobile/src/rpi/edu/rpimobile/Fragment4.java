package rpi.edu.rpimobile;

import java.util.ArrayList;
import java.util.List;

import com.actionbarsherlock.app.SherlockFragment;
import com.actionbarsherlock.view.Menu;
import com.actionbarsherlock.view.MenuInflater;
import com.actionbarsherlock.view.MenuItem;

import org.mcsoxford.rss.RSSFeed;
import org.mcsoxford.rss.RSSItem;
import org.mcsoxford.rss.RSSReader;
import org.mcsoxford.rss.RSSReaderException;

import rpi.edu.rpimobile.model.RSSObject;
import rpi.edu.rpimobile.model.tweetobject;

import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.AsyncTask.Status;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;


//Todo: create view xml documents for this list and for the items within.

public class Fragment4 extends SherlockFragment {

//bunch of global variables to be used by various threads in the application
	private ArrayList<RSSObject> stories;
	private ArrayList<RSSObject> tempstories;
	private ArrayList<RSSObject> finlist = new ArrayList<RSSObject>();
	private RSSObject temp;
	private ListView rsslist;
	private RSSListAdapter rssadapter;
	private MenuItem refreshbutton;
	private AsyncTask downloadtask;
	
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.rsslayout, container, false);
        setHasOptionsMenu(true);
        
       //initialize data
        stories = new ArrayList<RSSObject>();
        tempstories = new ArrayList<RSSObject>();
        
        
        //set list adapters and such
        rsslist = (ListView) rootView.findViewById(R.id.rsslist);
        rssadapter = new RSSListAdapter(this.getActivity(), stories);
        rsslist.setAdapter(rssadapter);//*/
        
        //download the data
        cyclenum = 0;
        refreshcycle();
        
        
        
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
        	
        	refreshcycle();
        	
        }
 
        return super.onOptionsItemSelected(item);
    }
	
	public int cyclenum;
	public String[] tags = {"Top","Baseball","Field Hockey","Football","General","M Basketball","M Cross Country",
			"M Golf","M Hockey","M Indoor Track","M Lacrosse","M Soccer","M Swimming Diving","M Tennis","M Track Field","Softball",
			"W Cross Country","W Ice Hockey","W Indoor Track","W Lacrosse","W Soccer","W Swimming Diving","W Tennis","W Track Field",
			"W Basketball"};
	public String[] rsslinks = {"http://www.rpiathletics.com/rss.aspx", "http://www.rpiathletics.com/rss.aspx?path=baseball"
			,"http://www.rpiathletics.com/rss.aspx?path=fhockey","http://www.rpiathletics.com/rss.aspx?path=football"
			,"http://www.rpiathletics.com/rss.aspx?path=gen","http://www.rpiathletics.com/rss.aspx?path=mbball"
			,"http://www.rpiathletics.com/rss.aspx?path=mcross","http://www.rpiathletics.com/rss.aspx?path=golf"
			,"http://www.rpiathletics.com/rss.aspx?path=hockey","http://www.rpiathletics.com/rss.aspx?path=indoortrack"
			,"http://www.rpiathletics.com/rss.aspx?path=mlax","http://www.rpiathletics.com/rss.aspx?path=msoc"
			,"http://www.rpiathletics.com/rss.aspx?path=mswim","http://www.rpiathletics.com/rss.aspx?path=mten"
			,"http://www.rpiathletics.com/rss.aspx?path=mtrack","http://www.rpiathletics.com/rss.aspx?path=softball"
			,"http://www.rpiathletics.com/rss.aspx?path=wcross","http://www.rpiathletics.com/rss.aspx?path=whock"
			,"http://www.rpiathletics.com/rss.aspx?path=windoortrack","http://www.rpiathletics.com/rss.aspx?path=wlax"
			,"http://www.rpiathletics.com/rss.aspx?path=wsoc","http://www.rpiathletics.com/rss.aspx?path=wswim"
			,"http://www.rpiathletics.com/rss.aspx?path=wten","http://www.rpiathletics.com/rss.aspx?path=wtrack"
			,"http://www.rpiathletics.com/rss.aspx?path=wbball"};
	
	public void refreshcycle(){
		
		SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getActivity());
		
		
		if(cyclenum==0){
			getActivity().setProgressBarIndeterminateVisibility(Boolean.TRUE);
			stories.clear();
		}
		
		if(cyclenum==tags.length){
			getActivity().setProgressBarIndeterminateVisibility(Boolean.FALSE);
    		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Loading complete List size:"+stories.size());
			cyclenum = 0;
		}
		else{
			int ctemp = cyclenum;
			cyclenum++;
			if(prefs.getBoolean("sports_"+tags[ctemp], ctemp==0)){
				downloadtask = new Fragment4.Download().execute(rsslinks[ctemp],tags[ctemp]);
				
			}
			else{
				refreshcycle();
			}
		}
	
	}
	
 
    private class Download extends AsyncTask<String, Void, Boolean>{

    	protected void onPreExecute(){
			//getActivity().setProgressBarIndeterminateVisibility(Boolean.TRUE);
		}
    	
    	
		@Override
		protected Boolean doInBackground(String... params) {
			// TODO Auto-generated method stub
			tempstories.clear();
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Begin doInBackground");
			try {
				
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Initializing variables");
				RSSReader reader = new RSSReader();
				String uri = params[0];
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Downloading feed items");
				RSSFeed feed = reader.load(uri);
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Assigning list");
				List<RSSItem> feedlist = feed.getItems();
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Parsing feed");
				for(int i = 0; i<feedlist.size(); i++){	
					temp = new RSSObject();
					temp.title = feedlist.get(i).getTitle();
					temp.link = feedlist.get(i).getLink().toString();
					temp.time = feedlist.get(i).getPubDate();
					temp.category = params[1];
					tempstories.add(temp);
					//if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Title: "+ feedlist.get(i).getTitle()+" Content: "+feedlist.get(i).getContent()+"Link: "+feedlist.get(i).getLink().toString());
				}
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Feed parsed");
			} catch (RSSReaderException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}	
	        
	        if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Exiting AsynchTask");
			return true;
		}
		
		protected void onPostExecute(Boolean results) {
			//Notify your view that you've updated its information
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Notifying list");
			//getActivity().setProgressBarIndeterminateVisibility(Boolean.FALSE);
			
			addtolist(tempstories);
			
			try{ 
				rssadapter.notifyDataSetChanged();
			}
			catch(Exception e){
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", e.toString());
			}
			refreshcycle();
			//dialog.dismiss();
			//return true;
		}//*/ 

		
		
	}
    
    private void addtolist(ArrayList<RSSObject> temp){
    	
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI","Combining lists");
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI","Source list: "+stories.size()+" Temp list: "+temp.size());
    	
    	int sourcecounter = 0;
    	int tempcounter = 0;
    	
    	finlist.clear();
    	
    	while(sourcecounter<stories.size()&&tempcounter<temp.size()){
    		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI","Looping, Source:"+sourcecounter+" Temp:"+tempcounter);
    		if(stories.get(sourcecounter).time.after(temp.get(tempcounter).time)){
    			finlist.add(stories.get(sourcecounter).deepcopy());
    			sourcecounter++;
    		}
    		else if(stories.get(sourcecounter).time.before(temp.get(tempcounter).time)){
    			finlist.add(temp.get(tempcounter).deepcopy());
    			tempcounter++;
    		}
    		else{
    			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Two items actually had the same time... Strange");
    			finlist.add(stories.get(sourcecounter).deepcopy());
    			sourcecounter++;
    		}
    	}
		while(sourcecounter<stories.size()){
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI","Clearing source");
			finlist.add(stories.get(sourcecounter).deepcopy());
			sourcecounter++;
		}
		while(tempcounter<temp.size()){
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI","clearing temp");
			finlist.add(temp.get(tempcounter).deepcopy());
			tempcounter++;
		}
		
    	assign(stories, finlist);  	
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Lists combined. Source list:"+stories.size());
    	
    }
    
    
    
    private void assign(ArrayList<RSSObject> target, ArrayList<RSSObject> source){
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Starting copy source:"+source.size()+" Target:"+target.size());
    	//target = new ArrayList<tweetobject>();
    	target.clear();
    	for(int i = 0; i<source.size(); i++)
    		target.add(source.get(i).deepcopy());
    	
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Finished copy source:"+source.size()+" Target:"+target.size());
    }
    
}