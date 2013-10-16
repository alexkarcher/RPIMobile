package edu.rpi.rpimobile.model;

//Class for storing all of the variables associated with a weather call
public class Weathervars{
	public String location;
	public Float temperature;
	public Float temphigh;
	public Float templow;
	public Float percepchance;
	public String condition;
	public byte[] icon;
	
	//create method to initialize all variables
	public Weathervars(){
		location = "";
		temperature = (float)0;
		temphigh = (float)0;
		templow = (float)0;
		percepchance = (float)0;
		condition = "";
		//icon;
	}

}