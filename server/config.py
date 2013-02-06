STAGE = open('stage.txt').readline().strip()

#############################
####### Host Settings #######
#############################
HOST = {}
HOST['HOSTNAME'] = 'localhost'
if STAGE == 'beta':
	HOST['PORT'] = 16219
else:
	HOST['PORT'] = 8080

#############################
##### Database Settings #####
#############################
DB = {}
if STAGE == 'alpha':
	DB['FILE'] = '/home/james/Documents/rcos/RPIMobile/server/db/rpimobile.sqlite'
elif STAGE == 'beta':
	DB['FILE'] = '/home/jcmcmillan/webapps/mobilerpi_devo/db/rpimobile.sqlite'
else:
	DB['FILE'] = '/dev/null'

#############################
###### URLs To Scrape #######
#############################
URL = {}
URL['ATHLETICS_URL'] = "http://rpiathletics.com"
URL['ROSTER_PATH'] = "/roster.aspx?path="
URL['SCHEDULE_PATH'] = "/schedule.aspx?path="
URL['LAUNDRY_URL'] = "http://www.laundryalert.com/cgi-bin/rpi2012/LMPage"
URL['COMMONS_URL'] = "http://rpihospitalityservices.com/locations/WeeklyMenu.htm"
URL['TV_URL'] = "http://services.tvrage.com/feeds/fullschedule.php?country=US"

#############################
########## CSS IDs ##########
#############################
ID = {}
ID['ROSTER_TABLE_ID'] = 'ctl00_cplhMainContent_dgrdRoster'
ID['LAUNDRY_TABLE_ID'] = 'tableb'
ID['TEAM_PIC_ID'] = 'ctl00_cplhMainContent_moTeamPhoto_imgPrimary'

#############################
######## CSS Classes ########
#############################
CLASS = {}
CLASS['FULL_NAME'] = 'roster_dgrd_full_name'
CLASS['HOMETOWN'] = 'roster_dgrd_hometownhighschool'
CLASS['IMAGE'] = 'roster_dgrd_image_combined_path'

#############################
### Cache Length Settings ###
#############################
CACHE_LEN = {}
CACHE_LEN['TEAM_PIC'] = 86400  # Whole day
CACHE_LEN['SCHEDULE'] = 21600  # Quarter of a day
CACHE_LEN['ROSTER']   = 172800 # Two days
