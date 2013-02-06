from config import URL, ID, CLASS
from bs4 import BeautifulSoup
import urllib.request, json
import urllib
#import database

#def index():
#    if sport:
#        team_pic = database.getTeamPic(sport)
#        if not team_pic:
#            pic_url = refresh_data(sport)
#            return {'url' : pic_url}
#        else:
#            return {'url' : team_pic.getPic()}
        
def refresh_data():
    
	#database.clear('teampic', sport)
	
	url = urllib.request.urlopen(URL['COMMONS_URL'])
	print(url.headers.get('content-type'))
	content = url.read().decode('iso-8859-1')
	
	url.close()

	soup = BeautifulSoup(content)
	
	print (soup.prettify())
	
	#team_pic = TeamPic()
	#team_pic.setSport(sport)
	#if soup.find(id=ID['TEAM_PIC_ID']):
	#	team_pic.setUrl(soup.find(id=ID['TEAM_PIC_ID'])['src'])
#		database.save(team_pic)

#		return team_pic.getPic()
	return None
