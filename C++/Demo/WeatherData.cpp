#include "WeatherData.h"

WeatherData::WeatherData(string apiKey) {
	this->apiKey = apiKey;
}

string WeatherData::getApiKey() {
	return apiKey;
}

void WeatherData::setApiKey(string apiKey) {
	this->apiKey = apiKey;
}

long WeatherData::getQueryCost() {
	return queryCost;
}

void WeatherData::setQueryCost(long q) {
	queryCost = q;
}

double WeatherData::getLatitude() {
	return latitude;
}

void WeatherData::setLatitude(double l) {
	latitude = l;
}

double WeatherData::getLongitude() {
	return longitude;
}

void WeatherData::setLongitude(double l) {
	longitude = l;
}

string WeatherData::getResolvedAddress() {
	return resolvedAddress;
}

void WeatherData::setResolvedAddress(string r) {
	resolvedAddress = r;
}

string WeatherData::getAddress() {
	return address;
}

void WeatherData::setAddress(string a) {
	address = a;
}

string WeatherData::getTimezone() {
	return timezone;
}

void WeatherData::setTimezone(string t) {
	timezone = t;
}

double WeatherData::getTzoffset() {
	return tzoffset;
}

void WeatherData::setTzoffset(double t) {
	tzoffset = t;
}

unordered_map<string, Station> WeatherData::getStations() {
	return stations;
}

void WeatherData::setStations(unordered_map<string, Station> s) {
	stations = s;
}

vector<WeatherDailyData>& WeatherData::getWeatherDailyData() {
	return dailyData;
}

void WeatherData::setWeatherDailyData(vector<WeatherDailyData> d) {
	dailyData = d;
}

string WeatherData::fetchData(string url) {
	cpr::Response r = cpr::Get(cpr::Url{ url });
	if (r.status_code == 200) {
		return r.text;
	}
	else {
		return "";
	}
}

void WeatherData::clearWeatherData() {
	for (int i = 0; i < dailyData.size(); i++) {
		vector<WeatherHourlyData>& hourlyDataList = dailyData.at(i).getHourlyData();
		vector<Event>& eventList = dailyData.at(i).getEvents();

		hourlyDataList.clear();
		eventList.clear();
	}
	stations.clear();
	dailyData.clear();
}

void WeatherData::handleWeatherDate(string jsonStr) {
	clearWeatherData();
	
	json obj = json::parse(jsonStr);
	setQueryCost(obj["queryCost"]);
	setLatitude(obj["latitude"]);
	setLongitude(obj["longitude"]);
	setResolvedAddress(obj["resolvedAddress"]);
	setAddress(obj["address"]);
	setTimezone(obj["timezone"]);
	setTzoffset(obj["tzoffset"]);
	
	for (const auto& day : obj["days"]) {
		getWeatherDailyData().push_back(createDailyData(day));
	}

	json stations = obj["stations"];

	for (auto it = stations.begin(); it != stations.end(); ++it) {
		string key = it.key();
		json stationObj = it.value();

		Station station;
		station.setDistance(stationObj["distance"].is_null() ? numeric_limits<double>::quiet_NaN() : stationObj.value("distance", 0.0));
		station.setLatitude(stationObj["latitude"].is_null() ? numeric_limits<double>::quiet_NaN() : stationObj.value("latitude", 0.0));
		station.setLongitude(stationObj["longitude"].is_null() ? numeric_limits<double>::quiet_NaN() : stationObj.value("longitude", 0.0));
		station.setUseCount(stationObj["useCount"].is_null() ? 0 : stationObj.value("useCount", 0));
		station.setId(stationObj["id"].is_null() ? "" : stationObj.value("id", ""));
		station.setName(stationObj["name"].is_null() ? "" : stationObj.value("name", ""));
		station.setQuality(stationObj["quality"].is_null() ? 0 : stationObj.value("quality", 0));
		station.setContribution(stationObj["contribution"].is_null() ? numeric_limits<double>::quiet_NaN() : stationObj.value("contribution", 0.0));

		this->stations[key] = station;
	}
}

