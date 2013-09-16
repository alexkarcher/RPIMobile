package rpi.edu.rpimobile;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.util.ByteArrayBuffer;

import com.actionbarsherlock.app.SherlockFragment;
import com.actionbarsherlock.view.Menu;
import com.actionbarsherlock.view.MenuInflater;
import com.actionbarsherlock.view.MenuItem;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
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
	
	//All variables to be used throughout the function
	
	private tweetobject temp = new tweetobject();
	private ArrayList<tweetobject> tweets = new ArrayList<tweetobject>();
	private ArrayList<tweetobject> temptweets = new ArrayList<tweetobject>();
	
	private ArrayList<tweetobject> finlist = new ArrayList<tweetobject>();
	
	private ListView tweetlist;
	private TweetListAdapter tweetadapter;
	Bitmap bmImg = null;
	private MenuItem refreshbutton;
	private AsyncTask downloadtask;
	
	//Initial function
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
    	//Inflate the layout into the parent view of container view of the parent class
        View rootView = inflater.inflate(R.layout.fragment3, container, false);
        
        //Allow this fragment to interact with the menu
        setHasOptionsMenu(true);
        
        //Assign the tweets variable to a new Arraylist of tweetobject objects
        tweets = new ArrayList<tweetobject>();
        
        //Set the listview to an adapter to handle displaying the data
        tweetlist = (ListView) rootView.findViewById(R.id.tweetlist);
        tweetadapter = new TweetListAdapter(this.getActivity(), tweets);
        tweetlist.setAdapter(tweetadapter);
        //Initialize the download cycle to 0
        cyclenum = 0;
        //make a toast message to be used later in the activity
        tst = Toast.makeText(getActivity(), "Downloading @RPInews", Toast.LENGTH_SHORT);
        //start the download cycle
        refreshcycle();

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
    
    //Class called when an options item is selected
  	public boolean onOptionsItemSelected(MenuItem item) {
  		logcat( "Fragment3: onOptionsItemSelected");
  		//If the refresh button was pressed
          if (item == refreshbutton){
          	//refresh the tweets
          	refreshcycle();
          	
          }
        //This passes the call back up the chain to the main class, which also handles onOptionsitemSeleced events
          return super.onOptionsItemSelected(item);
      }
    
    //Persistent variables to be used in the refreshcycle() function
    private int cyclenum;
    private Toast tst;
    
    //A class to handle loading the different twitter feeds
    public void refreshcycle(){

    	SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(getActivity());
    	 
    	//This class cycles through the 7 possible twitter feeds, loading each one
    	//There is a more efficient version of this in the sports news fragment. One day I will replace this mess with that version. 
    	switch(cyclenum){
    	case 0:
    		//On the first item set the action bar to show indeterminate progress, usually a spinner
    		getActivity().setProgressBarIndeterminateVisibility(Boolean.TRUE);
    		//increment the cycle counter
    		cyclenum++;
    		//clear the tweets list for the first item
    		tweets.clear();
    		//if the user wants to download this feed
    		if(prefs.getBoolean("twitter_rensselaer", true)){
    			//One toast object is used so that it can be canceled on the completion of the downloads
    			tst.setText("Downloading @rensselaer");
	    		tst.show();
	    		//download the feed
    			downloadtask = new Fragment3.Download().execute("rensselaer");
    		}
    		else{
    			//if the user doesn't want to download this feed then continue the cycle
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
    		//for the last item reset the action bar progress state
    		getActivity().setProgressBarIndeterminateVisibility(Boolean.FALSE);
    		//cancel the toast message. This prevents it from lingering after the download has completed
    		tst.cancel();
    		logcat( "Loading complete List size:"+tweets.size());
    		//reset the cycle counter
    		cyclenum=0;
    		break;
    	}
    	
    }
	
	
	//Async Thread to download the twitter data in the background
    private class Download extends AsyncTask<String, Void, Boolean>{
		
    	
    	//placeholder for future use
    	protected void onPreExecute(){
			
		}
    	
    	//Class to be ran in another thread
		@Override
		protected Boolean doInBackground(String... params) {
			//clear the temporary list
			temptweets.clear();
			
			//I am using the twitter4j class to handle all twitter API calls
			//start a new configuration builder and pass it my developer keys
			ConfigurationBuilder cb = new ConfigurationBuilder();
	        cb.setDebugEnabled(true)
	          .setOAuthConsumerKey("UBhESaJGlMUwE0wy8bCTnw")
	          .setOAuthConsumerSecret("5e0xeE2wz1sthi9Lt0ibsSzYA4umS36yo7abNW4Egg")
	          .setOAuthAccessToken("15919642-JjVKhEkfEpjrd0es3PGGnaa8vfEvUN4JG0qdPxsiP")
	          .setOAuthAccessTokenSecret("XZ0tofnuEgWlPbToJoN3c2ZdDiKBcBi3U3CyPqxGR4");
	        //start the necessary classes to get tweets
	        TwitterFactory tf = new TwitterFactory(cb.build());
	        Twitter twitter = tf.getInstance();
	        
	        try {
	        	//create a list of statuses and populate them with the statuses from the passed user
	            List<twitter4j.Status> statuses;
	            String user = params[0];
	            statuses = twitter.getUserTimeline(user);
	            logcat( "Showing @" + user + "'s user timeline.");
	            
	            //loop through each status and write it to the temporary list
	            for (twitter4j.Status status : statuses) {
	            	logcat( "Looping status");
	            	//temp object
	            	temp = new tweetobject();
	            	String avatarurl;
	            	//status must be handled differently if it is normal or a retweet
	            	if(!status.isRetweet()){
	            		temp.username = status.getUser().getScreenName();
	            		temp.body = status.getText();
	            		avatarurl = status.getUser().getProfileImageURL();
	            	}
	            	else{
	            		//if the status is a retweet get the original poster's information and append a RT message to the end of the body
	            		temp.username = status.getRetweetedStatus().getUser().getScreenName();
	            		temp.body = ""+status.getRetweetedStatus().getText()+"\nRetweeted by @"+status.getUser().getScreenName();
	            		avatarurl = status.getRetweetedStatus().getUser().getProfileImageURL();
	            	}
	            	temp.time = status.getCreatedAt();
	            	
	            	//download profile picture
	            	logcat( "Calling download class");
					downloadFromUrl(avatarurl,temp.username);
					
					//the file name of the avatar is just the username
					temp.avatar = temp.username;
					
					//add the tweet object to the temporary lists
					temptweets.add(temp);
					
	            }
	            logcat( "Tweets Loaded");
	        } catch (TwitterException te) {
	            te.printStackTrace();
	            logcat("Failed to get timeline: " + te.getMessage());
	            //System.exit(-1);
	        }
	        
	        logcat( "Exiting AsynchTask");
			return true;
		}
		
		protected void onPostExecute(Boolean results) {
			//code to be ran in the UI thread after the background thread has completed
			
			//Combine the temp list with the tweet list
			logcat( "Adding to list");
			addtotweets(temptweets);
			
			logcat( "Notifying list Tweets.size(): "+tweets.size());
			logcat( "First item:"+tweets.get(0).body);
			
			
			try{
				//Notify the listadapter to update the data
				tweetadapter.notifyDataSetChanged();
			}
			catch(Exception e){
				logcat( e.toString());
			}
			//continue the refresh cycle
			refreshcycle();
		}

		
		
	}
    
    //Code to download an image from a URL
    private boolean downloadFromUrl(String imageURL, String fileName) {
        try {//begin try
        	logcat( "Begin downloadFromUrl method");
        		URL url = new URL(imageURL); //link to file
                //getActivity();
				//Create the file to store the image in
        		File file = new File(getActivity().getDir("avatars", Context.MODE_PRIVATE)+fileName);
				
				//if we don't need to create a new file
                if(!file.createNewFile()){
                	//if the image is less than 1 day old assume it's up to date and move on.
                	if(file.lastModified()>System.currentTimeMillis()-86400000){
                    	logcat( "File exists recentely, quitting download");
                    	return true;
                	}
                }
                
                
                
                long startTime = System.currentTimeMillis();
                logcat( "download begining");
                logcat( "download url:" + url);
                logcat( "downloaded file name:" + fileName);
                //Open a connection to the URL.
                URLConnection ucon = url.openConnection();

                //Define InputStreams to read from the URLConnection.
                InputStream is = ucon.getInputStream();
                BufferedInputStream bis = new BufferedInputStream(is);

                //Read bytes to the Buffer until there is nothing more to read(-1).
                ByteArrayBuffer baf = new ByteArrayBuffer(50);
                int current = 0;
                while ((current = bis.read()) != -1) {//begin while
                        baf.append((byte) current);
                }//end while

                //Convert the Bytes read to an output stream which drops them into our image
                FileOutputStream fos = new FileOutputStream(file);
                fos.write(baf.toByteArray());
                fos.close();
                logcat( "download time elapsed"
                                + ((System.currentTimeMillis() - startTime))
                                + " mill sec");
                logcat( "Download Successful");
                return true;
                
        }//end try 
        catch (IOException e) {//begin catch
                logcat( "Error: " + e);
                return false;
        }//end catch
        
        
}
    
    //Class to add tweets to the "tweets" list
    private void addtotweets(ArrayList<tweetobject> temp){
    	
    	logcat("Combining lists");
    	logcat("Tweets list: "+tweets.size()+" Temp list: "+temp.size());
    	
    	//start each counter at 0
    	int tweetcounter = 0;
    	int tempcounter = 0;
    	
    	//temporary list
    	finlist.clear();
    	
    	//loop through each list, adding them, most recent first, to the temp list
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
    	
    	//add the remaining objects to the list
		while(tweetcounter<tweets.size()){
			finlist.add(tweets.get(tweetcounter).deepcopy());
			tweetcounter++;
		}
		while(tempcounter<temp.size()){
			finlist.add(temp.get(tempcounter).deepcopy());
			tempcounter++;
		}
		
		//Assign the temporary list to the "tweets" list
    	assign(tweets, finlist);  	
    	logcat( "Lists combined. Tweets list:"+tweets.size());
    	
    }
    
    //Class to deal with the problem of copying ArrayLists in Java
    //Because ArrayLists really just store pointers to their objects a deepcopy must be made of each
    //item and passed to the list individually. This is much more efficient than using the 
    //java.serialize class to do this automatically.
    private void assign(ArrayList<tweetobject> target, ArrayList<tweetobject> source){
    	logcat( "Starting copy source:"+source.size()+" Target:"+target.size());
    	//clear the target list
    	target.clear();
    	for(int i = 0; i<source.size(); i++)
    		//add a deepcopy of each item to the target list
    		target.add(source.get(i).deepcopy());
    	
    	logcat( "Finished copy source:"+source.size()+" Target:"+target.size());
    }
    
	private void logcat(String logtext){
		//code to write a log.d message if the user allows it in preferences
		if(PreferenceManager.getDefaultSharedPreferences(getActivity()).getBoolean("debugging", false))
			Log.d("RPI", logtext);
	}
    
}