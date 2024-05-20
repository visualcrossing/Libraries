#include "WeatherDailyData.h"

vector<WeatherHourlyData>& WeatherDailyData::getHourlyData() {
	return hourlyData;
}

void WeatherDailyData::setHourlyData(vector<WeatherHourlyData> h) {
	hourlyData = h;
}

tm WeatherDailyData::getDatetime() {
	return datetime;
}

void WeatherDailyData::setDatetime(tm t) {
	datetime = t;
}

long WeatherDailyData::getDatetimeEpoch() {
	return datetimeEpoch;
}

void WeatherDailyData::setDatetimeEpoch(long d) {
	datetimeEpoch = d;
}

double WeatherDailyData::getTempMax() {
	return tempmax;
}

void WeatherDailyData::setTempMax(double t) {
	tempmax = t;
}

double WeatherDailyData::getTempMin() {
	return tempmin;
}

void WeatherDailyData::setTempMin(double t) {
	tempmin = t;
}

double WeatherDailyData::getTemp() {
	return temp;
}

void WeatherDailyData::setTemp(double t) {
	temp = t;
}

double WeatherDailyData::getFeelslikeMax() {
	return feelslikemax;
}

void WeatherDailyData::setFeelslikeMax(double f) {
	feelslikemax = f;
}

double WeatherDailyData::getFeelslikeMin() {
	return feelslikemin;
}

void WeatherDailyData::setFeelslikeMin(double f) {
	feelslikemin = f;
}

double WeatherDailyData::getFeelslike() {
	return feelslike;
}

void WeatherDailyData::setFeelslike(double f) {
	feelslike = f;
}

double WeatherDailyData::getDew() {
	return dew;
}

void WeatherDailyData::setDew(double d) {
	dew = d;
}

double WeatherDailyData::getHumidity() {
	return humidity;
}

void WeatherDailyData::setHumidity(double h) {
	humidity = h;
}

double WeatherDailyData::getPrecip() {
	return precip;
}

void WeatherDailyData::setPrecip(double p) {
	precip = p;
}

double WeatherDailyData::getPrecipProb() {
	return precipprob;
}

void WeatherDailyData::setPrecipProb(double p) {
	precipprob = p;
}

double WeatherDailyData::getPrecipCover() {
	return precipcover;
}

void WeatherDailyData::setPrecipCover(double p) {
	precipcover = p;
}

vector<string> WeatherDailyData::getPrecipType() {
	return preciptype;
}

void WeatherDailyData::setPrecipType(vector<string> p) {
	preciptype = p;
}

double WeatherDailyData::getSnow() {
	return snow;
}

void WeatherDailyData::setSnow(double s) {
	snow = s;
}

double WeatherDailyData::getSnowDepth() {
	return snowdepth;
}

void WeatherDailyData::setSnowDepth(double s) {
	snowdepth = s;
}

double WeatherDailyData::getWindGust() {
	return windgust;
}

void WeatherDailyData::setWindGust(double w) {
	windgust = w;
}

double WeatherDailyData::getWindSpeed() {
	return windspeed;
}

void WeatherDailyData::setWindSpeed(double w) {
	windspeed = w;
}

double WeatherDailyData::getWindDir() {
	return winddir;
}

void WeatherDailyData::setWindDir(double w) {
	winddir = w;
}

double WeatherDailyData::getPressure() {
	return pressure;
}

void WeatherDailyData::setPressure(double p) {
	pressure = p;
}

double WeatherDailyData::getCloudCover() {
	return cloudcover;
}

void WeatherDailyData::setCloudCover(double c) {
	cloudcover = c;
}

double WeatherDailyData::getVisibility() {
	return visibility;
}

void WeatherDailyData::setVisibility(double v) {
	visibility = v;
}

double WeatherDailyData::getSolarRadiation() {
	return solarradiation;
}

void WeatherDailyData::setSolarRadiation(double s) {
	solarradiation = s;
}

double WeatherDailyData::getSolarEnergy() {
	return solarenergy;
}

void WeatherDailyData::setSolarEnergy(double s) {
	solarenergy = s;
}

double WeatherDailyData::getUvIndex() {
	return uvindex;
}

void WeatherDailyData::setUvIndex(double u) {
	uvindex = u;
}

string WeatherDailyData::getSunRise() {
	return sunrise;
}

void WeatherDailyData::setSunRise(string s) {
	sunrise = s;
}

long WeatherDailyData::getSunRiseEpoch() {
	return sunriseEpoch;
}

void WeatherDailyData::setSunRiseEpoch(long s) {
	sunriseEpoch = s;
}

string WeatherDailyData::getSunSet() {
	return sunset;
}

void WeatherDailyData::setSunSet(string s) {
	sunset = s;
}

long WeatherDailyData::getSunSetEpoch() {
	return sunsetEpoch;
}

void WeatherDailyData::setSunSetEpoch(long s) {
	sunsetEpoch = s;
}

double WeatherDailyData::getMoonPhase() {
	return moonphase;
}

void WeatherDailyData::setMoonPhase(double m) {
	moonphase = m;
}

string WeatherDailyData::getConditions() {
	return conditions;
}

void WeatherDailyData::setConditions(string c) {
	conditions = c;
}

string WeatherDailyData::getDescription() {
	return description;
}

void WeatherDailyData::setDescription(string d) {
	description = d;
}

string WeatherDailyData::getIcon() {
	return icon;
}

void WeatherDailyData::setIcon(string i) {
	icon = i;
}

vector<string> WeatherDailyData::getStations() {
	return stations;
}

void WeatherDailyData::setStations(vector<string> s) {
	stations = s;
}

vector<Event>& WeatherDailyData::getEvents() {
	return events;
}

void WeatherDailyData::setEvents(vector<Event> e) {
	events = e;
}

string WeatherDailyData::getSource() {
	return source;
}

void WeatherDailyData::setSource(string s) {
	source = s;
}