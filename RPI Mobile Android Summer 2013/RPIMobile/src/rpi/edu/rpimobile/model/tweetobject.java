package rpi.edu.rpimobile.model;

import java.util.Date;

//Class for storing all of the variables associated with a twitter call
public class tweetobject{
	
	public String avatar;
	public String username;
	public Date time;
	public String body;
	
	//Deep copy method to return a new object with no links to the original
	public tweetobject deepcopy(){
		tweetobject temp = new tweetobject();
		temp.avatar = avatar;
		temp.username = username;
		temp.time = time;
		temp.body = body;
		return temp;
	}
	
}
