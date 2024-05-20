## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the MATLAB libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

#### 1. **Weather Class**
   - **Description**: Acts as the central component for fetching and managing weather data from the Visual Crossing Weather API.
   - **Properties**
     - base_url (str): Base URL of the API.
     - api_key (str): API key for accessing the API.
     - weather_data (struct): Internal storage for weather data.
   - **Usage**:
     - **`fetch_weather_data(obj, location, from_date, to_date, unit_group, include, elements)`: Fetches weather data for a specified location and date range.
     If the unit_group is not specified, it will fetch the data based on US system. If only location paramter is given, it will fetch the next 15 days forecasting weather data
       - **Parameters**:
         - `location`(char): Address or latitude-longitude of the desired location.
         - `from`(char): Start date in `yyyy-MM-dd` format.
         - `to`(char): End date in `yyyy-MM-dd` format.
         - `unit_group`(char): Unit system for the data (`us`, `uk`, `metric`, `base`).
         - `include`(char): Data sections to include (`days`, `hours`, `alerts`, etc.).
         - `elements`(char): Specific weather elements to retrieve.
       - **Returns**:
        struct: The weather data as a struct.
       - **Example**:
         ```matlab
          weather = Weather(api_key='Your API Key')
          weather.fetch_weather_data("38.95,-95.664", "2024-01-01", '2024-01-12', 'hours')
         ```
     - **`get_weather_data(obj, elements)`**: Retrieves the stored weather data.
       - **Parameters**:
         - `elements` (cell): List of elements to include in the returned data.
       - **Returns**:
         struct: The weather data as a struct, filtered by elements if specified.
       - **Example**:
         ```matlab
          weather.get_weather_data({'timezone', 'days'})
         ```
     - **`get_weather_daily_data(obj, elements)` or `get_weather_hourly_data(obj, elements)`**: Retrieves the daily or hourly weather data.
       - **Parameters**:
           - `elements` (cell): List of elements to include in the returned data.
       - **Returns**:
         cell: List of hourly data structs, filtered by elements if specified.
        - **Example**:
         ```matlab
          % ...
          weather.get_weather_daily_data()
          % ...
         ```
     - **Getting individual elements of the weather data**: Retrieves individual elements from the stored weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Example**:
         ```matlab
          % ...
          weather.get_queryCost()
          weather.get_tzoffset()
          weather.get_latitude()
          weather.get_longitude()
          weather.get_address()
          weather.get_timezone()
          weather.get_stations()
          % ...
         ```
     - **Getting individual elements from the daily weather data**: Retrieves individual elements from the daily weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Parameters**:
           - `day_info` (char|int): The day's date as a string ('YYYY-MM-DD') or index as an integer
           - `elements` (cell): Specific weather elements to retrieve.
       - **Example**:
         ```matlab
          % ...
          weather.get_data_on_day('2024-01-02')

          weather.get_temp_on_day('2024-01-02')
          weather.get_feelslike_on_day(1)
          weather.get_humidity_on_day('2024-01-02')
          weather.get_dew_on_day('2024-01-02')
          weather.get_precip_on_day('2024-01-02')
          weather.get_windgust_on_day('2024-01-02')

          weather.get_data_on_day('2024-01-02', {'temp', 'feelslike', 'humidity', 'dew', 'precip', 'windgust'})
          % ...
         ```
     - **Getting individual elements from the hourly weather data**: Retrieves individual elements from the hourly weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Parameters**:
           - `day_info` (char|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
           - `time_info` (char|int): A time identifier, which can be a time string (HH:MM:SS) or an index.
           - `elements` (cell): Specific weather elements to retrieve.
       - **Example**:
         ```matlab
          % ...
          weather.get_datetimeEpoch_at_datetime('2024-01-02','01:00:00')
          weather.get_temp_at_datetime('2024-01-02',1)
          weather.get_precip_at_datetime(1,'01:00:00')
          print(">>Weather data at a datetime: ", weather.get_data_at_datetime(1,1, {'temp', 'precip', 'humidity'}))
          % ...
         ```
     - **Setting individual elements within the weather data**: Sets individual elements for the weather data using the corresponding methods. There are many predefined setters to set the elements of the weathe data in `Weather` class.
       - **Example**:
         ```matlab
          % ...

          weather.set_tzoffset(-3.0)
          print(">>changed tzoffset: ", weather.get_tzoffset())

          weather.set_tempmax_on_day('2024-01-02', 18)
          print(">>changed tempmax on a day: ", weather.get_tempmax_on_day(1))

          weather.set_data_at_datetime('2024-01-02', '01:00:00', struct('temp', 25.0))
          print(">>Changed weather data at a datetime: ", weather.get_data_at_datetime('2024-01-02', '01:00:00'))

          weather.set_datetimeEpoch_at_datetime('2024-01-02', 1, '1111111111')
          print(">>changed datetimeEpoch at a datetime: ", weather.get_datetimeEpoch_at_datetime('2024-01-02', '01:00:00'))
         ```

#### 2. **Additional Functions**
   - **Description**: Make managing and processing the weatehr data more easier.
   - **Key functions**:
     - `update_struct`, `is_valid_struct`, `extract_substruct_by_keys`, etc.


### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Library effectively. By following the examples and using the described methods, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.