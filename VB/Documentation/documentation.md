## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the VB libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

#### 1. **WeatherData Class**
   - **Description**: Acts as the central component for fetching and managing weather data from the Visual Crossing Weather API.
   - **Usage**:
     - **`FetchWeatherData(location As String, fromdate As String, todate As String, unitGroup As String, include As String, elements As String)`**: Fetches weather data for a specified location and date range.
       - **Parameters**:
         - `location`: Address or latitude-longitude of the desired location.
         - `fromdate`: Start date in `yyyy-MM-dd` format.
         - `todate`: End date in `yyyy-MM-dd` format.
         - `UnitGroup`: Unit system for the data (`us`, `uk`, `metric`, `base`).
         - `include`: Data sections to include (`days`, `hours`, `alerts`, etc.).
       - **Returns**: void
       - **Example**:
         ```VB
          ' Create weather API object with API key
          Dim weatherData As New WeatherData("YOUR_API_KEY")

          ' Fetch weather data with location, from date, to date params.
          weatherData.FetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events,hours", "")
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
     ```VB
      ' Create weather API object with API key
      Dim weatherData As New WeatherData("YOUR_API_KEY")

      ' Fetch weather data with location, from date, to date params.
      weatherData.FetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events,hours", "")

      ' Daily weather data array list
      Dim weatherDailyData As List(Of WeatherDailyData) = weatherData.WeatherDailyData

      If weatherDailyData IsNot Nothing Then
          For Each dailyData As WeatherDailyData In weatherDailyData
              ' Print max temperature
              Console.WriteLine($"{dailyData.Datetime}, {dailyData.TempMax}")

              ' Print min temperature
              Console.WriteLine($"{dailyData.Datetime}, {dailyData.TempMin}")

              ' Print humidity
              Console.WriteLine($"{dailyData.Datetime}, {dailyData.Humidity}")              
          Next
      End If
     ```

#### 3. **WeatherHourlyData Class**
   - **Description**: Manages hourly weather data storage and retrieval.
   - **Properties**:
     - Hour-specific attributes like temperature, wind speed, and humidity.
   - **Functions**:
     - Getters and setters for each weather attribute.
   - **Example**:
     ```VB
      ' Create weather API object with API key
      Dim weatherData As New WeatherData("YOUR_API_KEY")

      ' Fetch weather data with location, from date, to date params.
      weatherData.FetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events,hours", "")

      ' Daily weather data array list
      Dim weatherDailyData As List(Of WeatherDailyData) = weatherData.WeatherDailyData

      If weatherDailyData IsNot Nothing Then
          For Each dailyData As WeatherDailyData In weatherDailyData
              
              ' Hourly weather data array list
              Dim weatherHourlyData As List(Of WeatherHourlyData) = dailyData.WeatherHourlyData
              If weatherHourlyData IsNot Nothing Then
                  For Each hourlyData As WeatherHourlyData In weatherHourlyData
                      ' Print temperature
                      Console.WriteLine($"{hourlyData.Datetime}, {hourlyData.Temp}")

                      ' Print humidity
                      Console.WriteLine($"{hourlyData.Datetime}, {hourlyData.Humidity}")
                  Next
              End If
          Next
      End If
     ```

#### 4. **WEvent Class**
   - **Description**: Handles storage and retrieval of significant weather events such as storms and earthquakes.
   - **Properties**:
     - Event type, date, impact level, and description.
   - **Functions**:
     - Getters and setters for event details.
   - **Example**:
     ```VB
      ' Create weather API object with API key
      Dim weatherData As New WeatherData("YOUR_API_KEY")

      ' Fetch weather data with location, from date, to date params.
      weatherData.FetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events,hours", "")

      ' Daily weather data array list
      Dim weatherDailyData As List(Of WeatherDailyData) = weatherData.WeatherDailyData

      If weatherDailyData IsNot Nothing Then
          For Each dailyData As WeatherDailyData In weatherDailyData
              
              Dim events As List(Of [WEvent]) = dailyData.Events
              If events IsNot Nothing Then
                  For Each eventObj As [WEvent] In events
                      Console.WriteLine($"{eventObj.Datetime}, {eventObj.DatetimeEpoch}")
                  Next
              End If
          Next
      End If
     ```

#### 5. **WStation Class**
   - **Description**: Represents a weather station, providing details about the source of weather data.
   - **Properties**:
     - Station ID, name, latitude, and longitude.
   - **Functions**:
     - Getters and setters for station attributes.
   - **Example**:
     ```VB
      ' Create weather API object with API key
      Dim weatherData As New WeatherData("YOUR_API_KEY")

      ' Fetch weather data with location, from date, to date params.
      weatherData.FetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events,hours", "")

      Dim stations As Dictionary(Of String, WStation) = weatherData.Stations
      If stations IsNot Nothing Then
          For Each element In stations
              Dim station As WStation = element.Value
              Console.WriteLine($"{element.Key}, {station.Name}")
              Console.WriteLine($"{element.Key}, {station.Id}")
              Console.WriteLine($"{element.Key}, {station.UseCount}")
          Next
      End If
     ```

### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Data Library effectively. By following the examples and using the described functions, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.