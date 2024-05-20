#include <string>
#include <vector>
#include <unordered_map>
#include <iostream>
#include <ctime>
#include <sstream>
#include <cpr/cpr.h>
#include <nlohmann/json.hpp>
#include "Station.h"
#include "WeatherDailyData.h"

#define BASE_URL "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"

using namespace std;
using json = nlohmann::json;

class WeatherData
{
	string apiKey;
	long queryCost;
	double latitude;
	double longitude;
	string resolvedAddress;
	string address;
	string timezone;
	double tzoffset;
	vector<WeatherDailyData> dailyData;
	unordered_map<string, Station> stations;

public:
	WeatherData(string);

	string getApiKey();
	void setApiKey(string);

	long getQueryCost();
	void setQueryCost(long);

	double getLatitude();
	void setLatitude(double);

	double getLongitude();
	void setLongitude(double);

	string getResolvedAddress();
	void setResolvedAddress(string);

	string getAddress();
	void setAddress(string);

	string getTimezone();
	void setTimezone(string);

	double getTzoffset();
	void setTzoffset(double);

	unordered_map<string, Station> getStations();
	void setStations(unordered_map<string, Station>);

	vector<WeatherDailyData>& getWeatherDailyData();
	void setWeatherDailyData(vector<WeatherDailyData>);

	string fetchData(string);
	void clearWeatherData();
	void handleWeatherDate(string);

	void fetchWeatherData(string, string, string, string, string, string);
	void fetchWeatherData(string, string, string);
	void fetchWeatherData(string, string);
	void fetchForecastData(string);


	WeatherDailyData createDailyData(json);
	WeatherHourlyData createHourlyData(json);

	
	WeatherDailyData getWeatherDataByDay(tm);
	WeatherDailyData getWeatherDataByDay(int);
};

