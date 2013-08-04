package rpi.edu.rpimobile;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.http.util.ByteArrayBuffer;

import com.actionbarsherlock.app.SherlockFragment;
import com.actionbarsherlock.view.Menu;
import com.actionbarsherlock.view.MenuInflater;
import com.actionbarsherlock.view.MenuItem;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.AsyncTask.Status;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.Toast;
import rpi.edu.rpimobile.model.tweetobject;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.conf.ConfigurationBuilder;


public class Fragment3 extends SherlockFragment {
	
/*	private ArrayList<String> avatars;
	private ArrayList<String> usernames;
	private ArrayList<Date> times;
	private ArrayList<String> tweetbodies;*/
	
	private tweetobject temp = new tweetobject();
	private ArrayList<tweetobject> tweets = new ArrayList<tweetobject>();
	private ArrayList<tweetobject> temptweets = new ArrayList<tweetobject>();
	
	private ArrayList<tweetobject> finlist = new ArrayList<tweetobject>();
	
	private ListView tweetlist;
	private TweetListAdapter tweetadapter;
	private URL url;
	Bitmap bmImg = null;
	private MenuItem refreshbutton;
	private AsyncTask downloadtask;
	
	private ArrayList<Bitmap> bmpavatars;
	
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment3, container, false);
        setHasOptionsMenu(true);
        
        tweets = new ArrayList<tweetobject>();
        
   /*   if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("Debug", "Declaring webview");
    	WebView twitterweb = (WebView) rootView.findViewById(R.id.twitterwebview);
    	twitterweb.getSettings().setJavaScriptEnabled(true);
    	twitterweb.setActivated(false);
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("Debug", "Loading webview");
        //twitterweb.loadUrl("https://mobile.twitter.com/rensselaer");
        if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("Debug", "Webview Loaded");
        
        TextView maintext = (TextView) rootView.findViewById(R.id.twittertextview);
        
        */
        
        
        
   /*     avatars = new ArrayList<String>();
        usernames = new ArrayList<String>();
        times = new ArrayList<Date>();
        tweetbodies = new ArrayList<String>();*/
        
        tweetlist = (ListView) rootView.findViewById(R.id.tweetlist);
        tweetadapter = new TweetListAdapter(this.getActivity(), tweets);
        tweetlist.setAdapter(tweetadapter);
        cyclenum = 0;
        tst = Toast.makeText(getActivity(), "Downloading @RPInews", Toast.LENGTH_SHORT);
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
    
    public int cyclenum;
    private Toast tst;
    
    public void refreshcycle(){

    	SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getActivity());
    	 
    	
    	switch(cyclenum){
    	case 0:
    		getActivity().setProgressBarIndeterminateVisibility(Boolean.TRUE);
    		cyclenum++;
    		tweets.clear();
    		if(prefs.getBoolean("twitter_rensselaer", true)){
    			tst.setText("Downloading @rensselaer");
	    		tst.show();
    			downloadtask = new Fragment3.Download().execute("rensselaer");
    		}
    		else{
    			refreshcycle();
    		}
            
            break;
    	case 1:
    		cyclenum++;
    		if(prefs.getBoolean("twitter_rpinews", true)){
	    		tst.setText("Downloading @RPInews");
	    		tst.show();
	    		downloadtask = new Fragment3.Download().execute("RPInews");
	    	}
    		else{
    			refreshcycle();
    		}
    		break;
    	case 2:
    		cyclenum++;
    		if(prefs.getBoolean("twitter_RPIAlumni", true)){
	    		tst.setText("Downloading @RPIAlumni");
	    		tst.show();
	    		downloadtask = new Fragment3.Download().execute("RPIAlumni");
	    	}
    		else{
    			refreshcycle();
    		}
    		break;
    	case 3:
    		cyclenum++;
    		if(prefs.getBoolean("twitter_RPILally", true)){
	    		tst.setText("Downloading @RPILally");
	    		tst.show();
	    		downloadtask = new Fragment3.Download().execute("RPILally");
    		}
    		else{
    			refreshcycle();
    		}
    		break;
    	case 4:
    		cyclenum++;
    		if(prefs.getBoolean("twitter_EMPACNews", true)){
	    		tst.setText("Downloading @EMPACnews");
	    		tst.show();
	    		downloadtask = new Fragment3.Download().execute("EMPACnews");
    		}
    		else{
    			refreshcycle();
    		}
    		break;
    	case 5:
    		cyclenum++;
    		if(prefs.getBoolean("twitter_RPISciDean", true)){
    			tst.setText("Downloading @RPISciDean");
    			tst.show();
    			downloadtask = new Fragment3.Download().execute("RPISciDean");
    		}
    		else{
    			refreshcycle();
    		}
    		break;
    	case 6:
    		cyclenum++;
    		if(prefs.getBoolean("twitter_RPI_CCPD", true)){
	    		tst.setText("Downloading @RPI_CCPD");
	    		tst.show();
	    		downloadtask = new Fragment3.Download().execute("RPI_CCPD");
    		}
    		else{
    			refreshcycle();
    		}
    		break;
    	case 7:
    		cyclenum++;
    		if(!prefs.getString("customtwitter", "").equals("")){
	    		tst.setText("Downloading @"+prefs.getString("customtwitter", ""));
	    		tst.show();
	    		downloadtask = new Fragment3.Download().execute(prefs.getString("customtwitter", ""));
    		}
    		else{
    			refreshcycle();
    		}
    		break;
    	case 8:
    		getActivity().setProgressBarIndeterminateVisibility(Boolean.FALSE);
    		tst.cancel();
    		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Loading complete List size:"+tweets.size());
    		cyclenum=0;
    		break;
    	}
    	
    }
	
	public boolean onOptionsItemSelected(MenuItem item) {
		 
        if (item == refreshbutton){
        	refreshcycle();
        	
        }
 
        return super.onOptionsItemSelected(item);
    }
    
    private class Download extends AsyncTask<String, Void, Boolean>{
		
    	protected void onPreExecute(){
			
		}
    	
		@Override
		protected Boolean doInBackground(String... params) {
			// TODO Auto-generated method stub
			temptweets.clear();
			ConfigurationBuilder cb = new ConfigurationBuilder();
	        cb.setDebugEnabled(true)
	          .setOAuthConsumerKey("UBhESaJGlMUwE0wy8bCTnw")
	          .setOAuthConsumerSecret("5e0xeE2wz1sthi9Lt0ibsSzYA4umS36yo7abNW4Egg")
	          .setOAuthAccessToken("15919642-JjVKhEkfEpjrd0es3PGGnaa8vfEvUN4JG0qdPxsiP")
	          .setOAuthAccessTokenSecret("XZ0tofnuEgWlPbToJoN3c2ZdDiKBcBi3U3CyPqxGR4");
	        TwitterFactory tf = new TwitterFactory(cb.build());
	        
	        Twitter twitter = tf.getInstance();
	        try {
	            List<twitter4j.Status> statuses;
	            String user = params[0];
	            statuses = twitter.getUserTimeline(user);
	            if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Showing @" + user + "'s user timeline.");
	            for (twitter4j.Status status : statuses) {
	            	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Looping status");
	            	temp = new tweetobject();
	            	//String username = "";
	            	//String tweetbody;
	            	String avatarurl;
	            	if(!status.isRetweet()){
	            		temp.username = status.getUser().getScreenName();
	            		temp.body = status.getText();
	            		avatarurl = status.getUser().getProfileImageURL();
	            	}
	            	else{
	            		temp.username = status.getRetweetedStatus().getUser().getScreenName();
	            		temp.body = ""+status.getRetweetedStatus().getText()+"\nRetweeted by @"+status.getUser().getScreenName();
	            		avatarurl = status.getRetweetedStatus().getUser().getProfileImageURL();
	            	}
	            	//avatars.add(R.drawable.rpi_buzz);//status.getUser().getProfileImageURL());
	            	//usernames.add(username);
	            	temp.time = status.getCreatedAt();
	            	//tweetbodies.add(tweetbody);
	                //if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI","@" + status.getUser().getScreenName() + " - " + status.getText()+" Is a Retweet:"+status.isRetweet());
	                //if(status.isRetweet())if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Retweet from: "+status.getRetweetedStatus().getUser().getScreenName()+" Retweeted text:"+status.getRetweetedStatus().getText());
	            	
	            	//download profile picture if it doesn't exist
	            	
	            	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Calling download class");
					downloadFromUrl(avatarurl,temp.username);
					
					//avatars.add(username);
					temp.avatar = temp.username;
					
					temptweets.add(temp);
					
	            }
	            if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Tweets Loaded");
	        } catch (TwitterException te) {
	            te.printStackTrace();
	            if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI","Failed to get timeline: " + te.getMessage());
	            //System.exit(-1);
	        }
				
	 /*       if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Notifying Adapter");
			tweetadapter.notifyDataSetChanged();
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Notifying list");
			//tweetlist.refreshDrawableState(); */
	        if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Exiting AsynchTask");
			return true;
		}
		
		protected void onPostExecute(Boolean results) {
			
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Adding to list");
			addtotweets(temptweets);
			//assign(tweets, temptweets);
			
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Notifying list Tweets.size(): "+tweets.size());
			if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "First item:"+tweets.get(0).body);
			
			
			try{
				tweetadapter.notifyDataSetChanged();
			}
			catch(Exception e){
				if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", e.toString());
			}
			refreshcycle();
			//dialog.dismiss();
			//return true;
		}//*/ 

		
		
	}
    
    private boolean downloadFromUrl(String imageURL, String fileName) {  //begin downloader public void
        try {//begin try
        	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Begin downloadFromUrl method");
        		URL url = new URL(imageURL); //link to file
                getActivity();
				File file = new File(getActivity().getDir("avatars", Context.MODE_PRIVATE)+fileName);
                if(!file.createNewFile()){
                	if(file.lastModified()>System.currentTimeMillis()-86400000){//if the image is less than 1 day old assume it's up to date and move on.
                    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "File exists recentely, quitting download");
                    	return true;
                	}
                }
                
                
                
                long startTime = System.currentTimeMillis();
                if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "download begining");
                if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "download url:" + url);
                if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "downloaded file name:" + fileName);
                /* Open a connection to that URL. */
                URLConnection ucon = url.openConnection();

                /*
                 * Define InputStreams to read from the URLConnection.
                 */
                InputStream is = ucon.getInputStream();
                BufferedInputStream bis = new BufferedInputStream(is);

                /*
                 * Read bytes to the Buffer until there is nothing more to read(-1).
                 */
                ByteArrayBuffer baf = new ByteArrayBuffer(50);
                int current = 0;
                while ((current = bis.read()) != -1) {//begin while
                        baf.append((byte) current);
                }//end while

                /* Convert the Bytes read to a String. */
                FileOutputStream fos = new FileOutputStream(file);
                fos.write(baf.toByteArray());
                fos.close();
                if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "download time elapsed"
                                + ((System.currentTimeMillis() - startTime))
                                + " mill sec");
                if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Download Successful");
                return true;
                
        }//end try 
        catch (IOException e) {//begin catch
                if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Error: " + e);
                return false;
        }//end catch
        
        
}//end downloader public void
    
    private void addtotweets(ArrayList<tweetobject> temp){
    	
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI","Combining lists");
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI","Tweets list: "+tweets.size()+" Temp list: "+temp.size());
    	
    	int tweetcounter = 0;
    	int tempcounter = 0;
    	
    	finlist.clear();
    	
    	while(tweetcounter<tweets.size()&&tempcounter<temp.size()){
    		if(tweets.get(tweetcounter).time.after(temp.get(tempcounter).time)){
    			finlist.add(tweets.get(tweetcounter).deepcopy());
    			tweetcounter++;
    		}
    		else if(tweets.get(tweetcounter).time.before(temp.get(tempcounter).time)){
    			finlist.add(temp.get(tempcounter).deepcopy());
    			tempcounter++;
    		}
    	}
		while(tweetcounter<tweets.size()){
			finlist.add(tweets.get(tweetcounter).deepcopy());
			tweetcounter++;
		}
		while(tempcounter<temp.size()){
			finlist.add(temp.get(tempcounter).deepcopy());
			tempcounter++;
		}
		
    	assign(tweets, finlist);  	
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Lists combined. Tweets list:"+tweets.size());
    	
    }
    private void assign(ArrayList<tweetobject> target, ArrayList<tweetobject> source){
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Starting copy source:"+source.size()+" Target:"+target.size());
    	//target = new ArrayList<tweetobject>();
    	target.clear();
    	for(int i = 0; i<source.size(); i++)
    		target.add(source.get(i).deepcopy());
    	
    	if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false)) Log.d("RPI", "Finished copy source:"+source.size()+" Target:"+target.size());
    }
    
}