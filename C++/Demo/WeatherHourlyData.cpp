#include "WeatherHourlyData.h"

tm WeatherHourlyData::getDatetime() {
	return datetime;
}

void WeatherHourlyData::setDatetime(tm t) {
	datetime = t;
}

long WeatherHourlyData::getDatetimeEpoch() {
	return datetimeEpoch;
}

void WeatherHourlyData::setDatetimeEpoch(long d) {
	datetimeEpoch = d;
}

double WeatherHourlyData::getTemp() {
	return temp;
}

void WeatherHourlyData::setTemp(double t) {
	temp = t;
}

double WeatherHourlyData::getFeelslike() {
	return feelslike;
}

void WeatherHourlyData::setFeelslike(double f) {
	feelslike = f;
}

double WeatherHourlyData::getHumidity() {
	return humidity;
}

void WeatherHourlyData::setHumidity(double h) {
	humidity = h;
}

double WeatherHourlyData::getDew() {
	return dew;
}

void WeatherHourlyData::setDew(double d) {
	dew = d;
}

double WeatherHourlyData::getPrecip() {
	return precip;
}

void WeatherHourlyData::setPrecip(double p) {
	precip = p;
}

double WeatherHourlyData::getPrecipProb() {
	return precipprob;
}

void WeatherHourlyData::setPrecipProb(double p) {
	precipprob = p;
}

double WeatherHourlyData::getSnow() {
	return snow;
}

void WeatherHourlyData::setSnow(double s) {
	snow = s;
}

double WeatherHourlyData::getSnowDepth() {
	return snowdepth;
}

void WeatherHourlyData::setSnowDepth(double s) {
	snowdepth = s;
}

vector<string> WeatherHourlyData::getPrecipType() {
	return preciptype;
}

void WeatherHourlyData::setPrecipType(vector<string> p) {
	preciptype = p;
}

double WeatherHourlyData::getWindGust() {
	return windgust;
}

void WeatherHourlyData::setWindGust(double w) {
	windgust = w;
}

double WeatherHourlyData::getWindSpeed() {
	return windspeed;
}

void WeatherHourlyData::setWindSpeed(double w) {
	windspeed = w;
}

double WeatherHourlyData::getWindDir() {
	return winddir;
}

void WeatherHourlyData::setWindDir(double w) {
	winddir = w;
}

double WeatherHourlyData::getPressure() {
	return pressure;
}

void WeatherHourlyData::setPressure(double p) {
	pressure = p;
}

double WeatherHourlyData::getVisibility() {
	return visibility;
}

void WeatherHourlyData::setVisibility(double v) {
	visibility = v;
}

double WeatherHourlyData::getCloudCover() {
	return cloudcover;
}

void WeatherHourlyData::setCloudCover(double c) {
	cloudcover = c;
}

double WeatherHourlyData::getSolarRadiation() {
	return solarradiation;
}

void WeatherHourlyData::setSolarRadiation(double s) {
	solarradiation = s;
}

double WeatherHourlyData::getSolarEnergy() {
	return solarenergy;
}

void WeatherHourlyData::setSolarEnergy(double s) {
	solarenergy = s;
}

double WeatherHourlyData::getUvIndex() {
	return uvindex;
}

void WeatherHourlyData::setUvIndex(double u) {
	uvindex = u;
}

string WeatherHourlyData::getConditions() {
	return conditions;
}

void WeatherHourlyData::setConditions(string c) {
	conditions = c;
}

string WeatherHourlyData::getIcon() {
	return icon;
}

void WeatherHourlyData::setIcon(string i) {
	icon = i;
}

vector<string> WeatherHourlyData::getStations() {
	return stations;
}

void WeatherHourlyData::setStations(vector<string> s) {
	stations = s;
}

string WeatherHourlyData::getSource() {
	return source;
}

void WeatherHourlyData::setSource(string s) {
	source = s;
}