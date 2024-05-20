## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the Python libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

#### 1. **Weather Class**
   - **Description**: Acts as the central component for fetching and managing weather data from the Visual Crossing Weather API.
   - **Attributes**
     - base_url (str): Base URL of the API.
     - api_key (str): API key for accessing the API.
     - __weather_data (dict): Internal storage for weather data.
   - **Usage**:
     - **`fetch_weather_data(self, location, from_date='', to_date='', unit_group='metric', include='days', elements='')`: Fetches weather data for a specified location and date range.
     If the unit_group is not specified, it will fetch the data based on US system. If only location paramter is given, it will fetch the next 15 days forecasting weather data
       - **Parameters**:
         - `location`(str): Address or latitude-longitude of the desired location.
         - `from`(str): Start date in `yyyy-MM-dd` format.
         - `to`(str): End date in `yyyy-MM-dd` format.
         - `unit_group`(str): Unit system for the data (`us`, `uk`, `metric`, `base`).
         - `include`(str): Data sections to include (`days`, `hours`, `alerts`, etc.).
         - `elements`(str): Specific weather elements to retrieve.
       - **Returns**:
        dict: The weather data as a dictionary.
       - **Example**:
         ```python
          weather = Weather(api_key='Your API Key')
          weather.fetch_weather_data("38.95,-95.664", "2024-01-01", '2024-01-12', include='hours')
         ```
     - **`get_weather_data(self, elements=[])`**: Retrieves the stored weather data.
       - **Parameters**:
         - `elements`(list, optional): List of elements to include in the returned data.
       - **Returns**:
         dict: The weather data as a dictionary, filtered by elements if specified.
       - **Example**:
         ```python
          weather.get_weather_data(['timezone', 'days'])
         ```
     - **`get_weather_daily_data(self, elements=[])` or `get_weather_hourly_data(self, elements=[])`**: Retrieves the daily or hourly weather data.
       - **Parameters**:
           - `elements`(list, optional): List of elements to include in the returned data.
       - **Returns**:
         list: List of daily or hourly data dictionaries, filtered by elements if specified.
        - **Example**:
         ```python
          # ...
          weather.get_weather_daily_data()
          # ...
         ```
     - **Getting individual elements of the weather data**: Retrieves individual elements from the stored weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Example**:
         ```python
          # ...
          weather.get_queryCost()
          weather.get_tzoffset()
          weather.get_latitude()
          weather.get_longitude()
          weather.get_address()
          weather.get_timezone()
          weather.get_stations()
          # ...
         ```
     - **Getting individual elements from the daily weather data**: Retrieves individual elements from the daily weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Parameters**:
           - `day_info`(str|int): The identifier for the day, which can be a date string (YYYY-MM-DD) or an index of the day list.
           - `elements`(list, optional): Optional list of elements to include in the returned data for `get_data_on_day` method.
       - **Example**:
         ```python
          # ...
          weather.get_data_on_day('2024-01-02')

          weather.get_temp_on_day('2024-01-02')
          weather.get_feelslike_on_day(1)
          weather.get_humidity_on_day('2024-01-02')
          weather.get_dew_on_day('2024-01-02')
          weather.get_precip_on_day('2024-01-02')
          weather.get_windgust_on_day('2024-01-02')

          weather.get_data_on_day('2024-01-02', ['temp', 'feelslike', 'humidity', 'dew', 'precip', 'windgust'])
          # ...
         ```
     - **Getting individual elements from the hourly weather data**: Retrieves individual elements from the hourly weather data using the corresponding methods.
       - **Returns**:
         corresponding value of the element
       - **Parameters**:
           - `day_info` (str|int): A day identifier, which can be a date string (YYYY-MM-DD) or an index, pointing to a specific day in the data.
           - `time_info` (str|int): A time identifier, which can be a time string (HH:MM:SS) or an index, pointing to a specific time slot in the day's data.
           - `elements`(list, optional): Optional list of elements to include in the returned data for `get_data_at_datetime` method.
       - **Example**:
         ```python
          # ...
          weather.get_datetimeEpoch_at_datetime('2024-01-02','01:00:00')
          weather.get_temp_at_datetime('2024-01-02',1)
          weather.get_precip_at_datetime(1,'01:00:00')
          print(">>Weather data at a datetime: ", weather.get_data_at_datetime(1,1, ['temp', 'precip', 'humidity']))
          # ...
         ```
     - **Setting individual elements within the weather data**: Sets individual elements for the weather data using the corresponding methods. There are many predefined setters to set the elements of the weathe data in `Weather` class.
       - **Example**:
         ```python
          # ...

          weather.set_tzoffset(-3.0)
          print(">>changed tzoffset: ", weather.get_tzoffset())

          weather.set_tempmax_on_day('2024-01-02', 18)
          print(">>changed tempmax on a day: ", weather.get_tempmax_on_day(1))

          weather.set_data_at_datetime('2024-01-02', '01:00:00', {'temp': 25.0})
          print(">>Changed weather data at a datetime: ", weather.get_data_at_datetime('2024-01-02', '01:00:00'))

          weather.set_datetimeEpoch_at_datetime('2024-01-02', 1, '1111111111')
          print(">>changed datetimeEpoch at a datetime: ", weather.get_datetimeEpoch_at_datetime('2024-01-02', '01:00:00'))
         ```

#### 2. **Additional Functions**
   - **Description**: Make managing and processing the weatehr data more easier.
   - **Key functions**:
     - `update_dictionary`, `is_valid_dict`, `extract_subdict_by_keys`, etc.
   - **Example**:
     ```python
     original_dict = {'name': 'Alice', 'age': 30, 'location': 'New York', 'email': 'alice@example.com'}
     updates_dict = {'name': 'Alice Smith', 'age': 31, 'location': 'Los Angeles', 'email': 'alice.smith@example.com'}
     keys_to_exclude = ['email']

     update_dictionary(original_dict, updates_dict, keys_to_exclude)
     print(original_dict)
     ```


### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Library effectively. By following the examples and using the described methods, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.