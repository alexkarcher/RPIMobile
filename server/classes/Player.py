from config import URL
from Row import Row
from re import escape
import json, time

class Player(Row):
    _id = None
    _sport = None
    _url = None
    _name = None
    _hometown = None
    _image = None

    def inflate(self, row):
        self._id = row[0]
        self._sport = row[1]
        self._url = row[2]
        self._name = row[3]
        self._hometown = row[4]
        self._image = row[5]
    
    def setUrl(self, url):
        self._url = str(URL['ATHLETICS_URL'] + url).strip()
    def setName(self, name):
        self._name = str(name).strip().replace("'", "")
    def setHometown(self, hometown):
        self._hometown = str(hometown).strip().replace("'", "")
    def setImage(self, image):
        self._image = str(URL['ATHLETICS_URL'] + image).strip()
    def setSport(self, sport):
        self._sport = sport

    def getInsertQuery(self):
        self._id = hash(self._name)
        return ("INSERT INTO roster (id, sport, url, name, hometown, image, ts_inserted) \
                VALUES (?, ?, ?, ?, ?, ?, ?);",
                (self._id, self._sport, self._url, self._name,
                 self._hometown, self._image, str(time.time())))

    def toJSON(self):
        return {
                'name':self._name,
                'url':self._url,
                'hometown':self._hometown,
                'image':self._image
                }
