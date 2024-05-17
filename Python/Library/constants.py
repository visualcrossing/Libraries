# Define base url for the Visual Crossing API
BASE_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"
# Define weather data parameter constants
QUERY_COST = 'queryCost'
LATITUDE = 'latitude'
LONGITUDE = 'longitude'
RESOLVED_ADDRESS = 'resolvedAddress'
ADDRESS = 'address'
TIMEZONE = 'timezone'
TZOFFSET = 'tzoffset'

DAYS = 'days'
HOURS = 'hours'

DATETIME = 'datetime'
DATETIME_EPOCH = 'datetimeEpoch'
TEMPMAX = 'tempmax'
TEMPMIN = 'tempmin'
TEMP = 'temp'
FEELSLIKEMAX = 'feelslikemax'
FEELSLIKEMIN = 'feelslikemin'
FEELSLIKE = 'feelslike'
DEW = 'dew'
HUMIDITY = 'humidity'
PRECIP = 'precip'
PRECIPPROB = 'precipprob'
PRECIPCOVER = 'precipcover'
PRECIPTYPE = 'preciptype'
SNOW = 'snow'
SNOWDEPTH = 'snowdepth'
WINDGUST = 'windgust'
WINDSPEED = 'windspeed'
WINDDIR = 'winddir'
PRESSURE = 'pressure'
CLOUDCOVER = 'cloudcover'
VISIBLILITY = 'visibility'
SOLARRADIATION = 'solarradiation'
SOLARENERGY = 'solarenergy'
UVINDEX = 'uvindex'
SEVERERISK = 'severerisk'
SUNRISE = 'sunrise'
SUNRISE_EPOCH = 'sunriseEpoch'
SUNSET = 'sunset'
SUNSET_EPOCH = 'sunsetEpoch'
MONNPHAE = 'moonphase'
CONDITIONS = 'conditions'
DESCRIPTION = 'description'
ICON = 'icon'
STATIONS = 'stations'
SOURCE = 'source'

DAYS_Keys = [DATETIME, DATETIME_EPOCH, TEMPMAX, TEMPMIN, TEMP, FEELSLIKEMAX, FEELSLIKEMIN, FEELSLIKE, DEW, HUMIDITY, PRECIP, PRECIPPROB, PRECIPCOVER, PRECIPTYPE, SNOW, SNOWDEPTH, 
             WINDGUST, WINDSPEED, WINDDIR, PRESSURE, CLOUDCOVER, VISIBLILITY, SOLARRADIATION, SOLARENERGY, UVINDEX, SEVERERISK, SUNRISE, SUNRISE_EPOCH,
             SUNSET, SUNSET_EPOCH, MONNPHAE, CONDITIONS, DESCRIPTION, ICON, STATIONS, SOURCE, HOURS]

HOURS_Keys = [DATETIME, DATETIME_EPOCH, TEMP, FEELSLIKE, DEW, HUMIDITY, PRECIP, PRECIPPROB, PRECIPTYPE, SNOW, SNOWDEPTH, 
             WINDGUST, WINDSPEED, WINDDIR, PRESSURE, CLOUDCOVER, VISIBLILITY, SOLARRADIATION, SOLARENERGY, UVINDEX, SEVERERISK,
             CONDITIONS, ICON, STATIONS, SOURCE]
