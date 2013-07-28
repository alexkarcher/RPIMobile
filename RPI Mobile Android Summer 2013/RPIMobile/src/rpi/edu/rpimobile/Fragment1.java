package rpi.edu.rpimobile;

import org.json.JSONException;
import org.json.JSONObject;

import com.actionbarsherlock.app.SherlockFragment;

import rpi.edu.rpimobile.model.Weather;
import rpi.edu.rpimobile.model.Weathervars;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Looper;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
 
public class Fragment1 extends SherlockFragment {
    
	private TextView tempview;
	private TextView cityview;
	private ImageView iconview;
	private JSONObject jObj;
	private Weathervars today;
	
	@Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
            Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment1, container, false);
        
        tempview = (TextView) rootView.findViewById(R.id.Temperature);
        cityview = (TextView) rootView.findViewById(R.id.City);
        iconview = (ImageView) rootView.findViewById(R.id.weathericon);
        
        tempview.setText("Loading Weather");
        cityview.setText("...");
        
        JSONWeatherTask task = new JSONWeatherTask();
		task.execute(new String[]{"Troy"});
        
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
	private class JSONWeatherTask extends AsyncTask<String, Void, Weathervars> {

		@Override
		protected Weathervars doInBackground(String... params) {
			Looper.prepare();
			Log.d("RPI", "Begining Download");
			String data;
			today = new Weathervars();
			//Weather weather = new Weather();
			try {
			data = ( (new WeatherHttpClient()).getWeatherData("http://api.openweathermap.org/data/2.5/weather?q="+params[0]));//+"&units=imperial"));
			Log.d("RPI", "downloaded data of length "+data.length());
			}
			catch(Exception e){
				e.printStackTrace();
				//Toast.makeText(getActivity(), "Weather Download Failed", Toast.LENGTH_SHORT).show();
				return today;
			}
			try {
				//weather = JSONWeatherParser.getWeather(data);
				jObj = new JSONObject(data);
				Log.d("RPI", "Setting today variables");
				today.temperature = ((float)jObj.getJSONObject("main").getDouble("temp"));
				today.location = jObj.getString("name");
				today.temphigh = (float) jObj.getJSONObject("main").getDouble("temp_max");
				today.templow = (float) jObj.getJSONObject("main").getDouble("temp_min");
				//today.percepchance = (float) jObj.
				today.condition = jObj.getJSONArray("weather").getJSONObject(0).getString("main");
				// Let's retrieve the icon
				String tempicon = jObj.getJSONArray("weather").getJSONObject(0).getString("icon");
				Log.d("RPI", "Downloading icon: "+tempicon);
				//today.icon = (new WeatherHttpClient()).getImage(tempicon);

			} catch (JSONException e) {				
				e.printStackTrace();
				//Toast.makeText(getActivity(), "Weather Download Failed", Toast.LENGTH_SHORT).show();
			}
			Log.d("RPI", "Finished Download");
			return today;

	}




	@Override
		protected void onPostExecute(Weathervars weather) {			
			super.onPostExecute(weather);
			/*Log.d("RPI", "Checking image");
			if (today.icon != null && today.icon.length > 0) {
				Log.d("RPI", "Setting Image");
				Bitmap img = BitmapFactory.decodeByteArray(today.icon, 0, today.icon.length); 
				iconview.setImageBitmap(img);
			}
			else Toast.makeText(getActivity(), "Icon Download Failed", Toast.LENGTH_SHORT).show();
			/*
			cityText.setText(weather.location.getCity() + "," + weather.location.getCountry());
			condDescr.setText(weather.currentCondition.getCondition() + "(" + weather.currentCondition.getDescr() + ")");
			temp.setText("" + Math.round((weather.temperature.getTemp() - 273.15)) + "°C");
			hum.setText("" + weather.currentCondition.getHumidity() + "%");
			press.setText("" + weather.currentCondition.getPressure() + " hPa");
			windSpeed.setText("" + weather.wind.getSpeed() + " mps");
			windDeg.setText("" + weather.wind.getDeg() + "°");*/
			if(today.location != null && today.location.length()>0){
			Log.d("RPI", "Setting temp to "+(today.temperature));
			tempview.setText("" + Math.round(((today.temperature - 273.15)*1.8)+32) + "°F");
			cityview.setText(today.condition+"\n"+today.location);
			}
			else Toast.makeText(getActivity(), "Weather Download Failed", Toast.LENGTH_SHORT).show();
		}







  }
	
	
}