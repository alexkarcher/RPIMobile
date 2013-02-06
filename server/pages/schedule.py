from config import HOST, URL, ID, CLASS, CACHE_LEN
from bs4 import BeautifulSoup
import urllib.request, json
from ScheduledGame import ScheduledGame
import database

def index(sport=None):
    if sport:
        database.clear('schedule', sport, CACHE_LEN['SCHEDULE'])
        schedule = database.getSchedule(sport)
        if not schedule:
            refresh_data(sport)
            schedule = database.getSchedule(sport)
        schedule_json = [event.toJSON() for event in schedule]
        return {'events' : schedule_json}

def refresh_data(sport=None):
    if sport:        
        database.clear('roster', sport)
        
        url = urllib.request.urlopen(URL['ATHLETICS_URL']
                                   + URL['SCHEDULE_PATH'] + sport)
        content = url.read().decode('utf8')
        url.close()

        soup = BeautifulSoup(content)
        schedule = soup.find_all("div", "schedule_game")
        
        scheduled_games = []
        
        for game in schedule:
            scheduled_game = ScheduledGame()
            if (game.find("div", "schedule_game_opponent_name")):
                scheduled_game.setSport(sport)
                if game.find("div", "schedule_game_opponent_name").a.span:
                    scheduled_game.setTeam(game.find("div", "schedule_game_opponent_name").a.span.string)
                else:
                    scheduled_game.setTeam(game.find("div", "schedule_game_opponent_name").get_text())
                scheduled_game.setDate(game.find("div", "schedule_game_opponent_date").string)
                scheduled_game.setTime(game.find("div", "schedule_game_opponent_time").string)
                scheduled_game.setLocation(game.find("div", "schedule_game_middle").get_text())
                scheduled_game.setTeam(game.find("div", "schedule_game_opponent_name").get_text())
                scheduled_game.setImage(game.find("div", "schedule_game_opponent_logo").img['src'])
                
                if (game.find("div", "schedule_game_results")):
                    scheduled_game.setScore(game.find("div", "schedule_game_results").contents[1].get_text())
                
                database.save(scheduled_game)
