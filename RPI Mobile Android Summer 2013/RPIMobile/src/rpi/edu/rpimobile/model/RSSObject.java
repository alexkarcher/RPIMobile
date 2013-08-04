package rpi.edu.rpimobile.model;

import java.util.Date;

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
