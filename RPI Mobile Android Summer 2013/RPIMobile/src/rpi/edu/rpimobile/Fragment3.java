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

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.conf.ConfigurationBuilder;


public class Fragment3 extends SherlockFragment {
	
	private ArrayList<String> avatars;
	private ArrayList<String> usernames;
	private ArrayList<Date> times;
	private ArrayList<String> tweetbodies;
	private ListView tweetlist;
	private TweetListAdapter tweetadapter;
	private URL url;
	Bitmap bmImg = null;
	
	private ArrayList<Bitmap> bmpavatars;
	
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment3, container, false);

        
   /*     Log.d("Debug", "Declaring webview");
    	WebView twitterweb = (WebView) rootView.findViewById(R.id.twitterwebview);
    	twitterweb.getSettings().setJavaScriptEnabled(true);
    	twitterweb.setActivated(false);
    	Log.d("Debug", "Loading webview");
        //twitterweb.loadUrl("https://mobile.twitter.com/rensselaer");
        Log.d("Debug", "Webview Loaded");
        
        TextView maintext = (TextView) rootView.findViewById(R.id.twittertextview);
        
        */
        avatars = new ArrayList<String>();
        usernames = new ArrayList<String>();
        times = new ArrayList<Date>();
        tweetbodies = new ArrayList<String>();
        
        tweetlist = (ListView) rootView.findViewById(R.id.tweetlist);
        tweetadapter = new TweetListAdapter(this.getActivity(), avatars, usernames, times, tweetbodies);
        tweetlist.setAdapter(tweetadapter);
        new Fragment3.Download().execute(5.0);
        
        
        
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
	            String user = "rensselaer";
	            statuses = twitter.getUserTimeline(user);
	            Log.d("RPI", "Showing @" + user + "'s user timeline.");
	            for (twitter4j.Status status : statuses) {
	            	Log.d("RPI", "Looping status");
	            	String username;
	            	String tweetbody;
	            	String avatarurl;
	            	if(!status.isRetweet()){
	            		username = status.getUser().getScreenName();
	            		tweetbody = status.getText();
	            		avatarurl = status.getUser().getProfileImageURL();
	            	}
	            	else{
	            		username = status.getRetweetedStatus().getUser().getScreenName();
	            		tweetbody = ""+status.getRetweetedStatus().getText()+"\nRetweeted by @"+status.getUser().getScreenName();
	            		avatarurl = status.getRetweetedStatus().getUser().getProfileImageURL();
	            	}
	            	//avatars.add(R.drawable.rpi_buzz);//status.getUser().getProfileImageURL());
	            	usernames.add(username);
	            	times.add(status.getCreatedAt());
	            	tweetbodies.add(tweetbody);
	                //Log.d("RPI","@" + status.getUser().getScreenName() + " - " + status.getText()+" Is a Retweet:"+status.isRetweet());
	                //if(status.isRetweet())Log.d("RPI", "Retweet from: "+status.getRetweetedStatus().getUser().getScreenName()+" Retweeted text:"+status.getRetweetedStatus().getText());
	            	
	            	//download profile picture if it doesn't exist
	            	
	            	Log.d("RPI", "Calling download class");
					downloadFromUrl(avatarurl,username);
					
					avatars.add(username);
					
	            }
	            Log.d("RPI", "Tweets Loaded");
	        } catch (TwitterException te) {
	            te.printStackTrace();
	            Log.d("RPI","Failed to get timeline: " + te.getMessage());
	            //System.exit(-1);
	        }
				
	 /*       Log.d("RPI", "Notifying Adapter");
			tweetadapter.notifyDataSetChanged();
			Log.d("RPI", "Notifying list");
			//tweetlist.refreshDrawableState(); */
	        Log.d("RPI", "Exiting AsynchTask");
			return true;
		}
		
		protected void onPostExecute(Boolean results) {
			
			Log.d("RPI", "Notifying list");
			tweetadapter.notifyDataSetChanged();
			//dialog.dismiss();
			//return true;
		}//*/ 

		
		
	}
    
    private boolean downloadFromUrl(String imageURL, String fileName) {  //begin downloader public void
        try {//begin try
        	Log.d("RPI", "Begin downloadFromUrl method");
        		URL url = new URL(imageURL); //link to file
                getActivity();
				File file = new File(getActivity().getDir("avatars", Context.MODE_PRIVATE)+fileName);
                if(!file.createNewFile()){
                	if(file.lastModified()>System.currentTimeMillis()-86400000){//if the image is less than 1 day old assume it's up to date and move on.
                    	Log.d("RPI", "File exists recentely, quitting download");
                    	return true;
                	}
                }
                
                
                
                long startTime = System.currentTimeMillis();
                Log.d("RPI", "download begining");
                Log.d("RPI", "download url:" + url);
                Log.d("RPI", "downloaded file name:" + fileName);
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
                Log.d("RPI", "download time elapsed"
                                + ((System.currentTimeMillis() - startTime))
                                + " mill sec");
                Log.d("RPI", "Download Successful");
                return true;
                
        }//end try 
        catch (IOException e) {//begin catch
                Log.d("RPI", "Error: " + e);
                return false;
        }//end catch
        
        
}//end downloader public void
    
}