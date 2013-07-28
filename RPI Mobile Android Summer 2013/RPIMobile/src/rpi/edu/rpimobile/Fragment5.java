package rpi.edu.rpimobile;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.actionbarsherlock.app.SherlockFragment;

import rpi.edu.rpimobile.model.CalEvent;

import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Looper;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
 
public class Fragment5 extends SherlockFragment {
    
	private TextView tempview;
	private TextView cityview;
	private JSONObject jObj;
	private ArrayList<CalEvent> events;
	private CalendarListAdapter listadapter;
	
	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment5, container, false);
        
        
        events = new ArrayList<CalEvent>();
        
        ListView callist = (ListView) rootView.findViewById(R.id.calendarlist);
        listadapter = new CalendarListAdapter(this.getActivity(), events);
        callist.setAdapter(listadapter);
        
        JSONCallendarTask task = new JSONCallendarTask();
		task.execute(new String[]{"http://events.rpi.edu/webcache/v1.0/jsonDays/31/list-json/no--filter/no--object.json"});
        
		
      /*  WebView webv = (WebView) rootView.findViewById(R.id.WeatherWebView);
        webv.getSettings().setJavaScriptEnabled(true);
        webv.setWebViewClient(new WebViewClient());
        
        /*XML to add again
            <WebView
        android:id="@+id/WeatherWebView"
        android:layout_width="fill_parent"
        android:layout_height="fill_parent"
 			/> *//*
        
        
        webv.loadUrl("http://m.weather.com/weather/today/12180");
        //webv.loadUrl("http://www.google.com");*/
        
        
        
       return rootView;
    }
	private class JSONCallendarTask extends AsyncTask<String, Void, Boolean> {

		@Override
		protected Boolean doInBackground(String... params) {
			Looper.prepare();
			Log.d("RPI", "Begining Download");
			String data;
			CalEvent temp = new CalEvent();
			//Weather weather = new Weather();
			try {
			data = ( (new WeatherHttpClient()).getWeatherData(params[0]));//+"&units=imperial"));
			Log.d("RPI", "downloaded data of length "+data.length());
			}
			catch(Exception e){
				e.printStackTrace();
				Toast.makeText(getActivity(), "Calendar Download Failed", Toast.LENGTH_SHORT).show();
				return true;
			}
			try {
				//weather = JSONWeatherParser.getWeather(data);
				jObj = new JSONObject(data);
				Log.d("RPI", "Parsing items");
				
				JSONArray items = jObj.getJSONObject("bwEventList").getJSONArray("events");
				JSONObject tempJ;
				
				
				for(int i = 0; i<items.length(); i++){
					Log.d("RPI", "Adding item #"+i);
					temp = new CalEvent();
					
					tempJ = items.getJSONObject(i);
					
					Log.d("RPI", "Getting variables");
					
					temp.summary = tempJ.getString("summary");
					temp.link = tempJ.getString("eventlink");
					temp.allday = tempJ.getJSONObject("start").getBoolean("allday");
					temp.startdate = tempJ.getJSONObject("start").getString("shortdate");
					temp.starttime = tempJ.getJSONObject("start").getString("time");
					temp.enddate = tempJ.getJSONObject("end").getString("shortdate");
					temp.endtime = tempJ.getJSONObject("end").getString("time");
					temp.location = tempJ.getJSONObject("location").getString("address");
					temp.description = tempJ.getString("description");
					
					events.add(temp);
					
					Log.d("RPI", "Item saved: "+temp.summary);
				}
				
				
				
				Log.d("RPI", "Data pushed, Size: "+events.size());
				//today.icon = (new WeatherHttpClient()).getImage(tempicon);

			} catch (JSONException e) {				
				e.printStackTrace();
				//Toast.makeText(getActivity(), "Weather Download Failed", Toast.LENGTH_SHORT).show();
			}
			Log.d("RPI", "Finished Download");
			return true;

	}




	@Override
		protected void onPostExecute(Boolean results) {			
			//super.onPostExecute(weather);
			Log.d("RPI", "Updating List");
			listadapter.notifyDataSetChanged();
			
		}







  }
	
	
}