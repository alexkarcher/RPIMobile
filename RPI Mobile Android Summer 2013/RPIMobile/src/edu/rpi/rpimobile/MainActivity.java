package edu.rpi.rpimobile;

import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.ListView;

import com.actionbarsherlock.app.SherlockFragmentActivity;
import com.actionbarsherlock.view.Menu;
import com.actionbarsherlock.view.MenuItem;
import com.google.android.youtube.player.YouTubeIntents;
 
//MainActivity. Holds the navagation drawer and the fragment frame
public class MainActivity extends SherlockFragmentActivity {
 
    // Declare Variables to be used in this function
    private DrawerLayout mDrawerLayout;
    private ListView mDrawerList;
    private ActionBarDrawerToggle mDrawerToggle;
    private MenuListAdapter mMenuAdapter;
    private String actiontitle;
    private String[] title;
    private int[] icon;
    private Fragment fragment1 = new Fragment1();
    private Fragment fragment2 = new Fragment2();
    private Fragment fragment3 = new Fragment3();
    private Fragment fragment4 = new Fragment4();
    private Fragment fragment5 = new Fragment5();
    //private Fragment fragment6 = new Fragment6();
    
  //Initial function
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        logcat( "Start onCreate");
        //Allow the action bar to display indeterminate progress
        requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
        
        //Set the view to show the activity_main xml file
        setContentView(R.layout.activity_main);
        
        // Generate title array
        title = new String[] { "Weather", "Laundry","Twitter","Athletics","Events"/*,"Shuttles","Directory"
        		,"TV Listings","Building Hours","Map"*/,"Videos" };
 
        // Generate icon array
        icon = new int[] { R.drawable.ic_wm_weather, R.drawable.ic_wm_laundry, R.drawable.ic_m_twitter, R.drawable.ic_wm_athletics,
        		R.drawable.ic_wm_event,/* R.drawable.ic_wm_shuttle, R.drawable.ic_wm_directory, R.drawable.ic_wm_tv, 
        		R.drawable.ic_wm_map, R.drawable.ic_wm_map,*/ R.drawable.ic_wm_video
                };
 
        // Locate DrawerLayout in drawer_main.xml
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
 
        // Locate ListView in drawer_main.xml
        mDrawerList = (ListView) findViewById(R.id.left_drawer);
 
        // Set a custom shadow that overlays the main content when the drawer opens
        mDrawerLayout.setDrawerShadow(R.drawable.drawer_shadow,
                GravityCompat.START);
 
        // Pass results to MenuListAdapter Class
        mMenuAdapter = new MenuListAdapter(this, title, icon);
 
        // Set the MenuListAdapter to the ListView
        mDrawerList.setAdapter(mMenuAdapter);
 
        // Capture button clicks on side menu
        mDrawerList.setOnItemClickListener(new DrawerItemClickListener());
        
        // Enable ActionBar app icon to behave as action to toggle nav drawer
        getSupportActionBar().setHomeButtonEnabled(true);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
 
