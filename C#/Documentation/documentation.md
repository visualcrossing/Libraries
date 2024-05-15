## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the C# libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

#### 1. **WeatherData Class**
   - **Description**: Acts as the central component for fetching and managing weather data from the Visual Crossing Weather API.
   - **Usage**:
     - **`FetchWeatherData(String location, String from, String to, String UnitGroup, String include)`**: Fetches weather data for a specified location and date range.
       - **Parameters**:
         - `location`: Address or latitude-longitude of the desired location.
         - `from`: Start date in `yyyy-MM-dd` format.
         - `to`: End date in `yyyy-MM-dd` format.
         - `UnitGroup`: Unit system for the data (`us`, `uk`, `metric`, `base`).
         - `include`: Data sections to include (`days`, `hours`, `alerts`, etc.).
       - **Returns**: void
       - **Example**:
         ```C#
          // create weather API object with API key
          WeatherData weatherData = new WeatherData("YOUR_API_KEY");

          // fetch weather data with location, from date, to date params.

          weatherData.FetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "");
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
     ```C#
      // create weather API object with API key
      WeatherData weatherData = new WeatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.

      weatherData.FetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "");

      //  daily weather data array list
      List<WeatherDailyData> weatherDailyData = weatherData.WeatherDailyData;

      if (weatherDailyData != null)
      {
        foreach (WeatherDailyData dailyData in weatherDailyData)
        {
            // print max temperature
            Console.WriteLine($"{dailyData.Datetime}, {dailyData.TempMax}");

            // print min temperature
            Console.WriteLine($"{dailyData.Datetime}, {dailyData.TempMin}");

            // print humidity
            Console.WriteLine($"{dailyData.Datetime}, {dailyData.Humidity}");  
        }
      }
     ```

#### 3. **WeatherHourlyData Class**
   - **Description**: Manages hourly weather data storage and retrieval.
   - **Properties**:
     - Hour-specific attributes like temperature, wind speed, and humidity.
   - **Functions**:
     - Getters and setters for each weather attribute.
   - **Example**:
     ```C#
      // create weather API object with API key
      WeatherData weatherData = new WeatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.

      weatherData.FetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "");

      //  daily weather data array list
      List<WeatherDailyData> weatherDailyData = weatherData.WeatherDailyData;

      if (weatherDailyData != null)
      {
        foreach (WeatherDailyData dailyData in weatherDailyData)
        {
          // hourly weather data array list
          List<WeatherHourlyData> weatherHourlyData = dailyData.WeatherHourlyData;
          if (weatherHourlyData != null)
          {
              foreach (WeatherHourlyData hourlyData in weatherHourlyData)
              {
                  // print temperature
                  Console.WriteLine($"{hourlyData.Datetime}, {hourlyData.Temp}");

                  // print humidity
                  Console.WriteLine($"{hourlyData.Datetime}, {hourlyData.Humidity}");
              }
          } 
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
     ```C#
      // create weather API object with API key
      WeatherData weatherData = new WeatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.

      weatherData.FetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "");

      //  daily weather data array list
      List<WeatherDailyData> weatherDailyData = weatherData.WeatherDailyData;

      if (weatherDailyData != null)
      {
        foreach (WeatherDailyData dailyData in weatherDailyData)
        {
          List<Event> events = dailyData.Events;
          if (events != null)
          {
              foreach (Event eventObj in events)
              {
                  Console.WriteLine($"{eventObj.Datetime}, {eventObj.DatetimeEpoch}");
              }
          }
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
     ```C#
      // create weather API object with API key
      WeatherData weatherData = new WeatherData("YOUR_API_KEY");

      // fetch weather data with location, from date, to date params.

      weatherData.FetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "");

      Dictionary<string, Station> stations = weatherData.Stations;
      if (stations != null)
      {
          foreach (var item in stations)
          {
              Station station = item.Value;
              Console.WriteLine($"{item.Key}, {station.Name}");
              Console.WriteLine($"{item.Key}, {station.Id}");
              Console.WriteLine($"{item.Key}, {station.UseCount}");
          }
      }
     ```

### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Data Library effectively. By following the examples and using the described functions, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.