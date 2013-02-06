from config import URL
from Row import Row
import json, time

class TeamPic(Row):
    _id = None
    _sport = None
    _url = None
    
    def setUrl(self, url):
        self._url = str(URL['ATHLETICS_URL'] + url).strip()
    def setSport(self, sport):
        self._sport = sport

    def getInsertQuery(self):
        self._id = hash(self._sport)
        return ("INSERT INTO teampic (id, sport, url, ts_inserted) VALUES (?, ?, ?);", 
				(self._id, self._sport, self._url, str(time.time())))

    def getPic(self):
        return self._url