        // ActionBarDrawerToggle ties together the proper interactions
        // between the sliding drawer and the action bar app icon
        mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                R.drawable.ic_drawer, R.string.drawer_open,
                R.string.drawer_close) {
 
            public void onDrawerClosed(View view) {
            	getSupportActionBar().setTitle(actiontitle);
                super.onDrawerClosed(view);
            }
 
            public void onDrawerOpened(View drawerView) {
            	getSupportActionBar().setTitle(R.string.app_name);
                super.onDrawerOpened(drawerView);
            }
        };
        
        mDrawerLayout.setDrawerListener(mDrawerToggle);
        
        //retrieve the startup screen preference
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
        int startupscreen = Integer.parseInt(prefs.getString("startuppref", "0"));
        
        logcat( "Loading screen: " + startupscreen);
        
        //if the preference is to load the menu then open the navagation drawer
        if (savedInstanceState == null) {
        	if(startupscreen==0){
            selectItem(0);
            actiontitle = title[0];
            mDrawerLayout.openDrawer(mDrawerList);
            }
        	else{
        		//if the user selected a specific screen then load that.
        		selectItem(startupscreen-1);
        		actiontitle = title[startupscreen-1];
        		getSupportActionBar().setTitle(actiontitle);
        	}
        		
        }
        else{
        	logcat( "savedInstance state wasn't null");
        }
        
        logcat( "Oncreate ran");
    }
 
    
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
    	//Class called when the options menu is populated
    	logcat( "Inflating Menu");
    	//Inflate the menu xml file
        getSupportMenuInflater().inflate(R.menu.main, menu);
        logcat( "Menu inflated");
        return true;
    }
 
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
    	//Class called when a menu item is selected
    	logcat( "MainAvtivity onOptions Selected");
        if (item.getItemId() == android.R.id.home) {
        	//If the home button is pressed then toggle the drawer open state
            if (mDrawerLayout.isDrawerOpen(mDrawerList)) {
                mDrawerLayout.closeDrawer(mDrawerList);
            } else {
                mDrawerLayout.openDrawer(mDrawerList);
            }
        }
        else if(item.getItemId() == R.id.action_settings){
        	//if the settings button is pressed then open the settings activity
        	Intent intent = new Intent(MainActivity.this, PrefsActivity.class);
        	startActivity(intent);
        }
      /*  else if(item.getIcon().equals(R.drawable.navigation_refresh)){
        	logcat("Mainactivity handled refreshbutton");
        	
        	
        }*/
 
        return super.onOptionsItemSelected(item);
    }
 
    // The click listener for ListView in the navigation drawer
    private class DrawerItemClickListener implements
            ListView.OnItemClickListener {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position,
                long id) {
        	//if one of the drawer items is clicked then launch that fragment
            selectItem(position);
            mDrawerList.setItemChecked(position, true);
            //if the item was the youtube feed then don't change the action bar title
            if(position!=5) actiontitle = title[position];
            getSupportActionBar().setTitle(actiontitle);
        }
    }
    //Function that takes the selected item and launches the respective activity
    private void selectItem(int position) {
    	logcat( "Beginnning fragment Transaction");
        FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
        // Locate Position
        switch (position) {
        case 0: //weather
            ft.replace(R.id.content_frame, fragment1);
            break;
        case 1: //laundry
            ft.replace(R.id.content_frame, fragment2);
            break;
        case 2: //twitter
            ft.replace(R.id.content_frame, fragment3);
            break;
        case 3: //athletics
        	ft.replace(R.id.content_frame, fragment4);
        	break;
        case 4: //Events
        	ft.replace(R.id.content_frame, fragment5);
        	break;
        //these are the future items. They will be uncommented as they are implemented	
        	
 /*       case 5: //Shuttles
        	Toast.makeText(this, "Shuttles selected", Toast.LENGTH_SHORT).show();
        	break;
        case 6: //Directory
        	Toast.makeText(this, "Directory selected", Toast.LENGTH_SHORT).show();
        	break;
        case 7: //TV Listings
	   		ft.replace(R.id.content_frame, fragment6);
        	break;
        case 8: //Building Hours
        	Toast.makeText(this, "Building Hours selected", Toast.LENGTH_SHORT).show();
        	break;
        case 9://Map
        	Toast.makeText(this, "Map selected", Toast.LENGTH_SHORT).show();
        	break; //*/
        case 5: //Videos
        	//the Youtube feed just opens the external youtube application
        	Intent i = YouTubeIntents.createUserIntent(this, "rpirensselaer");
        	startActivity(i);
        	break;
        
        }
        
        ft.commit();
        mDrawerList.setItemChecked(position, true);
        // Close drawer
        mDrawerLayout.closeDrawer(mDrawerList);
        logcat( "Fragment Transaction finished");
        switch(position){
        case 2:
        	
            break;
        
        }
    }
 
    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        // Sync the toggle state after onRestoreInstanceState has occurred.
        mDrawerToggle.syncState();
    }
 
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        // Pass any configuration change to the drawer toggles
        mDrawerToggle.onConfigurationChanged(newConfig);
    }
    private void logcat(String logtext){
		//code to write a log.d message if the user allows it in preferences
		if(PreferenceManager.getDefaultSharedPreferences(this).getBoolean("debugging", false))
			Log.d("RPI", logtext);
	}
}
	