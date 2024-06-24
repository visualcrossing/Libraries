## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the Swift libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

#### 1. **WeatherData Class**
   - **Description**: Acts as the central component for fetching and managing weather data from the Visual Crossing Weather API.
   - **Usage**:
     - **` fetchWeatherData(location: String, from: String, to: String, unitGroup: String, include: String, elements: String)`**: Fetches weather data for a specified location and date range.
       - **Parameters**:
         - `location`: Address or latitude-longitude of the desired location.
         - `from`: Start date in `yyyy-MM-dd` format.
         - `to`: End date in `yyyy-MM-dd` format.
         - `unitGroup`: Unit system for the data (`us`, `uk`, `metric`, `base`).
         - `include`: Data sections to include (`days`, `hours`, `alerts`, etc.).
       - **Returns**: void
       - **Example**:
         ```Swift
          // Create weather API object with API key
          let weatherData = WeatherData(apiKey: "YOUR_API_KEY")

          // Fetch weather data with location, from date, to date params
          weatherData.fetchWeatherData(location: "38.96%2C-96.02", from: "2020-7-10", to: "2020-7-12", unitGroup: "us", include: "events", elements: "")
         ```
     - **`_WeatherDailyData`**: Retrieves the daily weather data.
       - **Returns**: `WeatherDailyData`
     - **`_WeatherHourlyData`**: Retrieves the hourly weather data.
       - **Returns**: `WeatherHourlyData`

#### 2. **WeatherDailyData Class**
   - **Description**: Manages daily weather data storage and retrieval.
   - **Properties**:
     - Temperature, precipitation, wind speed, and other daily metrics.
   - **Functions**:
     - Getters and setters for each weather attribute such as temperature, humidity, etc.
   - **Example**:
     ```Swift
      // Create weather API object with API key
      let weatherData = WeatherData(apiKey: "YOUR_API_KEY")

      // Fetch weather data with location, from date, to date params
      weatherData.fetchWeatherData(location: "38.96%2C-96.02", from: "2020-7-10", to: "2020-7-12", unitGroup: "us", include: "events", elements: "")

      // Daily weather data array list
      let weatherDailyData = weatherData._WeatherDailyData
     ```

#### 3. **WeatherHourlyData Class**
   - **Description**: Manages hourly weather data storage and retrieval.
   - **Properties**:
     - Hour-specific attributes like temperature, wind speed, and humidity.
   - **Functions**:
     - Getters and setters for each weather attribute.
   - **Example**:
     ```Swift
      // Create weather API object with API key
      let weatherData = WeatherData(apiKey: "YOUR_API_KEY")

      // Fetch weather data with location, from date, to date params
      weatherData.fetchWeatherData(location: "38.96%2C-96.02", from: "2020-7-10", to: "2020-7-12", unitGroup: "us", include: "events", elements: "")

      // Daily weather data array list
      let weatherDailyData = weatherData._WeatherDailyData

      for dailyData in weatherDailyData {         
          
          // Hourly weather data array list
          let weatherHourlyData = dailyData._WeatherHourlyData
          for hourlyData in weatherHourlyData {
              // Print temperature
              print("\(hourlyData._Datetime ?? TimeInterval()), \(hourlyData._Temp ?? 0.0)")
              
              // Print humidity
              print("\(hourlyData._Datetime ?? TimeInterval()), \(hourlyData._Humidity ?? 0.0)")
          }
      }
     ```

#### 4. **Event Class**
   - **Description**: Handles storage and retrieval of significant weather events such as storms and earthquakes.
   - **Properties**:
     - Event type, date, impact level, and description.
   - **Functions**:
     - Getters and setters for event details.
   - **Example**:
     ```Swift
      // Create weather API object with API key
      let weatherData = WeatherData(apiKey: "YOUR_API_KEY")

      // Fetch weather data with location, from date, to date params
      weatherData.fetchWeatherData(location: "38.96%2C-96.02", from: "2020-7-10", to: "2020-7-12", unitGroup: "us", include: "events", elements: "")

      // Daily weather data array list
      let weatherDailyData = weatherData._WeatherDailyData

      for dailyData in weatherDailyData {         
          // Print events
          let events = dailyData._Events
          for eventObj in events {
              print("\(eventObj._Datetime ?? Date()), \(eventObj._DatetimeEpoch ?? 0)")
          }

      }
     ```

#### 5. **Station Class**
   - **Description**: Represents a weather station, providing details about the source of weather data.
   - **Properties**:
     - Station ID, name, latitude, and longitude.
   - **Functions**:
     - Getters and setters for station attributes.
   - **Example**:
     ```Swift
      // Stations dictionary
      // Create weather API object with API key
      let weatherData = WeatherData(apiKey: "YOUR_API_KEY")

      // Fetch weather data with location, from date, to date params
      weatherData.fetchWeatherData(location: "38.96%2C-96.02", from: "2020-7-10", to: "2020-7-12", unitGroup: "us", include: "events", elements: "")

      let stations = weatherData._Stations
      for (key, station) in stations {
          print("\(key), \(station._Name ?? "")")
          print("\(key), \(station._Id ?? "")")
          print("\(key), \(station._UseCount ?? 0)")
      }
     ```

### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Data Library effectively. By following the examples and using the described functions, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.