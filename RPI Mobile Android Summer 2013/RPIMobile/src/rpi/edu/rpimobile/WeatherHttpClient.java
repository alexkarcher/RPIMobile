package rpi.edu.rpimobile;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class WeatherHttpClient {
	
	
	
	private static String IMG_URL = "http://openweathermap.org/img/w/";

	//function to pull a string of data from an http address
	public String getWeatherData(String location) {
		//initial variables
		HttpURLConnection con = null ;
		InputStream is = null;

		try {
			//create a connection, set its parameters, and open it
			con = (HttpURLConnection) ( new URL(location)).openConnection();
			con.setRequestMethod("GET");
			con.setDoInput(true);
			con.setDoOutput(true);
			con.connect();

			//Read the response
			StringBuffer buffer = new StringBuffer();
			is = con.getInputStream();
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			String line = null;
			while (  (line = br.readLine()) != null )
				buffer.append(line + "\r\n");
			//close the Stringbuffer and http connection
			is.close();
			con.disconnect();
			return buffer.toString();
	    }
		catch(Throwable t) {
			t.printStackTrace();
		}
		finally {
			try { is.close(); } catch(Throwable t) {}
			try { con.disconnect(); } catch(Throwable t) {}
		}

		return null;

	}
	//Code to download the OpenWeatherMap icon
	public byte[] getImage(String code) {
		//create variables
		HttpURLConnection con = null ;
		InputStream is = null;
		try {
			//create http connection, setup parameters, and open the connection
			con = (HttpURLConnection) ( new URL(IMG_URL + code)).openConnection();
			con.setRequestMethod("GET");
			con.setDoInput(true);
			con.setDoOutput(true);
			con.connect();

			//Read the response
			is = con.getInputStream();
			byte[] buffer = new byte[1024];
			ByteArrayOutputStream baos = new ByteArrayOutputStream();

			while ( is.read(buffer) != -1)
				baos.write(buffer);
			
			return baos.toByteArray();
	    }
		catch(Throwable t) {
			t.printStackTrace();
		}
		finally {
			try { is.close(); } catch(Throwable t) {}
			try { con.disconnect(); } catch(Throwable t) {}
		}

		return null;

	}
}