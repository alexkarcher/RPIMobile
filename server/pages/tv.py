from config import URL
import urllib.request, json
from bs4 import BeautifulSoup
from collections import OrderedDict
import datetime

def index(sport=None):
    url = urllib.request.urlopen(URL['TV_URL'])
    content = url.read().decode('utf8')
    url.close()
    #content = open('tv.txt').read()
    
    soup = BeautifulSoup(content)
    days = soup.find_all('day')

    output = dict()
    date = datetime.date.today()
    # Like 2012-10-25
    date_format = str(date.year) + '-' + str(date.month) + '-' + str(date.day)
    date_format_until = str(date.year) + '-' + str(date.month) + '-' + str(int(date.day) + 2)
    days = [day for day in days if (day['attr'] >= date_format and day['attr'] < date_format_until)]
    
    for index, day in enumerate(days):
        date = ("today", "tomorrow")[index]
        output[date] = OrderedDict()
        
        times = day.find_all('time')
        for time in times:
            show_time = time['attr']
            output[date][show_time] = OrderedDict()
            shows = time.find_all('show')
            
            for show in shows:
                show_name = show['name']
                output[date][show_time][show_name] = OrderedDict()
                this_show = output[date][show_time][show_name]
                
                this_show['network'] = show.find('network').string
                this_show['title'] = show.find('title').string
                this_show['ep'] = show.find('ep').string
    
    return json.dumps(output)
                
                
                
        
