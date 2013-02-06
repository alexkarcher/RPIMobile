from config import HOST, URL, ID, CLASS, CACHE_LEN
from bs4 import BeautifulSoup
import urllib.request, json
from TeamPic import TeamPic
import database

def index(sport=None):
    if sport:
        database.clear('teampic', sport, CACHE_LEN['TEAM_PIC'])
        
        team_pic = database.getTeamPic(sport)
        if not team_pic:
            pic_url = refresh_data(sport)
            return {'url' : pic_url}
        else:
            return {'url' : team_pic}
        

def refresh_data(sport=None):
    if sport:
        database.clear('roster', sport)
        
        url = urllib.request.urlopen(URL['ATHLETICS_URL']
                                   + URL['ROSTER_PATH'] + sport)
        content = url.read().decode('utf8')
        url.close()

        soup = BeautifulSoup(content)
        
        team_pic = TeamPic()
        team_pic.setSport(sport)
        if soup.find(id=ID['TEAM_PIC_ID']):
            team_pic.setUrl(soup.find(id=ID['TEAM_PIC_ID'])['src'])
            database.save(team_pic)
    
            return team_pic.getPic()
    return None
