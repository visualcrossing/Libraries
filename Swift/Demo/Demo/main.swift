import Foundation

// Create weather API object with API key
let weatherData = WeatherData(apiKey: "YOUR_API_KEY")

// Fetch weather data with location, from date, to date params
weatherData.fetchWeatherData(location: "38.96%2C-96.02", from: "2020-7-10", to: "2020-7-12", unitGroup: "us", include: "events", elements: "")

// Daily weather data array list
let weatherDailyData = weatherData._WeatherDailyData

for dailyData in weatherDailyData {
    // Print max temperature
    print("\(dailyData._Datetime ?? Date()), \(dailyData._TempMax ?? 0.0)")
    
    // Print min temperature
    print("\(dailyData._Datetime ?? Date()), \(dailyData._TempMin ?? 0.0)")
    
    // Print humidity
    print("\(dailyData._Datetime ?? Date()), \(dailyData._Humidity ?? 0.0)")
    
    // Hourly weather data array list
    let weatherHourlyData = dailyData._WeatherHourlyData
    for hourlyData in weatherHourlyData {
        // Print temperature
        print("\(hourlyData._Datetime ?? TimeInterval()), \(hourlyData._Temp ?? 0.0)")
        
        // Print humidity
        print("\(hourlyData._Datetime ?? TimeInterval()), \(hourlyData._Humidity ?? 0.0)")
    }


    // Print events
    let events = dailyData._Events
    for eventObj in events {
        print("\(eventObj._Datetime ?? Date()), \(eventObj._DatetimeEpoch ?? 0)")
    }

}

// Stations dictionary
let stations = weatherData._Stations
for (key, station) in stations {
    print("\(key), \(station._Name ?? "")")
    print("\(key), \(station._Id ?? "")")
    print("\(key), \(station._UseCount ?? 0)")
}

// Initialize WeatherData object
let weatherData1 = WeatherData()

// Set API_KEY
weatherData1.APIKey = "3KAJKHWT3UEMRQWF2ABKVVVZE"

// Fetch weather data for a specific datetime
weatherData1.fetchWeatherData(location: "K2A1W1", datetime: "2021-10-19")

// Daily weather data object
let weatherDailyData1 = weatherData1._WeatherDailyData

for dailyData in weatherDailyData1 {
    // Print temperature
    print("\(dailyData._Datetime ?? Date()), \(dailyData._TempMax ?? 0.0)")
}

// Fetch forecast (15 days) weather data for the location
weatherData1.fetchForecastData(location: "K2A1W1")

// Daily weather data list
let weatherDailyData2 = weatherData1._WeatherDailyData

for dailyData in weatherDailyData2 {
    // Print temperature
    print("\(dailyData._Datetime ?? Date()), \(dailyData._TempMax ?? 0.0)")
}

// Create another instance of WeatherData
let weatherData2 = WeatherData()
weatherData2.APIKey = "3KAJKHWT3UEMRQWF2ABKVVVZE"
