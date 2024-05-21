## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the R libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

#### 1. **Weather Class**
   - **Description**: Acts as the central component for fetching and managing weather data from the Visual Crossing Weather API.
   - **Properties**
     - base_url (str): Base URL of the API.
     - api_key (str): API key for accessing the API.
     - weather_data (list): Internal storage for weather data.
   - **Usage**:
     - **`fetch_weather_data(location, from_date = "", to_date = "", unit_group = "us", include = "days", elements = "")`: Fetches weather data for a specified location and date range.
     If the unit_group is not specified, it will fetch the data based on US system. If only location paramter is given, it will fetch the next 15 days forecasting weather data
       - **Parameters**:
         - `location`(character): Address or latitude-longitude of the desired location.
         - `from`(character): Start date in `yyyy-MM-dd` format.
         - `to`(character): End date in `yyyy-MM-dd` format.
         - `unit_group`(character): Unit system for the data (`us`, `uk`, `metric`, `base`).
         - `include`(character): Data sections to include (`days`, `hours`, `alerts`, etc.).
         - `elements`(character): Specific weather elements to retrieve.
       - **Returns**:
        struct: The weather data as a struct.
       - **Example**:
         ```r
          weather = Weather(api_key='Your API Key')
          weather$fetch_weather_data("38.95,-95.664", "2024-01-01", '2024-01-12', 'hours')
         ```
     - **`get_weather_data(elements)`**: Retrieves the stored weather data.
       - **Parameters**:
         - `elements` (character vector): List of elements to include in the returned data.
       - **Returns**:
         struct: The weather data as a struct, filtered by elements if specified.
       - **Example**:
         ```r
          weather$get_weather_data(c('timezone', 'days'))
         ```
     - **`get_weather_daily_data( elements)` or `get_weather_hourly_data( elements)`**: Retrieves the daily or hourly weather data.
       - **Parameters**:
           - `elements` (character vector): List of elements to include in the returned data.
       - **Returns**:
         list: List of hourly data structs, filtered by elements if specified.
        - **Example**:
         ```r
          % ...
          weather$get_weather_daily_data()
          % ...
         ```
     - **Getting individual elements of the weather data**: Retrieves individual elements from the stored weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Example**:
         ```r
          % ...
          weather$get_queryCost()
          weather$get_tzoffset()
          weather$get_latitude()
          weather$get_longitude()
          weather$get_address()
          weather$get_timezone()
          weather$get_stations()
          % ...
         ```
     - **Getting individual elements from the daily weather data**: Retrieves individual elements from the daily weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Parameters**:
           - `day_info` (character|integer): The day's date as a string ('YYYY-MM-DD') or index as an integer
           - `elements` (character vector): Specific weather elements to retrieve.
       - **Example**:
         ```r
          % ...
          weather$get_data_on_day('2024-01-02')

          weather$get_temp_on_day('2024-01-02')
          weather$get_feelslike_on_day(1)
          weather$get_humidity_on_day('2024-01-02')
          weather$get_dew_on_day('2024-01-02')
          weather$get_precip_on_day('2024-01-02')
          weather$get_windgust_on_day('2024-01-02')

          weather$get_data_on_day('2024-01-02', c('temp', 'feelslike', 'humidity', 'dew', 'precip', 'windgust'))
          % ...
         ```
     - **Getting individual elements from the hourly weather data**: Retrieves individual elements from the hourly weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Parameters**:
           - `day_info` (character|integer): A day identifier, which can be a date string (YYYY-MM-DD) or an index.
           - `time_info` (character|integer): A time identifier, which can be a time string (HH:MM:SS) or an index.
           - `elements` (character vector): Specific weather elements to retrieve.
       - **Example**:
         ```r
          # ...
          weather$get_datetimeEpoch_at_datetime('2024-01-02','01:00:00')
          weather$get_temp_at_datetime('2024-01-02',1)
          weather$get_precip_at_datetime(1,'01:00:00')
          weather$get_data_at_datetime(1,1, c('temp', 'precip', 'humidity'))
          # ...
         ```
     - **Setting individual elements within the weather data**: Sets individual elements for the weather data using the corresponding methods. There are many predefined setters to set the elements of the weathe data in `Weather` class.
       - **Example**:
         ```r
          # ...

          weather$set_tzoffset(-3.0)
          weather$get_tzoffset()

          weather$set_tempmax_on_day('2024-01-02', 18)
          weather$get_tempmax_on_day(1)

          weather$set_data_at_datetime('2024-01-02', '01:00:00', list(temp = 25.0)
          weather$get_data_at_datetime('2024-01-02', '01:00:00'))

          weather$set_datetimeEpoch_at_datetime('2024-01-02', 1, 1111111111)
          weather$get_datetimeEpoch_at_datetime('2024-01-02', '01:00:00')
         ```

#### 2. **Additional Functions**
   - **Description**: Make managing and processing the weatehr data more easier.
   - **Key functions**:
     - `update_list`, `is_valid_list`, `extract_sublist_by_keys`, etc.

#### 3. **Building packages and using it**
After revising the library engouh, we can build as a package in `Library\weatherVisual` folder and use it.
   - **Build the package**
         ```r
          # ...
          devtools::build()
        ```
   - **Install the package**
         ```r
          # ...
          devtools::install()
        ```
   - **Usage**
         ```r
          # ...
          library(yourpackagename)
          weather_inst <- Weather$new(api_key="Your API Key")
        ```


### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Library effectively. By following the examples and using the described methods, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.