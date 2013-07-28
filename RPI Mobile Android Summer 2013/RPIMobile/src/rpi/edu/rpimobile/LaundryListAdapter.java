package rpi.edu.rpimobile;

import java.util.ArrayList;

import rpi.edu.rpimobile.model.Building;


import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
 
public class LaundryListAdapter extends BaseAdapter {
 
    // Declare Variables
    Context context;
    ArrayList<Building> buildings;
    LayoutInflater inflater;
 
    public LaundryListAdapter(Context context, ArrayList<Building> buildings_) {
    	Log.d("RPI", "Assigning Variables");
        this.context = context;
        this.buildings = buildings_;

    }
 
    @Override
    public int getCount() {
        return buildings.size();
    }
 
    @Override
    public Object getItem(int position) {
        return buildings.get(position);
    }
 
    @Override
    public long getItemId(int position) {
        return position;
    }
 
    public View getView(final int position, View convertView, ViewGroup parent) {
        // Declare Variables
    	Log.d("RPI", "Setting layout Inflater");
        inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View itemView = inflater.inflate(R.layout.laundry_list_item, parent,
                false);
    	
        Log.d("RPI", "Assigning Views");
        TextView txttitle = (TextView) itemView.findViewById(R.id.building_title);
        TextView txtavai_washers = (TextView) itemView.findViewById(R.id.available_washers);
        TextView txtavai_dryers = (TextView) itemView.findViewById(R.id.available_dryers);
        TextView txtused_washers = (TextView) itemView.findViewById(R.id.used_washers);
        TextView txtused_dryers = (TextView) itemView.findViewById(R.id.used_dryers);
        
        /*itemView.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				//
				
			}
		});//*/
        
        
        // Set the results into TextViews
        Log.d("RPI", "Setting Title");
        txttitle.setText(buildings.get(position).tag);
        //Log.d("RPI", "setting available washers");
        txtavai_washers.setText(String.valueOf(buildings.get(position).available_washers));
       // Log.d("RPI", "Setting available dryers");
        txtavai_dryers.setText(String.valueOf(buildings.get(position).available_dryers));
        //Log.d("RPI", "setting used washers");
        txtused_washers.setText(String.valueOf(buildings.get(position).used_washers));
       // Log.d("RPI", "settting used dryers");
        txtused_dryers.setText(String.valueOf(buildings.get(position).used_dryers));
        
        // Set the results into ImageView
        
        Log.d("RPI", "Returning view");
        return itemView;
    }
 
}