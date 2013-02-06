import os, sys
sys.path.append(os.path.abspath('pages'))
sys.path.append(os.path.abspath('classes'))
sys.path.append(os.path.abspath('libs'))

from bottle import route, run, TEMPLATE_PATH
from config import HOST
import roster, schedule, laundry, teampic, menus, tv, buildinghours

# Roster
route('/v1/roster/<sport>', callback=roster.index)
route('/v1/refresh_roster/<sport>', callback=roster.refresh_data)

# Team Pic
route('/v1/teampic/<sport>', callback=teampic.index)
route('/v1/refresh_teampic/<sport>', callback=teampic.refresh_data)

# Schedule
route('/v1/schedule/<sport>', callback=schedule.index)
route('/v1/refresh_schedule/<sport>', callback=schedule.refresh_data)

# Menu
route('/v1/menu', callback=menus.refresh_data)

# TV
route('/v1/tv', callback=tv.index)

# Building Hours
TEMPLATE_PATH += '/views/'
route('/v1/building_hours', callback=buildinghours.index)
route('/v1/building_hours/edit', callback=buildinghours.edit)
route('/v1/building_hours/save', callback=buildinghours.save, method='POST')
route('/v1/building_hours/delete', callback=buildinghours.delete, method='POST')

# Laundry Alert
route('/v1/laundry', callback=laundry.index)

run(host=HOST['HOSTNAME'], port=HOST['PORT'])
