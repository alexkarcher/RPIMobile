package rpi.edu.rpimobile;

//import android.os.Bundle;
//import android.app.Activity;
//import android.view.Menu;

//public class MainActivity extends Activity {

//package com.androidbegin.sidemenututorial;

import com.actionbarsherlock.app.SherlockFragmentActivity;
import com.actionbarsherlock.view.Menu;
import com.actionbarsherlock.view.MenuItem;
 
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.app.Fragment;
import android.content.res.Configuration;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.widget.DrawerLayout;
import android.util.Log;
import android.view.View;
import android.webkit.WebView;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;
import android.support.v4.view.GravityCompat;
 
public class MainActivity extends SherlockFragmentActivity {
 
    // Declare Variable
    private DrawerLayout mDrawerLayout;
    private ListView mDrawerList;
    private ActionBarDrawerToggle mDrawerToggle;
    private MenuListAdapter mMenuAdapter;
    private String actiontitle;
    private String[] title;
    //private String[] subtitle;
    private int[] icon;
    private Fragment fragment1 = new Fragment1();
    private Fragment fragment2 = new Fragment2();
    private Fragment fragment3 = new Fragment3();
 
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        
        // Generate title
        title = new String[] { "Weather", "Laundry","Twitter","Athletics","Events","Shuttles","Directory","TV Listings","Building Hours",
                "Videos","Map" };
 
        // Generate subtitle
        //subtitle = new String[] { "Subtitle Fragment 1", "Subtitle Fragment 2",
         //       "Subtitle Fragment 3" };
 
        // Generate icon
        icon = new int[] { R.drawable.ic_wm_weather, R.drawable.ic_wm_laundry, R.drawable.ic_m_twitter, R.drawable.ic_wm_athletics,
        		R.drawable.ic_wm_event, R.drawable.ic_wm_shuttle, R.drawable.ic_wm_directory, R.drawable.ic_wm_tv, R.drawable.ic_wm_map,
        		R.drawable.ic_wm_video,R.drawable.ic_wm_map
                };
 
        // Locate DrawerLayout in drawer_main.xml
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
 
        // Locate ListView in drawer_main.xml
        mDrawerList = (ListView) findViewById(R.id.left_drawer);
 
        // Set a custom shadow that overlays the main content when the drawer
        // opens
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
 
        // ActionBarDrawerToggle ties together the the proper interactions
        // between the sliding drawer and the action bar app icon
        mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                R.drawable.ic_drawer, R.string.drawer_open,
                R.string.drawer_close) {
 
            public void onDrawerClosed(View view) {
                // TODO Auto-generated method stub
            	getSupportActionBar().setTitle(actiontitle);
                super.onDrawerClosed(view);
            }
 
            public void onDrawerOpened(View drawerView) {
                // TODO Auto-generated method stub
            	getSupportActionBar().setTitle(R.string.app_name);
                super.onDrawerOpened(drawerView);
            }
        };
 
        mDrawerLayout.setDrawerListener(mDrawerToggle);
 
        if (savedInstanceState == null) {
            selectItem(0);
        }
        actiontitle = title[0];
        mDrawerLayout.openDrawer(mDrawerList);
    }
 
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getSupportMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
 
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
 
        if (item.getItemId() == android.R.id.home) {

            if (mDrawerLayout.isDrawerOpen(mDrawerList)) {
                mDrawerLayout.closeDrawer(mDrawerList);
            } else {
                mDrawerLayout.openDrawer(mDrawerList);
            }
        }
 
        return super.onOptionsItemSelected(item);
    }
 
    // The click listener for ListView in the navigation drawer
    private class DrawerItemClickListener implements
            ListView.OnItemClickListener {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position,
                long id) {
            selectItem(position);
            //mDrawerList.setItemChecked(position, true);
            actiontitle = title[position];
            getSupportActionBar().setTitle(actiontitle);
        }
    }
 
    private void selectItem(int position) {
 
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
        	Toast.makeText(this, "Athletics selected", Toast.LENGTH_SHORT).show();
        	break;
        case 4: //Events
        	Toast.makeText(this, "Events selected", Toast.LENGTH_SHORT).show();
        	break;
        case 5: //Shuttles
        	Toast.makeText(this, "Shuttles selected", Toast.LENGTH_SHORT).show();
        	break;
        case 6: //Directory
        	Toast.makeText(this, "Directory selected", Toast.LENGTH_SHORT).show();
        	break;
        case 7: //TV Listings
        	Toast.makeText(this, "TV Listings selected", Toast.LENGTH_SHORT).show();
        	break;
        case 8: //Building Hours
        	Toast.makeText(this, "Building Hours selected", Toast.LENGTH_SHORT).show();
        	break;
        case 9: //Videos
        	Toast.makeText(this, "Videos selected", Toast.LENGTH_SHORT).show();
        	break;
        case 10://Map
        	Toast.makeText(this, "Map selected", Toast.LENGTH_SHORT).show();
        	break;
        
        }
        
        ft.commit();
        mDrawerList.setItemChecked(position, true);
        // Close drawer
        mDrawerLayout.closeDrawer(mDrawerList);
        
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
}
	