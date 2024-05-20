## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the JavaScript libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

#### 1. **Weather Class**
   - **Description**: Acts as the central component for fetching and managing weather data from the Visual Crossing Weather API.
   - **Properties**
     - baseUrl (str): Base URL of the API.
     - apiKey (str): API key for accessing the API.
     - weatherData (Object): Internal storage for weather data.
   - **Usage**:
     - **`async fetchWeatherData(location, fromDate = '', toDate = '', unitGroup = 'us', include = 'days', elements = '')`: Fetches weather data for a specified location and date range.
     If the unitGroup is not specified, it will fetch the data based on US system. If only location paramter is given, it will fetch the next 15 days forecasting weather data
       - **Parameters**:
         - `location`(string): Address or latitude-longitude of the desired location.
         - `fromDate`(string): Start date in `yyyy-MM-dd` format.
         - `toDate`(string): End date in `yyyy-MM-dd` format.
         - `unitGroup`(string): Unit system for the data (`us`, `uk`, `metric`, `base`).
         - `include`(string): Data sections to include (`days`, `hours`, `alerts`, etc.).
         - `elements`(string): Specific weather elements to retrieve.
       - **Returns**:
        Object: The weather data as a Object.
       - **Example**:
         ```JavaScript
          weather = Weather('Your API Key')
          await weather.fetchWeatherData("38.95,-95.664", "2024-01-01", '2024-01-12', 'hours')
         ```
     - **`getWeatherData(elements = [])`**: Retrieves the stored weather data.
       - **Parameters**:
         - `elements` (Array<string>): List of elements to include in the returned data.
       - **Returns**:
         Object: The weather data as a Object, filtered by elements if specified.
       - **Example**:
         ```JavaScript
          weather.getWeatherData(['timezone', 'days'])
         ```
     - **`getWeatherDailyData(elements = [])` or `getWeatherHourlyData(elements = [])`**: Retrieves the daily or hourly weather data.
       - **Parameters**:
           - `elements` (Array<string>): List of elements to include in the returned data.
       - **Returns**:
         Array<string>: List of hourly data Objects, filtered by elements if specified.
        - **Example**:
         ```JavaScript
          % ...
          weather.getWeatherDailyData()
          % ...
         ```
     - **Getting individual elements of the weather data**: Retrieves individual elements from the stored weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Example**:
         ```JavaScript
          % ...
          weather.getQueryCost()
          weather.getTzoffset()
          weather.getLatitude()
          weather.getLongitude()
          weather.getAddress()
          weather.getTimezone()
          weather.getStations()
          % ...
         ```
     - **Getting individual elements from the daily weather data**: Retrieves individual elements from the daily weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Parameters**:
           - `dayInfo` (string|number):  The identifier for the day, which can be a date string (YYYY-MM-DD) or an index of the day list.
           - `elements` (Array<string>): Specific weather elements to retrieve.
       - **Example**:
         ```JavaScript
          % ...
          weather.getDataOnDay('2024-01-02')

          weather.getTempOnDay('2024-01-02')
          weather.getFeelslikeOnDay(1)
          weather.getHumidityOnDay('2024-01-02')
          weather.getDewOnDay('2024-01-02')
          weather.getPrecipOnDay('2024-01-02')
          weather.getWindgustOnDay('2024-01-02')

          weather.getDataOnDay('2024-01-02', ['temp', 'feelslike', 'humidity', 'dew', 'precip', 'windgust'])
          % ...
         ```
     - **Getting individual elements from the hourly weather data**: Retrieves individual elements from the hourly weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Parameters**:
           - `dayInfo` (string|number): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
           - `timeInfo` (string|number): A time identifier, which can be a time string (HH:MM:SS) or an index.
           - `elements` (Array<string>): Specific weather elements to retrieve.
       - **Example**:
         ```JavaScript
          % ...
          weather.getDatetimeEpochAtDatetime('2024-01-02','01:00:00')
          weather.getTempAtDatetime('2024-01-02',1)
          weather.getPrecipAtDatetime(1,'01:00:00')
          print(">>Weather data at a datetime: ", weather.getDataAtDatetime(1,1, ['temp', 'precip', 'humidity']))
          % ...
         ```
     - **Setting individual elements within the weather data**: Sets individual elements for the weather data using the corresponding methods. There are many predefined setters to set the elements of the weathe data in `Weather` class.
       - **Example**:
         ```JavaScript
          % ...

          weather.setTzoffset(-3.0)
          print(">>changed tzoffset: ", weather.getTzoffset())

          weather.setTempmaxOnDay('2024-01-02', 18)
          print(">>changed tempmax on a day: ", weather.getTempmaxOnDay(1))

          weather.setDataAtDatetime('2024-01-02', '01:00:00', {'temp', 25.0}))
          print(">>Changed weather data at a datetime: ", weather.getDataAtDatetime('2024-01-02', '01:00:00'))

          weather.setDatetimeEpochAtDatetime('2024-01-02', 1, 1111111111)
          print(">>changed datetimeEpoch at a datetime: ", weather.getDatetimeEpochAtDatetime('2024-01-02', '01:00:00'))
         ```

#### 2. **Additional Functions**
   - **Description**: Make managing and processing the weatehr data more easier.
   - **Key functions**:
     - `updateObject`, `isValidObject`, `extractSubobjectByKeys`, etc.


### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Library effectively. By following the examples and using the described methods, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.