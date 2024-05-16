## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the Kotlin libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

#### 1. **WeatherData Class**
   - **Description**: Acts as the central component for fetching and managing weather data from the Visual Crossing Weather API.
   - **Usage**:
     - **`fun fetchWeatherData(location: String, from: String, to: String, unitGroup: String = "us", include: String = "days", elements: String = "all")`**: Fetches weather data for a specified location and date range.
       - **Parameters**:
         - `location`: Address or latitude-longitude of the desired location.
         - `from`: Start date in `yyyy-MM-dd` format.
         - `to`: End date in `yyyy-MM-dd` format.
         - `UnitGroup`: Unit system for the data (`us`, `uk`, `metric`, `base`).
         - `include`: Data sections to include (`days`, `hours`, `alerts`, etc.).
       - **Returns**: void
       - **Example**:
         ```Kotlin
          // create weather API object with API key
          val weatherData = WeatherData("YOUR_API_KEY")


          // fetch weather data with location, from date, to date params.
          weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "")

         ```
     - **`weatherDailyData`**: Retrieves the daily weather data.
       - **Returns**: `WeatherDailyData`
     - **`WeatherHourlyData`**: Retrieves the hourly weather data.
       - **Returns**: `WeatherHourlyData`

#### 2. **WeatherDailyData Class**
   - **Description**: Manages daily weather data storage and retrieval.
   - **Properties**:
     - Temperature, precipitation, wind speed, and other daily metrics.
   - **Methods**:
     - Getters and setters for each weather attribute such as temperature, humidity, etc.
   - **Example**:
     ```Kotlin
      // create weather API object with API key
      val weatherData = WeatherData("YOUR_API_KEY")


      // fetch weather data with location, from date, to date params.
      weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "")


      // get daily weather data array list
      val weatherDailyData: ArrayList<WeatherDailyData>? = weatherData.weatherDailyData

      if (weatherDailyData != null) {
          for (dailyData in weatherDailyData) {
              // print max temperature
              println(dailyData.datetime.toString() + "," + dailyData.tempmax)

              // print min temperature
              println(dailyData.datetime.toString() + "," + dailyData.tempmin)

              // print humidity
              println(dailyData.datetime.toString() + "," + dailyData.humidity)              
          }
      }
     ```

#### 3. **WeatherHourlyData Class**
   - **Description**: Manages hourly weather data storage and retrieval.
   - **Properties**:
     - Hour-specific attributes like temperature, wind speed, and humidity.
   - **Methods**:
     - Getters and setters for each weather attribute.
   - **Example**:
     ```Kotlin
      // create weather API object with API key
      val weatherData = WeatherData("YOUR_API_KEY")


      // fetch weather data with location, from date, to date params.
      weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "")


      // get daily weather data array list
      val weatherDailyData: ArrayList<WeatherDailyData>? = weatherData.weatherDailyData

      if (weatherDailyData != null) {
          for (dailyData in weatherDailyData) {

              // get hourly weather data array list
              val weatherHourlyData: ArrayList<WeatherHourlyData>? = dailyData.weatherHourlyData
              if (weatherHourlyData != null) {
                  for (hourlyData in weatherHourlyData) {
                      // print temperature
                      println(hourlyData.datetime.toString() + "," + hourlyData.temp)

                      // print humidity
                      println(hourlyData.datetime.toString() + "," + hourlyData.humidity)
                  }
              }              
          }
      }
     ```

#### 4. **Event Class**
   - **Description**: Handles storage and retrieval of significant weather events such as storms and earthquakes.
   - **Properties**:
     - Event type, date, impact level, and description.
   - **Methods**:
     - Getters and setters for event details.
   - **Example**:
     ```Kotlin
      // create weather API object with API key
      val weatherData = WeatherData("YOUR_API_KEY")


      // fetch weather data with location, from date, to date params.
      weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "")


      // get daily weather data array list
      val weatherDailyData: ArrayList<WeatherDailyData>? = weatherData.weatherDailyData

      if (weatherDailyData != null) {
          for (dailyData in weatherDailyData) {
              
              val events = dailyData.events
              if (events != null) {
                  for (event in events) {
                      println(event.datetime.toString() + "," + event.datetimeEpoch)
                  }
              }
          }
      }
     ```

#### 5. **Station Class**
   - **Description**: Represents a weather station, providing details about the source of weather data.
   - **Properties**:
     - Station ID, name, latitude, and longitude.
   - **Methods**:
     - Getters and setters for station attributes.
   - **Example**:
     ```Kotlin
      // create weather API object with API key
      WeatherData weatherData = new WeatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.
      weatherData.fetchWeatherData("38.96%2C-96.02","2020-7-10","2020-7-12","us","events","");

      val stationHashMap = weatherData.stations
      stationHashMap.keys.forEach(Consumer { key: String ->
          val station = stationHashMap[key]
          println(key)
          println(station!!.name)
          println(station!!.distance)
          println(station!!.distance)
      })
     ```

### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Data Library effectively. By following the examples and using the described methods, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.