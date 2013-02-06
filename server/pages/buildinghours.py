from bottle import template, request
from BuildingHours import BuildingHours
import database

def index():
	fields = database.getBuildingHours()
	fields_json = [f.toJSON() for f in fields]
	return {'building_hours': fields_json}
	
def edit():
	days = {}
	days_list = ['sunday','monday','tuesday','wednesday','thursday',
				 'friday','saturday']
	for index, day in enumerate(days_list):
		days[index] = day
	
	fields = database.getBuildingHours()
	fields.append(BuildingHours())
	
	return template('simple_form', 
					 form_fields=fields,
					 days=days,
					 description='Day must be 0-6. Opentime and closetime are integers 0 - 23.')

def save():
	
	hours = BuildingHours()
	
	hours._id = request.POST.get('id')
	hours._name = request.POST.get('name')
	
	hours._days[0] = False if request.POST.get('sunday') is None else True
	hours._days[1] = False if request.POST.get('monday') is None else True
	hours._days[2] = False if request.POST.get('tuesday') is None else True
	hours._days[3] = False if request.POST.get('wednesday') is None else True
	hours._days[4] = False if request.POST.get('thursday') is None else True
	hours._days[5] = False if request.POST.get('friday') is None else True
	hours._days[6] = False if request.POST.get('saturday') is None else True
	
	hours._opentime = int(request.POST.get('openhour'))
	hours._closetime = int(request.POST.get('closehour'))
	
	if (hours._id == 'None'):
		database.save(hours)
	else:
		database.updateHours(hours)
	 
def delete():
	hours_id = request.POST.get('id')
	database.deleteHours(hours_id)
