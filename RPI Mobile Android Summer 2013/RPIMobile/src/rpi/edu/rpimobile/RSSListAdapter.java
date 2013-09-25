package rpi.edu.rpimobile;

import java.text.SimpleDateFormat;
import java.util.ArrayList;

import rpi.edu.rpimobile.model.RSSObject;


import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
 
public class RSSListAdapter extends BaseAdapter {
 
    // Declare Variables
    Context context;
    Fragment4 fragment;
	ArrayList<RSSObject> items;
    LayoutInflater inflater;
 
    public RSSListAdapter(Context context, Fragment4 fragment_, ArrayList<RSSObject> items_) {
    	//Assign passed list and context to local variables in the class
        this.context = context;
        this.fragment = fragment_;
        this.items = items_;

    }
 
    @Override
    public int getCount() {
    	//Method to tell Android the amount of items in the list
    	
    	//uncomment the +1 when there is an actual loading message to display
        return items.size();//+1;
    }
 
  //These functions are not used in the current implementation
    @Override
    public Object getItem(int position) {
        return items.get(position);
    }
 
    @Override
    public long getItemId(int position) {
        return position;
    }
 
    public View getView(final int position, View convertView, ViewGroup parent) {
        // Declare Variables
        TextView txttitle;
        TextView txtheading;
        
      //inflate the layout into the parent view
        View itemView;
        
        //if we're viewing an item in the list load an object like normal
        if(position!=items.size()){
        inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        itemView = inflater.inflate(R.layout.rss_list_item, parent,
                false);
        
      //set an OnClickListener on the parent view to launch a link intent when clicked 
        itemView.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(items.get(position).link));
				context.startActivity(browserIntent);
				
			}
		});
        
        
        // Locate the TextViews in rss_list_item.xml
        txttitle = (TextView) itemView.findViewById(R.id.rsstitle);
        txtheading = (TextView) itemView.findViewById(R.id.rssheading);
        
        // Set the results into TextViews
        txttitle.setText(items.get(position).title);

        //convert the date/time to the correct format
        SimpleDateFormat dtime = new SimpleDateFormat("h:mm a, MMM d");
        txtheading.setText(items.get(position).category+" | "+dtime.format(items.get(position).time));
        
        }
        //if we're viewing the end of the list show a loading message
        else{
        	//
        	inflater = (LayoutInflater) context
                    .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            itemView = inflater.inflate(R.layout.loading_list_item, parent,
                    false);
            //call back the original function to actually load the next page
            fragment.loadpage(1);
        }
 
        return itemView;
    }
 
}