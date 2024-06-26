## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the Scala libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

#### 1. **WeatherData Class**
   - **Description**: Acts as the central component for fetching and managing weather data from the Visual Crossing Weather API.
   - **Usage**:
     - **`fetchWeatherData(String location, String from, String to, String UnitGroup, String include)`**: Fetches weather data for a specified location and date range.
       - **Parameters**:
         - `location`: Address or latitude-longitude of the desired location.
         - `from`: Start date in `yyyy-MM-dd` format.
         - `to`: End date in `yyyy-MM-dd` format.
         - `UnitGroup`: Unit system for the data (`us`, `uk`, `metric`, `base`).
         - `include`: Data sections to include (`days`, `hours`, `alerts`, etc.).
       - **Returns**: void
       - **Example**:
         ```Scala
            // create weather API object with API key
            val weatherData = WeatherData("3KAJKHWT3UEMRQWF2ABKVVVZE")

            // fetch weather data with location, from date, to date params.
            weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events,hours", "")

         ```
     - **`getWeatherDailyData()`**: Retrieves the daily weather data.
       - **Returns**: `WeatherDailyData`
     - **`getWeatherHourlyData()`**: Retrieves the hourly weather data.
       - **Returns**: `WeatherHourlyData`

#### 2. **WeatherDailyData Class**
   - **Description**: Manages daily weather data storage and retrieval.
   - **Properties**:
     - Temperature, precipitation, wind speed, and other daily metrics.
   - **Methods**:
     - Getters and setters for each weather attribute such as temperature, humidity, etc.
   - **Example**:
     ```Scala
      // create weather API object with API key
      val weatherData = WeatherData("3KAJKHWT3UEMRQWF2ABKVVVZE")

      // fetch weather data with location, from date, to date params.
      weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events,hours", "")

      // get daily weather data array list
      val weatherDailyData: ArrayBuffer[WeatherDailyData] = weatherData.getWeatherDailyData

      if (weatherDailyData != null) {
        for (dailyData <- weatherDailyData) {
          // print max temperature
          println(s"${dailyData.datetime.get}, ${dailyData.tempmax.get}")

          // print min temperature
          println(s"${dailyData.datetime.get}, ${dailyData.tempmax.get}")

          // print humidity
          println(s"${dailyData.datetime.get}, ${dailyData.humidity.get}")
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
     ```Scala
        // create weather API object with API key
        val weatherData = WeatherData("3KAJKHWT3UEMRQWF2ABKVVVZE")

        // fetch weather data with location, from date, to date params.
        weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events,hours", "")

        // get daily weather data array list
        val weatherDailyData: ArrayBuffer[WeatherDailyData] = weatherData.getWeatherDailyData

        if (weatherDailyData != null) {
          for (dailyData <- weatherDailyData) {           
            // get hourly weather data array list
            val weatherHourlyData: Option[ArrayBuffer[WeatherHourlyData]] = dailyData.weatherHourlyData
            weatherHourlyData.foreach { hourlyDataArray =>
              for (hourlyData <- hourlyDataArray) {
                // print temperature
                println(s"${hourlyData.datetime.get}, ${hourlyData.temp.get}")

                // print humidity
                println(s"${hourlyData.datetime.get}, ${hourlyData.humidity.get}")
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
     ```Scala
        // create weather API object with API key
        val weatherData = WeatherData("3KAJKHWT3UEMRQWF2ABKVVVZE")

        // fetch weather data with location, from date, to date params.
        weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events,hours", "")

        // get daily weather data array list
        val weatherDailyData: ArrayBuffer[WeatherDailyData] = weatherData.getWeatherDailyData

        if (weatherDailyData != null) {
          for (dailyData <- weatherDailyData) {            

            val events: Option[ArrayBuffer[Event]] = dailyData.events
            events.foreach { eventArray =>
              for (event <- eventArray) {
                println(s"${event.datetime.get}, ${event.datetimeEpoch.get}")
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
     ```Scala
        // create weather API object with API key
        val weatherData = WeatherData("3KAJKHWT3UEMRQWF2ABKVVVZE")

        // fetch weather data with location, from date, to date params.
        weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events,hours", "")

        val stationHashMap: HashMap[String, Station] = weatherData.getStations
        stationHashMap.keys.foreach { key =>
          val station = stationHashMap(key)
          println(key)
          println(station.name.get)
          println(station.distance.get)
          println(station.id.get)
        }
     ```

### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Data Library effectively. By following the examples and using the described methods, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.