import sqlite3
from config import DB
from Player import Player
from ScheduledGame import ScheduledGame
from BuildingHours import BuildingHours
import time

def connect():
    connection = sqlite3.connect(DB['FILE'], timeout=10)
    cursor = connection.cursor()
    return (connection, cursor)
    
def save(row):
    connection, cursor = connect()
    query, parameters = row.getInsertQuery()
    print(query, parameters)
    print (len(parameters))
    cursor.execute(query,parameters)
    connection.commit()
    cursor.close()
    

def updateHours(row):
	deleteHours(row._id)
	save(row)
	

def deleteHours(row_id):
	print("Deleting building hours where id is", row_id)
	connection, cursor = connect()
	cursor.execute("DELETE FROM buildinghours WHERE id = '%s'" % (row_id))
	connection.commit()
	cursor.close()


def getRoster(sport):
    try:
        player_list = []

        connection, cursor = connect()
        cursor.execute("SELECT * FROM roster WHERE sport = ?;", (sport,))

        for row in cursor:
            player = Player()
            player.inflate(row)
            player_list.append(player)
            
        return player_list
    except:
        print("Unexpected error:", sys.exc_info()[0])
        
def getSchedule(sport):
    games_list = []

    connection, cursor = connect()
    cursor.execute("SELECT * FROM schedule WHERE sport = ?;", (sport,))

    for row in cursor:
        game = ScheduledGame()
        game.inflate(row)
        games_list.append(game)
        
    return games_list
    
def getTeamPic(sport):
    connection, cursor = connect()
    cursor.execute("SELECT url FROM 'teampic' WHERE sport = ?;", (sport,))
    if cursor:
        one = cursor.fetchone()
        if one:
            return one[0]
    return None
    
def getBuildingHours():
	connection, cursor = connect()
	cursor.execute("SELECT * FROM 'buildinghours';")
	
	building_hours_list = []
	for row in cursor:
		building_hours = BuildingHours()
		building_hours.inflate(row)
		building_hours_list.append(building_hours)
	
	return building_hours_list

def clear(table, sport, older_than=None):
    connection,cursor = connect()
    if older_than:
        oldest_allowed = str(time.time() - older_than)
        cursor.execute("DELETE FROM %s WHERE sport = '%s' AND ts_inserted < '%s'" % (table, sport, oldest_allowed))
    else:
        cursor.execute("DELETE FROM %s WHERE sport = '%s'" % (table, sport))
    connection.commit()
    cursor.close()
