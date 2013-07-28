package rpi.edu.rpimobile;

import java.util.ArrayList;

import rpi.edu.rpimobile.model.CalEvent;


import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
 
public class CalendarListAdapter extends BaseAdapter {

    // Declare Variables
    Context context;
    ArrayList<CalEvent> events;
    LayoutInflater inflater;
 
    public CalendarListAdapter(Context context, ArrayList<CalEvent> events_) {
        this.context = context;
        this.events = events_;

    }
 
    @Override
    public int getCount() {
        return events.size();
    }
 
    @Override
    public Object getItem(int position) {
        return events.get(position);
    }
 
    @Override
    public long getItemId(int position) {
        return position;
    }
 
    public View getView(final int position, View convertView, ViewGroup parent) {
        // Declare Variables
        TextView txtsummary;
        TextView txttime;
        TextView txtlocation;
        
        inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View itemView = inflater.inflate(R.layout.calendar_list_item, parent,
                false);
        
        itemView.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(events.get(position).link));
				context.startActivity(browserIntent);
				
			}
		});
        
        
        // Locate the TextViews in drawer_list_item.xml
        txtsummary = (TextView) itemView.findViewById(R.id.calendarsummary);
        txttime = (TextView) itemView.findViewById(R.id.calendartime);
        txtlocation = (TextView) itemView.findViewById(R.id.calendarlocation);
        
        
        // Set the results into TextViews
        txtsummary.setText(events.get(position).summary);
        txtlocation.setText("Location: "+events.get(position).location);
        if(events.get(position).allday) txttime.setText(events.get(position).startdate +" - "+events.get(position).enddate);
        else txttime.setText(events.get(position).startdate+" "+events.get(position).starttime);
        
        // Set the results into ImageView
        
 
        return itemView;
    }
 
}