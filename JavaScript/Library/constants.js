// Define base url for the Visual Crossing API
const BASE_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline";

// Define weather data parameter constants
const QUERY_COST = 'queryCost';
const LATITUDE = 'latitude';
const LONGITUDE = 'longitude';
const RESOLVED_ADDRESS = 'resolvedAddress';
const ADDRESS = 'address';
const TIMEZONE = 'timezone';
const TZOFFSET = 'tzoffset';

const DAYS = 'days';
const HOURS = 'hours';

const DATETIME = 'datetime';
const DATETIME_EPOCH = 'datetimeEpoch';
const TEMPMAX = 'tempmax';
const TEMPMIN = 'tempmin';
const TEMP = 'temp';
const FEELSLIKEMAX = 'feelslikemax';
const FEELSLIKEMIN = 'feelslikemin';
const FEELSLIKE = 'feelslike';
const DEW = 'dew';
const HUMIDITY = 'humidity';
const PRECIP = 'precip';
const PRECIPPROB = 'precipprob';
const PRECIPCOVER = 'precipcover';
const PRECIPTYPE = 'preciptype';
const SNOW = 'snow';
const SNOWDEPTH = 'snowdepth';
const WINDGUST = 'windgust';
const WINDSPEED = 'windspeed';
const WINDDIR = 'winddir';
const PRESSURE = 'pressure';
const CLOUDCOVER = 'cloudcover';
const VISIBILITY = 'visibility';
const SOLARRADIATION = 'solarradiation';
const SOLARENERGY = 'solarenergy';
const UVINDEX = 'uvindex';
const SEVERERISK = 'severerisk';
const SUNRISE = 'sunrise';
const SUNRISE_EPOCH = 'sunriseEpoch';
const SUNSET = 'sunset';
const SUNSET_EPOCH = 'sunsetEpoch';
const MOONPHASE = 'moonphase';
const CONDITIONS = 'conditions';
const DESCRIPTION = 'description';
const ICON = 'icon';
const STATIONS = 'stations';
const SOURCE = 'source';

const DAYS_KEYS = [
    DATETIME, DATETIME_EPOCH, TEMPMAX, TEMPMIN, TEMP, FEELSLIKEMAX, FEELSLIKEMIN, FEELSLIKE, DEW, HUMIDITY, PRECIP, PRECIPPROB, PRECIPCOVER, PRECIPTYPE, 
    SNOW, SNOWDEPTH, WINDGUST, WINDSPEED, WINDDIR, PRESSURE, CLOUDCOVER, VISIBILITY, SOLARRADIATION, SOLARENERGY, UVINDEX, SEVERERISK, SUNRISE, 
    SUNRISE_EPOCH, SUNSET, SUNSET_EPOCH, MOONPHASE, CONDITIONS, DESCRIPTION, ICON, STATIONS, SOURCE, HOURS
];

const HOURS_KEYS = [
    DATETIME, DATETIME_EPOCH, TEMP, FEELSLIKE, DEW, HUMIDITY, PRECIP, PRECIPPROB, PRECIPTYPE, SNOW, SNOWDEPTH, WINDGUST, WINDSPEED, WINDDIR, PRESSURE, 
    CLOUDCOVER, VISIBILITY, SOLARRADIATION, SOLARENERGY, UVINDEX, SEVERERISK, CONDITIONS, ICON, STATIONS, SOURCE
];

module.exports = {
    BASE_URL,
    QUERY_COST,
    LATITUDE,
    LONGITUDE,
    RESOLVED_ADDRESS,
    ADDRESS,
    TIMEZONE,
    TZOFFSET,
    DAYS,
    HOURS,
    DATETIME,
    DATETIME_EPOCH,
    TEMPMAX,
    TEMPMIN,
    TEMP,
    FEELSLIKEMAX,
    FEELSLIKEMIN,
    FEELSLIKE,
    DEW,
    HUMIDITY,
    PRECIP,
    PRECIPPROB,
    PRECIPCOVER,
    PRECIPTYPE,
    SNOW,
    SNOWDEPTH,
    WINDGUST,
    WINDSPEED,
    WINDDIR,
    PRESSURE,
    CLOUDCOVER,
    VISIBILITY,
    SOLARRADIATION,
    SOLARENERGY,
    UVINDEX,
    SEVERERISK,
    SUNRISE,
    SUNRISE_EPOCH,
    SUNSET,
    SUNSET_EPOCH,
    MOONPHASE,
    CONDITIONS,
    DESCRIPTION,
    ICON,
    STATIONS,
    SOURCE,
    DAYS_KEYS,
    HOURS_KEYS
};
