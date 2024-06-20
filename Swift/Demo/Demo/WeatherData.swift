import Foundation

/**
 * The WeatherData class is designed to interact with the Visual Crossing Weather API to fetch weather data for specific locations, dates, and times.
 * This class is equipped to handle various types of weather data requests, including current weather data, historical weather data, and weather forecasts.
 * The key functionalities of this class include constructing API requests, retrieving weather data, and parsing JSON responses to populate weather data models.
 * fetchWeatherData(location: String, from: String, to: String) Public method to fetch weather data between specific dates for a given location. This is particularly useful for retrieving historical weather data or future forecasts within a defined range.
 * fetchWeatherData(location: String, datetime: String) Overloaded method to fetch weather data for a specific date and location. This is useful for getting precise weather conditions on particular days.
 * fetchForecastData(location: String): Fetches the weather forecast for the next 15 days starting from midnight of the current day at the specified location. This method is ideal for applications requiring future weather predictions to plan activities or events.
 * fetchWeatherData(location: String, from: String, to: String, unitGroup: String, include: String, elements: String)
 */
class WeatherData {
    private var apiKey: String?
    public static let BASE_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"
    
    private var _queryCost: Int64?
    private var _latitude: Double?
    private var _longitude: Double?
    private var _resolvedAddress: String?
    private var _address: String?
    private var _timezone: String?
    private var _tzOffset: Double?
    private var _weatherDailyData: [WeatherDailyData] = []
    private var _stations: [String: Station] = [:]
    
    // Constructors
    init() {}
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    var APIKey: String? {
        get { return apiKey }
        set { apiKey = newValue }
    }
    
    var _QueryCost: Int64? {
        get { return _queryCost }
        set { _queryCost = newValue }
    }
    
    var _Latitude: Double? {
        get { return _latitude }
        set { _latitude = newValue }
    }
    
    var _Longitude: Double? {
        get { return _longitude }
        set { _longitude = newValue }
    }
    
    var _ResolvedAddress: String? {
        get { return _resolvedAddress }
        set { _resolvedAddress = newValue }
    }
    
    var _Address: String? {
        get { return _address }
        set { _address = newValue }
    }
    
    var _Timezone: String? {
        get { return _timezone }
        set { _timezone = newValue }
    }
    
    var _TZOffset: Double? {
        get { return _tzOffset }
        set { _tzOffset = newValue }
    }
    
    var _WeatherDailyData: [WeatherDailyData] {
        get { return _weatherDailyData }
        set { _weatherDailyData = newValue }
    }
    
    var _Stations: [String: Station] {
        get { return _stations }
        set { _stations = newValue }
    }
    
    private func getStringOrNull(from json: [String: Any], key: String) -> String? {
        return json[key] as? String
    }
    
    private func getDoubleOrNull(from json: [String: Any], key: String) -> Double? {
        return json[key] as? Double
    }
    
    private func getInt64OrNull(from json: [String: Any], key: String) -> Int64? {
        return json[key] as? Int64
    }
    
