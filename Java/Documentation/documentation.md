## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the Java libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

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
         ```java
         WeatherData weatherData = new WeatherData();
         weatherData.fetchWeatherData("38.95,-95.664", "2023-01-01", "2023-01-07", "metric", "days,hours");
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
     ```java
      // create weather API object with API key
      WeatherData weatherData = new WeatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.

      weatherData.fetchWeatherData("38.96%2C-96.02","2020-7-10","2020-7-12","us","events","");

      // get daily weather data array list
      ArrayList<WeatherDailyData> weatherDailyData = weatherData.getWeatherDailyData();

      if (weatherDailyData != null) {
          for (WeatherDailyData dailyData : weatherDailyData) {
              // print max temperature
              System.out.println(dailyData.getDatetime() + "," + dailyData.getTempMax());

              // print min temperature
              System.out.println(dailyData.getDatetime() + "," + dailyData.getTempMin());

              // print humidity
              System.out.println(dailyData.getDatetime() + "," + dailyData.getHumidity());
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
     ```java
      // create weather API object with API key
      WeatherData weatherData = new WeatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.

      weatherData.fetchWeatherData("38.96%2C-96.02","2020-7-10","2020-7-12","us","events","");

      // get daily weather data array list
      ArrayList<WeatherDailyData> weatherDailyData = weatherData.getWeatherDailyData();

      if (weatherDailyData != null) {
          for (WeatherDailyData dailyData : weatherDailyData) {              

              // get hourly weather data array list
              ArrayList<WeatherHourlyData> weatherHourlyData = dailyData.getHourlyData();
              if (weatherHourlyData != null) {
                  for (WeatherHourlyData hourlyData : weatherHourlyData) {
                      // print temperature
                      System.out.println(hourlyData.getDatetime() + "," + hourlyData.getTemp());

                      // print humidity
                      System.out.println(hourlyData.getDatetime() + "," + hourlyData.getHumidity());
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
     ```java
      // create weather API object with API key
      WeatherData weatherData = new WeatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.

      weatherData.fetchWeatherData("38.96%2C-96.02","2020-7-10","2020-7-12","us","events","");

      // get daily weather data array list
      ArrayList<WeatherDailyData> weatherDailyData = weatherData.getWeatherDailyData();

      if (weatherDailyData != null) {
          for (WeatherDailyData dailyData : weatherDailyData) {
              // get event list              
              ArrayList<Event> events = dailyData.getEvents();
              if (events != null) {
                  for (Event event : events) {
                      System.out.println(event.getDatetime() + "," + event.getDatetimeEpoch());
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
     ```java
      // create weather API object with API key
      WeatherData weatherData = new WeatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.
      weatherData.fetchWeatherData("38.96%2C-96.02","2020-7-10","2020-7-12","us","events","");

      HashMap<String, Station> stationHashMap = weatherData.getStations();
      stationHashMap.keySet().forEach(key -> {
        Station station = stationHashMap.get(key);
        System.out.println(key);
        System.out.println(station.getName());
        System.out.println(station.getDistance());
        System.out.println(station.getDistance());
      });
     ```

### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Data Library effectively. By following the examples and using the described methods, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.