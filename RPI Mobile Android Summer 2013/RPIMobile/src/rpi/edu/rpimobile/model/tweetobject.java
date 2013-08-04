package rpi.edu.rpimobile.model;

import java.util.Date;

public class tweetobject implements java.io.Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public String avatar;
	public String username;
	public Date time;
	public String body;

	public tweetobject deepcopy(){
		tweetobject temp = new tweetobject();
		temp.avatar = avatar;
		temp.username = username;
		temp.time = time;
		temp.body = body;
		return temp;
	}
	
}
