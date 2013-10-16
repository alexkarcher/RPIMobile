package edu.rpi.rpimobile.model;

import java.util.Date;

//Class for storing all of the variables associated with a RSS call
public class RSSObject {
	public String title;
	public String link;
	public Date time;
	public String category;
	
	
	public RSSObject deepcopy(){
		RSSObject copy = new RSSObject();
		copy.title = title;
		copy.link = link;
		copy.time = time;
		copy.category = category;
		
		return copy;
	}
	
}
