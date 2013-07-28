package rpi.edu.rpimobile;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;


import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.method.LinkMovementMethod;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
 
public class TweetListAdapter extends BaseAdapter {
 
    // Declare Variables
    Context context;
    ArrayList<String> avatars;
	ArrayList<String> usernames;
	ArrayList<Date> times;
	ArrayList<String> tweetbodies;
    LayoutInflater inflater;
 
    public TweetListAdapter(Context context, ArrayList<String> avatars_, ArrayList<String> usernames_, ArrayList<Date> times_, ArrayList<String> tweetbodies_) {
        this.context = context;
        this.avatars = avatars_;
        this.usernames= usernames_;
        this.times = times_;
        this.tweetbodies = tweetbodies_;
    }
 
    @Override
    public int getCount() {
        return avatars.size();
    }
 
    @Override
    public Object getItem(int position) {
        return avatars.get(position);
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
        txtusername.setText(usernames.get(position));
        txttime.setText(times.get(position).toString());
        txtbody.setText(tweetbodies.get(position));
        txtbody.setMovementMethod(LinkMovementMethod.getInstance());
        // Set the results into ImageView
        //imgIcon.setImageResource(avatars.get(position));
        File storemap = new File(this.context.getDir("avatars", Context.MODE_PRIVATE)+avatars.get(position));//declare what map image to use
		Bitmap myBitmap = BitmapFactory.decodeFile(storemap.getAbsolutePath());
		imgIcon.setImageBitmap(myBitmap);//set the map to the imageview
        
 
        return itemView;
    }
 
}