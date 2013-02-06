package com.rpi.mobile;

import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.LinearLayout;
import android.widget.Toast;

public class DirectoryActivity extends RPIActivity {
	
	LinearLayout container;
	private Suggestions suggestions;
	private Results results;
	private String rpidirectoryurl;
	private LinearLayout resultsLayout;
	
	@Override
	public void onCreate(Bundle savedInstance){
		super.onCreate(savedInstance);
		setContentView(R.layout.baselayout);
		super.setUpButtons();
		
		container = (LinearLayout) findViewById(R.id.contentContainer);
		
		rpidirectoryurl = "http://rpidirectory.appspot.com";
		
		LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		inflater.inflate(R.layout.directorylayout, container);
		
		
		((AutoCompleteTextView) findViewById(R.id.directorysearch)).addTextChangedListener((TextWatcher) new ChangeHandler());
				
		results = new Results();
		resultsLayout = (LinearLayout)findViewById(R.id.searchResults);
		//suggestions = new Suggestions();
	}
	
	
	private class ChangeHandler implements TextWatcher {
		public void onTextChanged(CharSequence s, int start, int before, int count){
			/*suggestions.cancel(true);
			suggestions.execute(rpidirectoryurl + "/suggest_api?q=" + s.toString());*/
			results.cancel(true);
			results = new Results();
			results.execute(rpidirectoryurl + "/api?q=" + s.toString());
		}

		@Override
		public void afterTextChanged(Editable s) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count,
				int after) {
			
		}
	}
	
	
	private class Results extends urlResponder {
		@Override
		protected void onPostExecute(String result){
			//Process the results received from the API and display them
			Toast.makeText(getApplicationContext(), result, Toast.LENGTH_LONG).show();
		}
	}
	
	
	private class Suggestions extends urlResponder {
		private ArrayAdapter<String> adapter;
		public Suggestions(){
			adapter = new ArrayAdapter<String>(getApplicationContext(), android.R.layout.simple_list_item_1);
		}
		
		@Override
		protected void onPreExecute(){
			adapter.clear();	
		}
		
		@Override
		protected void onPostExecute(String result){
			//Process the suggestions received from the API
			
		}
	}
	
	
	
}