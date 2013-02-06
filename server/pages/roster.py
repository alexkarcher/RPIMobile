from config import HOST, URL, ID, CLASS, CACHE_LEN
from bs4 import BeautifulSoup
import urllib.request, json
from Player import Player
import database

def index(sport=None):
    if sport:
        database.clear('roster', sport, CACHE_LEN['ROSTER'])
        
        players = database.getRoster(sport)
        
        if not players:
            print("Pulling fresh data")
            refresh_data(sport)
            players = database.getRoster(sport)
        players_json = [p.toJSON() for p in players]
        return {'players' : players_json}

def refresh_data(sport=None):
    if sport:
        database.clear('roster', sport)
        
        url = urllib.request.urlopen(URL['ATHLETICS_URL']
                                   + URL['ROSTER_PATH'] + sport)
        content = url.read().decode('utf8')
        url.close()

        soup = BeautifulSoup(content)
        player_table = soup.find(id=ID['ROSTER_TABLE_ID'])
        player_rows = player_table.find_all('tr')

        for row in player_rows:
            player = process_player_row(row.find_all('td'), sport)
            if player:
                database.save(player)

        return index(sport);
    return False

def process_player_row(player_row, sport):
    if not player_row:
        return None
    player = Player()
    for col in player_row:
        if CLASS['FULL_NAME'] in col['class']:
            player.setUrl(col.a['href'])
            player.setName(col.a.string)
        elif CLASS['HOMETOWN'] in col['class']:
            player.setHometown(col.contents[0])
        elif CLASS['IMAGE'] in col['class']:
            if col.img:
                player.setImage(col.img['src'])

    player.setSport(sport)
    
    return player
