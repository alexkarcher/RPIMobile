package rpi.edu.rpimobile;

import java.util.List;

import com.actionbarsherlock.app.SherlockFragment;

import android.app.ProgressDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Looper;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.TextView;
import android.widget.Toast;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.conf.ConfigurationBuilder;

public class Fragment3 extends SherlockFragment {
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
	                Log.d("RPI","@" + status.getUser().getScreenName() + " - " + status.getText());
	            }
	        } catch (TwitterException te) {
	            te.printStackTrace();
	            Log.d("RPI","Failed to get timeline: " + te.getMessage());
	            //System.exit(-1);
	        }
				
				//dialog.dismiss();
			
			return true;
		}
		
	/*	protected void onPostExecute() {
			
			dialog.dismiss();
			
		}// */

		
		
	}
    
    
}