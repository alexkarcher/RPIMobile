from config import URL, ID, CLASS
from bs4 import BeautifulSoup
import urllib.request, json

def index():
	LABEL = ("Room", "WashersAvailable", "DryersAvailable",
			 "WashersInUse", "DryersInUse")
			 
	url = urllib.request.urlopen(URL['LAUNDRY_URL'])
	content = url.read().decode('utf8')
	url.close()

	soup = BeautifulSoup(content)
	laundry_table = soup.find(id=ID['LAUNDRY_TABLE_ID'])
	laundry_rows = laundry_table.find_all('tr')

	laundry_json = []
	
	for row in laundry_rows:
		tds = row.find_all('td')
		room = {}
		for td in tds:
			if td.strong and td.strong.font and td.strong.font.string:
				room[LABEL[len(room)]] = str(td.strong.font.string).strip()
		if len(room) == 5:
			laundry_json.append(room)
	return json.dumps({'rooms': laundry_json})
