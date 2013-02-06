from config import URL
from Row import Row
from re import escape
import json, time

class ScheduledGame(Row):
    _id = None
    _sport = None
    _date = None
    _time = None
    _team = None
    _image = None
    _location = None
    _score = None

    def inflate(self, row):
        self._id = row[0]
        self._sport = row[1]
        self._date = row[2]
        self._time = row[3]
        self._team = row[4]
        self._image = row[5]
        self._location = row[6]
        self._score = row[7]
    
    def setDate(self, date):
        self._date = str(date).strip().replace("'", "")
    def setTime(self, time):
        self._time = str(time).strip().replace("'", "")
    def setLocation(self, location):
        self._location = str(location).strip().replace("'", "")
    def setScore(self, score):
        self._score = str(score).strip().replace("'", "")
    def setTeam(self, team):
        self._team = str(team).strip().replace("'", "")
    def setImage(self, image):
        self._image = str(URL['ATHLETICS_URL'] + image).strip()
    def setSport(self, sport):
        self._sport = sport

    def getInsertQuery(self):
        self._id = hash(self._team + self._date)
        return ("INSERT INTO schedule (id, sport, date, time, team, image, location, score, ts_inserted) \
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);", (self._id,
                 self._sport, self._date, self._time, self._team, 
                 self._image, self._location, self._score, str(time.time())))

    def toJSON(self):
        return {
                'date':self._date,
                'time':self._time,
                'team':self._team,
                'location':self._location,
                'score':self._score,
                'image':self._image
                }