    /**
     * The fetchData function retrieves weather data by making an API request to the specified URL using the weather data API.
     * @param URL
     * @return
    */
    private func fetchData(from url: String) -> String? {
        guard let url = URL(string: url) else { return nil }
        var result: String? = nil
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(apiKey ?? "")", forHTTPHeaderField: "Authorization")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { semaphore.signal() }
            
            guard let data = data, error == nil else { return }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                result = String(data: data, encoding: .utf8)
            } else if let httpResponse = response as? HTTPURLResponse {
                print("Error code: \(httpResponse.statusCode)")
            }
        }.resume()
        
        semaphore.wait()
        return result
    }
    
    private func clearWeatherData() {
        for item in _weatherDailyData {
            item._WeatherHourlyData.removeAll()
            item._Events.removeAll()
        }
        _weatherDailyData.removeAll()
        _stations.removeAll()
    }
    
    /**
    * The handleWeatherDate function parse JSON structure from String.
    * @param jsonString
    */
    private func handleWeatherData(jsonString: String) {
        clearWeatherData()
        
        guard let data = jsonString.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
              let obj = jsonObject as? [String: Any] else {
            return
        }
        
        _queryCost = getInt64OrNull(from: obj, key: "queryCost")
        _latitude = getDoubleOrNull(from: obj, key: "latitude")
        _longitude = getDoubleOrNull(from: obj, key: "longitude")
        _resolvedAddress = getStringOrNull(from: obj, key: "resolvedAddress")
        _address = getStringOrNull(from: obj, key: "address")
        _timezone = getStringOrNull(from: obj, key: "timezone")
        _tzOffset = getDoubleOrNull(from: obj, key: "tzoffset")
        _weatherDailyData = []
        
        if let days = obj["days"] as? [[String: Any]] {
            for day in days {
                let weatherDayData = createWeatherDailyData(from: day)
                _weatherDailyData.append(weatherDayData)
            }
        }
        
        if let stationsJson = obj["stations"] as? [String: [String: Any]] {
            for (key, stationObj) in stationsJson {
                let station = Station(
                    _Distance: getDoubleOrNull(from: stationObj, key: "distance"),
                    _Latitude: getDoubleOrNull(from: stationObj, key: "latitude"),
                    _Longitude: getDoubleOrNull(from: stationObj, key: "longitude"),
                    _UseCount: getInt64OrNull(from: stationObj, key: "useCount"),
                    _Id: getStringOrNull(from: stationObj, key: "id"),
                    _Name: getStringOrNull(from: stationObj, key: "name"),
                    _Quality: getInt64OrNull(from: stationObj, key: "quality"),
                    _Contribution: getDoubleOrNull(from: stationObj, key: "contribution")
                )
                _stations[key] = station
            }
        }
    }
    
    /**
     * The createWeatherDailyData function creates an hourly data object from a JSON object.
     * The function checks if a key in the JSON object is null and sets the corresponding property to null if it is.
     * Otherwise, it assigns the value from the JSON object to the property.
     */
    private func createWeatherDailyData(from day: [String: Any]) -> WeatherDailyData {
        let weatherDailyData = WeatherDailyData()
        
        weatherDailyData._Datetime = Date(timeIntervalSince1970: getDoubleOrNull(from: day, key: "datetimeEpoch") ?? 0)
        weatherDailyData._DatetimeEpoch = getInt64OrNull(from: day, key: "datetimeEpoch")
        weatherDailyData._TempMax = getDoubleOrNull(from: day, key: "tempmax")
        weatherDailyData._TempMin = getDoubleOrNull(from: day, key: "tempmin")
        weatherDailyData._Temp = getDoubleOrNull(from: day, key: "temp")
        weatherDailyData._FeelsLikeMax = getDoubleOrNull(from: day, key: "feelslikemax")
        weatherDailyData._FeelsLikeMin = getDoubleOrNull(from: day, key: "feelslikemin")
        weatherDailyData._FeelsLike = getDoubleOrNull(from: day, key: "feelslike")
        weatherDailyData._Dew = getDoubleOrNull(from: day, key: "dew")
        weatherDailyData._Humidity = getDoubleOrNull(from: day, key: "humidity")
        weatherDailyData._Precip = getDoubleOrNull(from: day, key: "precip")
        weatherDailyData._PrecipProb = getDoubleOrNull(from: day, key: "precipprob")
        weatherDailyData._PrecipCover = getDoubleOrNull(from: day, key: "precipcover")
        weatherDailyData._PrecipType = day["preciptype"] as? [String] ?? []
        weatherDailyData._Snow = getDoubleOrNull(from: day, key: "snow")
        weatherDailyData._SnowDepth = getDoubleOrNull(from: day, key: "snowdepth")
        weatherDailyData._WindGust = getDoubleOrNull(from: day, key: "windgust")
        weatherDailyData._WindSpeed = getDoubleOrNull(from: day, key: "windspeed")
        weatherDailyData._WindDir = getDoubleOrNull(from: day, key: "winddir")
        weatherDailyData._Pressure = getDoubleOrNull(from: day, key: "pressure")
        weatherDailyData._CloudCover = getDoubleOrNull(from: day, key: "cloudcover")
        weatherDailyData._Visibility = getDoubleOrNull(from: day, key: "visibility")
        weatherDailyData._SolarRadiation = getDoubleOrNull(from: day, key: "solarradiation")
        weatherDailyData._SolarEnergy = getDoubleOrNull(from: day, key: "solarenergy")
        weatherDailyData._UvIndex = getDoubleOrNull(from: day, key: "uvindex")
        weatherDailyData._Sunrise = getStringOrNull(from: day, key: "sunrise")
        weatherDailyData._SunriseEpoch = getInt64OrNull(from: day, key: "sunriseEpoch")
        weatherDailyData._Sunset = getStringOrNull(from: day, key: "sunset")
        weatherDailyData._SunsetEpoch = getInt64OrNull(from: day, key: "sunsetEpoch")
        weatherDailyData._MoonPhase = getDoubleOrNull(from: day, key: "moonphase")
        weatherDailyData._Conditions = getStringOrNull(from: day, key: "conditions")
        weatherDailyData._Description = getStringOrNull(from: day, key: "description")
        weatherDailyData._Icon = getStringOrNull(from: day, key: "icon")
        weatherDailyData._Stations = day["stations"] as? [String] ?? []
        weatherDailyData._Source = getStringOrNull(from: day, key: "source")
        
        if let hours = day["hours"] as? [[String: Any]] {
            weatherDailyData._WeatherHourlyData = hours.map { createHourlyData(from: $0) }
        }
        
        if let events = day["events"] as? [[String: Any]] {
            weatherDailyData._Events = events.map { event in
                Event(
                    _Datetime: Date(timeIntervalSince1970: getDoubleOrNull(from: event, key: "datetimeEpoch") ?? 0),
                    _DatetimeEpoch: getInt64OrNull(from: event, key: "datetimeEpoch"),
                    _Type: getStringOrNull(from: event, key: "type"),
                    _Latitude: getDoubleOrNull(from: event, key: "latitude"),
                    _Longitude: getDoubleOrNull(from: event, key: "longitude"),
                    _Distance: getDoubleOrNull(from: event, key: "distance"),
                    _Description: getStringOrNull(from: event, key: "description"),
                    _Size: getDoubleOrNull(from: event, key: "size")
                )
            }
        }
        
        return weatherDailyData
    }
    
    /**
     * The createHourlyData function creates an hourly data object from a JSON object.
     * The function checks if a key in the JSON object is null and sets the corresponding property to null if it is.
     * Otherwise, it assigns the value from the JSON object to the property.
    */
    private func createHourlyData(from hour: [String: Any]) -> WeatherHourlyData {
        let weatherHourlyData = WeatherHourlyData()
        
        weatherHourlyData._Datetime = TimeInterval(getDoubleOrNull(from: hour, key: "datetimeEpoch") ?? 0)

        weatherHourlyData._DatetimeEpoch = getInt64OrNull(from: hour, key: "datetimeEpoch")
        weatherHourlyData._Temp = getDoubleOrNull(from: hour, key: "temp")
        weatherHourlyData._FeelsLike = getDoubleOrNull(from: hour, key: "feelslike")
        weatherHourlyData._Humidity = getDoubleOrNull(from: hour, key: "humidity")
        weatherHourlyData._Dew = getDoubleOrNull(from: hour, key: "dew")
        weatherHourlyData._Precip = getDoubleOrNull(from: hour, key: "precip")
        weatherHourlyData._PrecipProb = getDoubleOrNull(from: hour, key: "precipprob")
        weatherHourlyData._Snow = getDoubleOrNull(from: hour, key: "snow")
        weatherHourlyData._SnowDepth = getDoubleOrNull(from: hour, key: "snowdepth")
        weatherHourlyData._PrecipType = hour["preciptype"] as? [String] ?? []
        weatherHourlyData._WindGust = getDoubleOrNull(from: hour, key: "windgust")
        weatherHourlyData._WindSpeed = getDoubleOrNull(from: hour, key: "windspeed")
        weatherHourlyData._WindDir = getDoubleOrNull(from: hour, key: "winddir")
        weatherHourlyData._Pressure = getDoubleOrNull(from: hour, key: "pressure")
        weatherHourlyData._Visibility = getDoubleOrNull(from: hour, key: "visibility")
        weatherHourlyData._CloudCover = getDoubleOrNull(from: hour, key: "cloudcover")
        weatherHourlyData._SolarRadiation = getDoubleOrNull(from: hour, key: "solarradiation")
        weatherHourlyData._SolarEnergy = getDoubleOrNull(from: hour, key: "solarenergy")
        weatherHourlyData._UvIndex = getDoubleOrNull(from: hour, key: "uvindex")
        weatherHourlyData._Conditions = getStringOrNull(from: hour, key: "conditions")
        weatherHourlyData._Icon = getStringOrNull(from: hour, key: "icon")
        weatherHourlyData._Stations = hour["stations"] as? [String] ?? []
        weatherHourlyData._Source = getStringOrNull(from: hour, key: "source")
        
        return weatherHourlyData
    }
    
    /**
    * The fetchWeatherData function will fetch weather data from params.
    * @param location
    * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
    * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
    * consider our Multiple Location Timeline Weather API.
    * @param from
    * from param is the start date for which to retrieve weather data. Dates should be in the format yyyy-MM-dd.
    * For example 2020-10-19 for October 19th, 2020 or 2017-02-03 for February 3rd, 2017.
    * @param to
    * to param is the end date for which to retrieve weather data.
    * All dates and times are in local time of the specified location and should be in the format yyyy-MM-dd.
    * @param unitGroup
    * The system of units used for the output data.
    * Supported values are us, uk, metric, base. See Unit groups and measurement units for more information. Defaults to US system of units.
    * @param include
    * Specifies the sections you would like to include in the result data. This allows you to reduce query cost and latency. Specify this as a comma separated list. For example: &include=obs,fcst to include the historical observations and forecast data. The options are:
    *  - days – daily data
    *  - hours – hourly data
    *  - alerts – weather alerts
    *  - current – current conditions or conditions at requested time.
    *  - events – historical events such as a hail, tornadoes, wind damage and earthquakes (not enabled by default)
    *  - obs – historical observations from weather stations
    *  - remote – historical observations from remote source such as satellite or radar
    *  - fcst – forecast based on 16 day models.
    *  - stats – historical statistical normals and daily statistical forecast
    *  - statsfcst – use the full statistical forecast information for dates in the future beyond the current model forecast. Permits hourly statistical forecast.
    * @param elements
    * Specifies the specific weather elements you would like to include in the response as a comma separated list.
    * For example &elements=tempmax,tempmin,temp will request the only the tempmax, tempmin and temp response elements.
    * For the full list of available elements, see the response below.
    */
    public func fetchWeatherData(location: String, from: String, to: String, unitGroup: String, include: String, elements: String) {
        guard let apiKey = apiKey, !apiKey.isEmpty else {
            print("API key is not set.")
            return
        }
        
        let urlString = "\(WeatherData.BASE_URL)\(location)/\(from)/\(to)?key=\(apiKey)&include=\(include)&elements=\(elements)&unitGroup=\(unitGroup)"
        
        if let jsonString = fetchData(from: urlString) {
            handleWeatherData(jsonString: jsonString)
        }
    }
    
    /**
     * The fetchWeatherData function will fetch weather data from first date to second date.
     * @param location : String
     * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
     * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
     * consider our Multiple Location Timeline Weather API.
     * @param from     : String
     * from param is the start date for which to retrieve weather data. Dates should be in the format yyyy-MM-dd.
     * For example 2020-10-19 for October 19th, 2020 or 2017-02-03 for February 3rd, 2017.
     * @param to       : String
     * to param is the end date for which to retrieve weather data.
     * All dates and times are in local time of the specified location and should be in the format yyyy-MM-dd.
     */
    public func fetchWeatherData(location: String, from: String, to: String) {
        guard let apiKey = apiKey, !apiKey.isEmpty else {
            print("API key is not set.")
            return
        }
        
        let urlString = "\(WeatherData.BASE_URL)\(location)/\(from)/\(to)?key=\(apiKey)"
        
        if let jsonString = fetchData(from: urlString) {
            handleWeatherData(jsonString: jsonString)
        }
    }
    
    /**
     * The fetchWeatherData function will fetch weather data for a specific datetime.
     * @param location : String
     * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
     * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
     * consider our Multiple Location Timeline Weather API.
     * @param datetime : String
     * datetime param is the specific date for which to retrieve weather data.
     * All dates and times are in local time of the specified location and should be in the format yyyy-MM-dd.
     */
    public func fetchWeatherData(location: String, datetime: String) {
        guard let apiKey = apiKey, !apiKey.isEmpty else {
            print("API key is not set.")
            return
        }
        
        let urlString = "\(WeatherData.BASE_URL)\(location)/\(datetime)?key=\(apiKey)"
        
        if let jsonString = fetchData(from: urlString) {
            handleWeatherData(jsonString: jsonString)
        }
    }
    
    /**
    * The fetchForecastData function will fetch the weather forecast for location for the next 15 days
    * starting at midnight at the start of the current day (local time of the requested location).
    * @param location: String
    * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
    * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
    * consider our Multiple Location Timeline Weather API.
    */
    public func fetchWeatherData(location: String) {
        guard let apiKey = apiKey, !apiKey.isEmpty else {
            print("API key is not set.")
            return
        }
        
        let urlString = "\(WeatherData.BASE_URL)\(location)?key=\(apiKey)"
        
        if let jsonString = fetchData(from: urlString) {
            handleWeatherData(jsonString: jsonString)
        }
    }
    
    /**
     * The fetchForecastData function will fetch the weather forecast for location for the next 15 days
     * starting at midnight at the start of the current day (local time of the requested location).
     * @param location: String
     * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
     * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
     * consider our Multiple Location Timeline Weather API.
     */
    public func fetchForecastData(location: String) {
        guard let apiKey = apiKey, !apiKey.isEmpty else {
            print("API key is not set.")
            return
        }
        
        let urlString = "\(WeatherData.BASE_URL)\(location)?key=\(apiKey)"
        
        if let jsonString = fetchData(from: urlString) {
            handleWeatherData(jsonString: jsonString)
        }
    }
}
