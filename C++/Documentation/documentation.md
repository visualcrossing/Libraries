## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the C++ libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

#### 1. **WeatherData Class**
   - **Description**: Acts as the central component for fetching and managing weather data from the Visual Crossing Weather API.
   - **Usage**:
     - **`fetchWeatherData(string location, string from, string to, string UnitGroup, string include)`**: Fetches weather data for a specified location and date range.
       - **Parameters**:
         - `location`: Address or latitude-longitude of the desired location.
         - `from`: Start date in `yyyy-MM-dd` format.
         - `to`: End date in `yyyy-MM-dd` format.
         - `UnitGroup`: Unit system for the data (`us`, `uk`, `metric`, `base`).
         - `include`: Data sections to include (`days`, `hours`, `alerts`, etc.).
       - **Returns**: void
       - **Example**:
         ```C++
          // create weather API object with API key
          WeatherData weatherData("YOUR_API_KEY");

          // fetch weather data with location, from date, to date params.

          weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "");
         ```
     - **`WeatherDailyData`**: Retrieves the daily weather data.
       - **Returns**: `WeatherDailyData`
     - **`WeatherHourlyData`**: Retrieves the hourly weather data.
       - **Returns**: `WeatherHourlyData`

#### 2. **WeatherDailyData Class**
   - **Description**: Manages daily weather data storage and retrieval.
   - **Properties**:
     - Temperature, precipitation, wind speed, and other daily metrics.
   - **Functions**:
     - Getters and setters for each weather attribute such as temperature, humidity, etc.
   - **Example**:
     ```C++
      // create weather API object with API key
      WeatherData weatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.

      weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "");

      //  daily weather data array list
      vector<WeatherDailyData> weatherDailyData = weatherData.getWeatherDailyData();

      for (WeatherDailyData dailyData : weatherDailyData) {
        tm date = dailyData.getDatetime();

        // Date convertion from tm object
        int y = date.tm_year + 1900;
        int m = date.tm_mon + 1;
        int d = date.tm_mday;

        // print max temperature
        cout << y << "-" << m << "-" << d << "," << dailyData.getTempMax() << endl;

        // print min temperature
        cout << y << "-" << m << "-" << d << "," << dailyData.getTempMin() << endl;

        // print humidity
        cout << y << "-" << m << "-" << d << "," << dailyData.getHumidity() << endl;
      }
     ```

#### 3. **WeatherHourlyData Class**
   - **Description**: Manages hourly weather data storage and retrieval.
   - **Properties**:
     - Hour-specific attributes like temperature, wind speed, and humidity.
   - **Functions**:
     - Getters and setters for each weather attribute.
   - **Example**:
     ```C++
      // create weather API object with API key
      WeatherData weatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.

      weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "");

      //  daily weather data array list
      vector<WeatherDailyData> weatherDailyData = weatherData.getWeatherDailyData();

      for (WeatherDailyData dailyData : weatherDailyData) {
        // get hourly weather data array list
        vector<WeatherHourlyData> weatherHourlyData = dailyData.getHourlyData();

        for (WeatherHourlyData hourlyData : weatherHourlyData) {
          tm time = hourlyData.getDatetime();

          // print temperature
          cout << time.tm_hour << ":" << time.tm_min << ":" << time.tm_sec << "," << hourlyData.getTemp() << endl;

          // print humidity
          cout << time.tm_hour << ":" << time.tm_min << ":" << time.tm_sec << "," << hourlyData.getHumidity() << endl;
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
     ```C++
      // create weather API object with API key
      WeatherData weatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.

      weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "");

      //  daily weather data array list
      vector<WeatherDailyData> weatherDailyData = weatherData.getWeatherDailyData();

      for (WeatherDailyData dailyData : weatherDailyData) {
        vector<Event> events = dailyData.getEvents();

        for (Event event : events) {
          tm time = event.getDatetime();

          int y = time.tm_year + 1900;
          int m = time.tm_mon + 1;
          int d = time.tm_mday;

          cout << y << "-" << m << "-" << d << " " << time.tm_hour << ":" << time.tm_min << ":" << time.tm_sec << "," << event.getDatetimeEpoch() << endl;
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
     ```C++
      // create weather API object with API key
      WeatherData weatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.

      weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "");

      unordered_map<string, Station> stations = weatherData.getStations();
      for (const auto& pair : stations) {
        string key = pair.first;
        Station station = pair.second;

        cout << key << endl;
        cout << station.getName() << endl;
        cout << station.getDistance() << endl;
      }
     ```

### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Data Library effectively. By following the examples and using the described functions, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.