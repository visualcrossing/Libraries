// Weather.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include "WeatherData.h"

#define API_KEY "YOUR_API_KEY"

using namespace std;

int main()
{
    // create weather API object with API key
    WeatherData weatherData(API_KEY);
    
    // fetch weather data with location, from date, to date params.
    weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "");
    
    // get daily weather data array list
    vector<WeatherDailyData> weatherDailyData = weatherData.getWeatherDailyData();
    
    for (WeatherDailyData dailyData : weatherDailyData) {
        tm date = dailyData.getDatetime();

        int y = date.tm_year + 1900;
        int m = date.tm_mon + 1;
        int d = date.tm_mday;

        // print max temperature
        cout << y << "-" << m << "-" << d << "," << dailyData.getTempMax() << endl;

        // print min temperature
        cout << y << "-" << m << "-" << d << "," << dailyData.getTempMin() << endl;

        // print humidity
        cout << y << "-" << m << "-" << d << "," << dailyData.getHumidity() << endl;

        // get hourly weather data array list
        vector<WeatherHourlyData> weatherHourlyData = dailyData.getHourlyData();
        
        for (WeatherHourlyData hourlyData : weatherHourlyData) {
            tm time = hourlyData.getDatetime();

            // print temperature
            cout << time.tm_hour << ":" << time.tm_min << ":" << time.tm_sec << "," << hourlyData.getTemp() << endl;

            // print humidity
            cout << time.tm_hour << ":" << time.tm_min << ":" << time.tm_sec << "," << hourlyData.getHumidity() << endl;
        }

        vector<Event> events = dailyData.getEvents();
        for (Event event : events) {
            tm datetime = event.getDatetime();

            int y = datetime.tm_year + 1900;
            int m = datetime.tm_mon + 1;
            int d = datetime.tm_mday;

            cout << y << "-" << m << "-" << d << " " << datetime.tm_hour << ":" << datetime.tm_min << ":" << datetime.tm_sec << "," << event.getDatetimeEpoch() << endl;
        }
    }

    unordered_map<string, Station> stations = weatherData.getStations();
    for (const auto& pair : stations) {
        string key = pair.first;
        Station station = pair.second;

        cout << key << endl;
        cout << station.getName() << endl;
        cout << station.getDistance() << endl;
    }
    
    // set API_KEY
    weatherData.setApiKey(API_KEY);

    // fetch weather data for a specific datetime
    weatherData.fetchWeatherData("K2A1W1", "2021-10-19");

    // get daily weather data object
    vector<WeatherDailyData> weatherDailyData1 = weatherData.getWeatherDailyData();

    for (WeatherDailyData dailyData : weatherDailyData1) {
        tm date = dailyData.getDatetime();
        
        int y = date.tm_year + 1900;
        int m = date.tm_mon + 1;
        int d = date.tm_mday;

        // print temperature
        cout << y << "-" << m << "-" << d << "," << dailyData.getTempMax();
    }
    
    // fetch forecast (15 days) weather data for the location
    weatherData.fetchForecastData("K2A1W1");

    // get daily weather data array list
    vector<WeatherDailyData> weatherDailyData2 = weatherData.getWeatherDailyData();

    for (WeatherDailyData dailyData : weatherDailyData2) {
        tm date = dailyData.getDatetime();
        
        int y = date.tm_year + 1900;
        int m = date.tm_mon + 1;
        int d = date.tm_mday;

        // print temperature
        cout << y << "-" << m << "-" << d << "," << dailyData.getTempMax();
    }
    return 0;
}
