package rpi.edu.rpimobile.model;

import android.os.Parcel;
import android.os.Parcelable;

public class Weathervars implements Parcelable{
	public String location;
//	public Float lat;
//	public Float lon;
	public Float temperature;
	public Float temphigh;
	public Float templow;
	public Float percepchance;
	public String condition;
	public byte[] icon;
	
	public Weathervars(){
		location = "";
		temperature = (float)0;
		temphigh = (float)0;
		templow = (float)0;
		percepchance = (float)0;
		condition = "";
		//icon;
	}
	
	public Weathervars(Parcel in) {
		// TODO Auto-generated constructor stub
	}
	@Override
	public int describeContents() {
		// TODO Auto-generated method stub
		return 0;
	}
	@Override
	public void writeToParcel(Parcel dest, int flags) {
		// TODO Auto-generated method stub
		
	}
	
	public static final Parcelable.Creator CREATOR = new Parcelable.Creator() {
		          public Weathervars createFromParcel(Parcel in) {
		        	  return new Weathervars(in); 
		           }
		   
		          public Weathervars[] newArray(int size) {
		             return new Weathervars[size];
		          }
		     };
	
	
}
