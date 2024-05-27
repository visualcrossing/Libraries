## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the Python libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

#### 1. **Weather Struct**
   - **Description**: Acts as the central component for fetching and managing weather data from the Visual Crossing Weather API.
   - **Attributes**
     - BaseURL (string): Base URL of the API.
     - APIKey (string): API key for accessing the API.
     - weatherData (struct): Internal storage for weather data.
   - **Usage**:
     - **`FetchWeatherData(location, fromDate, toDate, unitGroup, include, elements string)`: Fetches weather data for a specified location and date range.
     If the unitGroup is not specified, it will fetch the data based on us system. If only location paramter is given, it will fetch the next 15 days forecasting weather data
       - **Parameters**:
         - `location`(string): Address or latitude-longitude of the desired location.
         - `from`(string): Start date in `yyyy-MM-dd` format.
         - `to`(string): End date in `yyyy-MM-dd` format.
         - `unitGroup`(string): Unit system for the data (`us`, `uk`, `metric`, `base`).
         - `include`(string): Data sections to include (`days`, `hours`, `alerts`, etc.).
         - `elements`(string): Specific weather elements to retrieve.
       - **Returns**:
        `WeatherData`: The weather data as a struct.
       - **Example**:
         ```go
          weatherInstance, err := weather.NewWeather("https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline", "Your API Key")
          weather.FetchWeatherData("38.95,-95.664", "2024-01-01", '2024-01-12', include='hours')
         ```
     - **`GetWeatherData(elements ...[]string)`**: Retrieves the stored weather data.
       - **Parameters**:
         - `elements`(...[]string, optional): List of elements to include in the returned data.
       - **Returns**:
         `WeatherData`: The weather data as a struct, filtered by elements if specified.
       - **Example**:
         ```go
          weather.PrintStruct(weatherInstance.GetWeatherData(), "")
         ```
     - **`GetWeatherDailyData(elements ...[]string)` or `GetWeatherHourlyData(elements ...[]string)`**: Retrieves the daily or hourly weather data.
       - **Parameters**:
           - `elements`(...[]string, optional): List of elements to include in the returned data.
       - **Returns**:
         `[]Day` or `[]Hour`: List of daily or hourly data struct, filtered by elements if specified.
        - **Example**:
         ```go
          // ...
          hourlyData := weatherInstance.GetWeatherHourlyData(elements)
          // ...
         ```
     - **Getting individual elements of the weather data**: Retrieves individual elements from the stored weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Example**:
         ```go
          // ...
          weatherInstance.GetQueryCost()
          weatherInstance.GetLatitude()
          weatherInstance.GetLongitude()
          weatherInstance.GetResolvedAddress()
          weatherInstance.GetAddress()
          weatherInstance.GetTimezone()
          weatherInstance.GetStations()
          // ...
         ```
     - **Getting individual elements from the daily weather data**: Retrieves individual elements from the daily weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Parameters**:
           - `dayInfo`(interface{}): The identifier for the day, which can be a date string (YYYY-MM-DD) or an index of the day list.
           - `elements`([]string, optional): Optional list of elements to include in the returned data for `GetDataOnDay` method.
       - **Example**:
         ```go
          // ...
          weatherInstance.GetDataOnDay("2024-01-02", nil)

          weatherInstance.GetTempOnDay("2024-01-02")
          weatherInstance.GetFeelslikeOnDay(1)
          weatherInstance.GetHumidityOnDay("2024-01-02")
          weatherInstance.GetDewOnDay("2024-01-02")
          weatherInstance.GetPrecipOnDay("2024-01-02")
          weatherInstance.GetWindgustOnDay("2024-01-02")

          weatherInstance.GetDataOnDay("2024-01-02", []string{"temp", "feelslike", "humidity", "dew", "precip", "windgust"})
          // ...
         ```
     - **Getting individual elements from the hourly weather data**: Retrieves individual elements from the hourly weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Parameters**:
           - `dayInfo` (interface{}): A day identifier, which can be a date string (YYYY-MM-DD) or an index, pointing to a specific day in the data.
           - `timeInfo` (interface{}): A time identifier, which can be a time string (HH:MM:SS) or an index, pointing to a specific time slot in the day's data.
           - `elements`(list, optional): Optional list of elements to include in the returned data for `GetDataAtDatetime` method.
       - **Example**:
         ```go
          # ...
          weatherInstance.GetDatetimeEpochAtDatetime("2024-01-02", "01:00:00")
          weatherInstance.GetTempAtDatetime("2024-01-02", 1)
          weatherInstance.GetPrecipAtDatetime(1, "01:00:00")
          # ...
         ```
     - **Setting individual elements within the weather data**: Sets individual elements for the weather data using the corresponding methods. There are many predefined setters to set the elements of the weathe data in `Weather` class.
       - **Example**:
         ```go
          # ...

          weatherInstance.SetTzoffset(-3.0)
          fmt.Println(">>changed tzoffset: ", weatherInstance.GetTzoffset())

          weatherInstance.SetTempmaxOnDay("2024-01-02", 18)
          fmt.Println(">>changed tempmax on a day: ", weatherInstance.get_tempmax_on_day(1))

          weatherInstance.set_datetimeEpoch_at_datetime("2024-01-02", 1, 1111111111)
          fmt.Println(">>changed datetimeEpoch at a datetime: ", weatherInstance.get_datetimeEpoch_at_datetime("2024-01-02", "01:00:00"))
         ```

#### 2. **Additional Functions**
   - **Description**: Make managing and processing the weatehr data more easier.
   - **Key functions**:
     - `UpdateStruct`, `IsValidStruct`, `ExtractSubstructByFields`, etc.


### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Library effectively. By following the examples and using the described methods, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.