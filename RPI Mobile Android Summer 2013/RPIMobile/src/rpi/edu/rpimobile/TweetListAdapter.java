package rpi.edu.rpimobile;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import rpi.edu.rpimobile.model.tweetobject;


import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.method.LinkMovementMethod;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
 
public class TweetListAdapter extends BaseAdapter {
 
    // Declare Variables
    Context context;
	ArrayList<tweetobject> tweets;
    LayoutInflater inflater;
 
    public TweetListAdapter(Context context, ArrayList<tweetobject> tweets_) {
        this.context = context;
        this.tweets = tweets_;
    }
 
    @Override
    public int getCount() {
    	//if(PreferenceManager.getDefaultSharedPreferences(this.context).getBoolean("debugging", false)) Log.d("RPI", "Tweetlist Size:"+tweets.size());
        return tweets.size();
    }
 
    @Override
    public Object getItem(int position) {
        return tweets.get(position);
    }
 
    @Override
    public long getItemId(int position) {
        return position;
    }
 
    public View getView(int position, View convertView, ViewGroup parent) {
        // Declare Variables
        TextView txtusername;
        TextView txttime;
        TextView txtbody;
        ImageView imgIcon;
 
        inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View itemView = inflater.inflate(R.layout.twitter_list_item, parent,
                false);
 
        // Locate the TextViews in drawer_list_item.xml
        txtusername = (TextView) itemView.findViewById(R.id.username);
        txttime = (TextView) itemView.findViewById(R.id.timestamp);
        txtbody = (TextView) itemView.findViewById(R.id.content);
        // Locate the ImageView in drawer_list_item.xml
        imgIcon = (ImageView) itemView.findViewById(R.id.avatar);
        
        // Set the results into TextViews
        txtusername.setText(tweets.get(position).username);
        
        //Format the date/time correctly
        SimpleDateFormat dtime = new SimpleDateFormat("h:mm a, MMM d");
        txttime.setText(dtime.format(tweets.get(position).time));
        
        txtbody.setText(tweets.get(position).body);
        txtbody.setMovementMethod(LinkMovementMethod.getInstance());
        // Set the results into ImageView
        //imgIcon.setImageResource(avatars.get(position));
        File storemap = new File(this.context.getDir("avatars", Context.MODE_PRIVATE)+tweets.get(position).avatar);//declare what map image to use
		Bitmap myBitmap = BitmapFactory.decodeFile(storemap.getAbsolutePath());
		imgIcon.setImageBitmap(myBitmap);//set the map to the imageview
        
 
        return itemView;
    }
 
}