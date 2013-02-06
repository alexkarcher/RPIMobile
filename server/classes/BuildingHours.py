from config import URL
from Row import Row
import json

class BuildingHours(Row):
    _id = None
    _name = None
    _days = {}
    _opentime = None
    _closetime = None
    
    def __init__(self):
        self._name = None
        for i in range(7):
            self._days[i] = 0
        self._opentime = 0
        self._closetime = 0

    def inflate(self, row):
        self._id = row[0]
        self._name = row[1]
        # Sunday through monday
        self._days = row[2:9]
        self._opentime = row[9]
        self._closetime = row[10]
    
    def getInsertQuery(self):
        self._id = hash(self._name + 
                        str(self._days) +
                        str(self._opentime) + str(self._closetime))
        return ("INSERT INTO buildinghours (id, name, sunday, monday, tuesday, \
                  wednesday, thursday, friday, saturday, opentime, closetime) \
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);", (self._id, self._name,
                 self._days[0], self._days[1], self._days[2], self._days[3],
                 self._days[4], self._days[5], self._days[6], self._opentime,
                 self._closetime))

    def toJSON(self):
        return {
                'name':self._name,
                'days':self._days,
                'opentime':self._opentime,
                'closetime':self._closetime,
                }
