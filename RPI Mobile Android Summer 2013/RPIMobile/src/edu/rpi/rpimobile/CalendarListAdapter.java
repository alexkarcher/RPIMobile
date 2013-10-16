package edu.rpi.rpimobile;

import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import edu.rpi.rpimobile.model.CalEvent;
 
public class CalendarListAdapter extends BaseAdapter {

    // Declare Variables
    private Context context;
    private ArrayList<CalEvent> events;
    private LayoutInflater inflater;
    
    public CalendarListAdapter(Context context, ArrayList<CalEvent> events_) {
    	//Assign passed list and context to local variables in the class 
        this.context = context;
        this.events = events_;

    }
 
    @Override
    public int getCount() {
    	//Method to tell Android the amount of items in the list
        return events.size();
    }
 
    
    //These functions are not used in the current implementation
    @Override
    public Object getItem(int position) {
        return events.get(position);
    }
 
    @Override
    public long getItemId(int position) {
        return position;
    }
 
    //Function to populate an item in the list
    public View getView(final int position, View convertView, ViewGroup parent) {
        // Declare Variables
        TextView txtsummary;
        TextView txttime;
        TextView txtlocation;
        
        
        //inflate the layout into the parent view
        inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View itemView = inflater.inflate(R.layout.calendar_list_item, parent,
                false);
        
        //set an OnClickListener on the parent view to launch a link intent when clicked 
        itemView.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(events.get(position).link));
				context.startActivity(browserIntent);
				
			}
		});
        
        
        // Locate the TextViews in xml layout
        txtsummary = (TextView) itemView.findViewById(R.id.calendarsummary);
        txttime = (TextView) itemView.findViewById(R.id.calendartime);
        txtlocation = (TextView) itemView.findViewById(R.id.calendarlocation);
        
        
        // Set the results into TextViews
        txtsummary.setText(events.get(position).summary);
        txtlocation.setText("Location: "+events.get(position).location);
        
        //the time is displated differently for allday events and hourly events
        if(events.get(position).allday) txttime.setText(events.get(position).startdate +" - "+events.get(position).enddate);
        else txttime.setText(events.get(position).startdate+" "+events.get(position).starttime);        
 
        //pass the populated view back to the ListView
        return itemView;
    }
 
}