WeatherDailyData WeatherData::createDailyData(json day) {
	WeatherDailyData dailyData;

	string dateStr = day["datetime"];

	tm date;
	istringstream ss(dateStr);
	ss >> get_time(&date, "%Y-%m-%d");

	dailyData.setDatetime(date);
	
	dailyData.setDatetimeEpoch(day["datetimeEpoch"].is_null() ? 0 : day.value("datetimeEpoch", 0));
	dailyData.setTempMax(day["tempmax"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("tempmax", 0.0));
	dailyData.setTempMin(day["tempmin"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("tempmin", 0.0));
	dailyData.setTemp(day["temp"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("temp", 0.0));
	dailyData.setFeelslikeMax(day["feelslikemax"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("feelslikemax", 0.0));
	dailyData.setFeelslikeMin(day["feelslikemin"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("feelslikemin", 0.0));
	dailyData.setFeelslike(day["feelslike"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("feelslike", 0.0));
	dailyData.setDew(day["dew"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("dew", 0.0));
	dailyData.setHumidity(day["humidity"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("humidity", 0.0));
	dailyData.setPrecip(day["precip"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("precip", 0.0));
	dailyData.setPrecipProb(day["precipprob"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("precipprob", 0.0));
	dailyData.setPrecipCover(day["precipcover"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("precipcover", 0.0));

	if (!(day.find("preciptype") == day.end() || day["preciptype"].is_null())) {
		vector<string> typeList;
		for (const auto& type : day["preciptype"]) {
			typeList.push_back(type);
		}

		dailyData.setPrecipType(typeList);
	}

	dailyData.setSnow(day["snow"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("snow", 0.0));
	dailyData.setSnowDepth(day["snowdepth"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("snowdepth", 0.0));
	dailyData.setWindGust(day["windgust"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("widgust", 0.0));
	dailyData.setWindSpeed(day["windspeed"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("windspeed", 0.0));
	dailyData.setWindDir(day["winddir"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("winddir", 0.0));
	dailyData.setPressure(day["pressure"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("pressure", 0.0));
	dailyData.setCloudCover(day["cloudcover"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("cloudcover", 0.0));
	dailyData.setVisibility(day["visibility"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("visibility", 0.0));
	dailyData.setSolarRadiation(day["solarradiation"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("solarradiation", 0.0));
	dailyData.setSolarEnergy(day["solarenergy"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("solarenergy", 0.0));
	dailyData.setUvIndex(day["uvindex"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("uvindex", 0.0));
	dailyData.setSunRise(day["sunrise"].is_null() ? "" : day.value("sunrise", ""));
	dailyData.setSunRiseEpoch(day["sunriseEpoch"].is_null() ? 0 : day.value("sunriseEpoch", 0));
	dailyData.setSunSet(day["sunset"].is_null() ? "" : day.value("sunset", ""));
	dailyData.setSunSetEpoch(day["sunsetEpoch"].is_null() ? 0 : day.value("sunsetEpoch", 0));
	dailyData.setMoonPhase(day["moonphase"].is_null() ? numeric_limits<double>::quiet_NaN() : day.value("moonphase", 0.0));
	dailyData.setConditions(day["conditions"].is_null() ? "" : day.value("conditions", ""));
	dailyData.setDescription(day["description"].is_null() ? "" : day.value("description", ""));
	dailyData.setIcon(day["icon"].is_null() ? "" : day.value("icon", ""));

	if (!(day.find("stations") == day.end() || day["stations"].is_null())) {
		vector<string> stationList;
		for (const auto& station : day["stations"]) {
			stationList.push_back(station);
		}
		dailyData.setStations(stationList);
	}

	if (!(day.find("events") == day.end() || day["events"].is_null())) {
		vector<Event> eventList;

		for (const auto& event : day["events"]) {
			Event eventObj;
			
			string datetimeStr = event["datetime"];
			tm datetime;
			istringstream ss(datetimeStr);
			ss >> get_time(&datetime, "%Y-%m-%dT%H:%M:%S");

			eventObj.setDatetime(datetime);
			eventObj.setDatetimeEpoch(event["datetimeEpoch"].is_null() ? 0 : event.value("datetimeEpoch", 0));
			eventObj.setType(event["type"].is_null() ? "" : event.value("type", ""));
			eventObj.setLatitude(event["latitude"].is_null() ? numeric_limits<double>::quiet_NaN() : event.value("latitude", 0.0));
			eventObj.setLongitude(event["longitude"].is_null() ? numeric_limits<double>::quiet_NaN() : event.value("longitude", 0.0));
			eventObj.setDistance(event["distance"].is_null() ? numeric_limits<double>::quiet_NaN() : event.value("distance", 0.0));
			eventObj.setDescription(event["desc"].is_null() ? "" : event.value("desc", ""));
			eventObj.setSize(event["size"].is_null() ? numeric_limits<double>::quiet_NaN() : event.value("size", 0.0));

			eventList.push_back(eventObj);
		}
		dailyData.setEvents(eventList);
	}

	dailyData.setSource(day["source"].is_null() ? "" : day.value("source", ""));

	if (!(day.find("hours") == day.end() || day["hours"].is_null())) {
		for (auto const& hour : day["hours"]) {
			dailyData.getHourlyData().push_back(createHourlyData(hour));
		}
	}

	return dailyData;
}

WeatherDailyData WeatherData::getWeatherDataByDay(tm day) {
	for (auto data : dailyData) {
		tm date = data.getDatetime();
		if (date.tm_year == day.tm_year && date.tm_mon == day.tm_mon && date.tm_mday == day.tm_mday)
			return data;
	}
}

WeatherDailyData WeatherData::getWeatherDataByDay(int index) {
	return dailyData.at(index);
}

WeatherHourlyData WeatherData::createHourlyData(json hour) {
	WeatherHourlyData hourlyData;

	string timeStr = hour["datetime"];
	tm time;
	istringstream ss(timeStr);
	ss >> get_time(&time, "%H:%M:%S");

	hourlyData.setDatetime(time);
	hourlyData.setDatetimeEpoch(hour["datetimeEpoch"].is_null() ? 0 : hour.value("datetimeEpoch", 0));
	hourlyData.setTemp(hour["temp"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("temp", 0.0));
	hourlyData.setFeelslike(hour["feelslike"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("feelslike", 0.0));
	hourlyData.setHumidity(hour["humidity"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("humidity", 0.0));
	hourlyData.setDew(hour["dew"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("dew", 0.0));
	hourlyData.setPrecip(hour["precip"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("precip", 0.0));
	hourlyData.setPrecipProb(hour["precipprob"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("precipprob", 0.0));
	hourlyData.setSnow(hour["snow"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("snow", 0.0));
	hourlyData.setSnowDepth(hour["snowdepth"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("snowdepth", 0.0));

	if (!(hour.find("preciptype") == hour.end() || hour["preciptype"].is_null())) {
		vector<string> typeList;
		for (auto const& type : hour["preciptype"]) {
			typeList.push_back(type);
		}
		hourlyData.setPrecipType(typeList);
	}

	hourlyData.setWindGust(hour["windgust"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("widgust", 0.0));
	hourlyData.setWindSpeed(hour["windspeed"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("windspeed", 0.0));
	hourlyData.setWindDir(hour["winddir"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("winddir", 0.0));
	hourlyData.setPressure(hour["pressure"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("pressure", 0.0));
	hourlyData.setVisibility(hour["visibility"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("visibility", 0.0));
	hourlyData.setCloudCover(hour["cloudcover"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("cloudcover", 0.0));
	hourlyData.setSolarRadiation(hour["solarradiation"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("solarradiation", 0.0));
	hourlyData.setSolarEnergy(hour["solarenergy"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("solarenergy", 0.0));
	hourlyData.setUvIndex(hour["uvindex"].is_null() ? numeric_limits<double>::quiet_NaN() : hour.value("uvindex", 0.0));
	hourlyData.setConditions(hour["conditions"].is_null() ? "" : hour.value("conditions", ""));
	hourlyData.setIcon(hour["icon"].is_null() ? "" : hour.value("icon", ""));

	if (!(hour.find("stations") == hour.end() || hour["stations"].is_null())) {
		vector<string> stationList;
		for (const auto& station : hour["stations"]) {
			stationList.push_back(station);
		}
		hourlyData.setStations(stationList);
	}

	hourlyData.setSource(hour["source"].is_null() ? "" : hour.value("source", ""));
	
	return hourlyData;
}

void WeatherData::fetchWeatherData(string location, string from, string to, string unitGroup, string include, string elements) {
	if (apiKey.length() == 0)
		return;

	string url = BASE_URL + location + "/" + from + "/" + to + "?key=" + apiKey + "&include=" + include + "&elements=" + elements + "&unitGroup=" + unitGroup;

	string jsonStr = fetchData(url);
	// cout << jsonStr;

	handleWeatherDate(jsonStr);
}

void WeatherData::fetchWeatherData(string location, string from, string to) {
	if (apiKey.length() == 0)
		return;

	string url = BASE_URL + location + "/" + from + "/" + to + "?key=" + apiKey;

	string jsonStr = fetchData(url);
	
	handleWeatherDate(jsonStr);
}

void WeatherData::fetchWeatherData(string location, string datetime) {
	if (apiKey.length() == 0)
		return;

	string url = BASE_URL + location + "/" + datetime + "?key=" + apiKey;

	string jsonStr = fetchData(url);

	handleWeatherDate(jsonStr);
}

void WeatherData::fetchForecastData(string location) {
	if (apiKey.length() == 0)
		return;

	string url = BASE_URL + location + "?key=" + apiKey;

	string jsonStr = fetchData(url);

	handleWeatherDate(jsonStr);
}