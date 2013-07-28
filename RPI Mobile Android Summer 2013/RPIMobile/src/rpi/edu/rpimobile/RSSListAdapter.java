package rpi.edu.rpimobile;

import java.util.ArrayList;


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
    ArrayList<String> titles;
	ArrayList<String> links;
	ArrayList<String> times;
    LayoutInflater inflater;
 
    public RSSListAdapter(Context context, ArrayList<String> titles_, ArrayList<String> links_, ArrayList<String> times_) {
        this.context = context;
        this.titles = titles_;
        this.times = times_;
        this.links= links_;

    }
 
    @Override
    public int getCount() {
        return titles.size();
    }
 
    @Override
    public Object getItem(int position) {
        return titles.get(position);
    }
 
    @Override
    public long getItemId(int position) {
        return position;
    }
 
    public View getView(final int position, View convertView, ViewGroup parent) {
        // Declare Variables
        TextView txttitle;
        TextView txtheading;
        
        inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View itemView = inflater.inflate(R.layout.rss_list_item, parent,
                false);
        
        itemView.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(links.get(position)));
				context.startActivity(browserIntent);
				
			}
		});
        
        
        // Locate the TextViews in drawer_list_item.xml
        txttitle = (TextView) itemView.findViewById(R.id.rsstitle);
        txtheading = (TextView) itemView.findViewById(R.id.rssheading);
        
        // Set the results into TextViews
        txttitle.setText(titles.get(position));
        txtheading.setText("General | "+times.get(position));
        
        // Set the results into ImageView
        
 
        return itemView;
    }
 
}