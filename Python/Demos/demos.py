import sys
import os

# Get the parent directory and add it to sys.path
current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(current_dir)
sys.path.append(parent_dir)

from Library.weather import Weather


weather = Weather(api_key='3KAJKHWT3UEMRQWF2ABKVVVZE')
    
# fetch from the Visual Crossing API
weather.fetch_weather_data("38.95,-95.664", "2023-01-01", '2023-01-02', include='hours')


# using the method [get_weather_data] of the class to get the weather data
print(">>Result: ", weather.get_weather_data(['timezone']))

# using the method [get_tzoffset] and [set_tzoffset] of the class to set the `tzoffset`
weather.set_tzoffset(-3.0)
print(">>changed tzoffset: ", weather.get_tzoffset())

# using the method [get_weather_hourly_data] of the class to get the daily  data
print(">>Daily Data:", weather.get_weather_daily_data())
print(">>Daily Data with some elements:", weather.get_weather_daily_data(['temp', 'precip']))

# using the method [get_weather_hourly_data] of the class to get the hourly data
# print(">>Hourly Data:", weather.get_weather_hourly_data())
print(">>Hourly Data with some elements:", weather.get_weather_hourly_data(['temp', 'precip']))

# using the method [get_daily_datetimes] of the class to get datetimes of the daily data
print(">>Daily datetimes: ", weather.get_daily_datetimes())

# using the method [get_hourly_datetimes] of the class to get datetimes of the daily data
# print(">>Hourly datetimes: ", weather.get_hourly_datetimes())

# using the method [get_data_on_day] of the class to get data of the specific day within `days` key
print(">>Weather data with some elements on a day: ", weather.get_data_on_day('2023-01-02', ['temp', 'humidity', 'dew']))

# using the method [get_hourlyData_on_day] of the class to get hourly data of the specific day within `days` key
print(">>Hourly data with some elements on a day: ", weather.get_hourlyData_on_day('2023-01-02', ['temp', 'humidity']))

# using the method [get_tempmax_on_day] of the class to get tempmax of the specific day within `days` key
# print(">>tempmax on a day: ", weather.get_tempmax_on_day(1))
# print(">>tempmax on a day: ", weather.get_tempmax_on_day('2023-01-02'))

# using the method [set_tempmax_on_day] of the class to get tempmax of the specific day within `days` key
weather.set_tempmax_on_day('2023-01-02', 18)
print(">>changed tempmax on a day: ", weather.get_tempmax_on_day(1))

# using the method [get_snowdepth_on_day] and [set_snowdepth_on_day] of the class to get and set snowdepth of the specific day within `days` key for daily data
print(">>snowdepth on a day: ", weather.get_snowdepth_on_day(1))
weather.set_snowdepth_on_day('2023-01-02', 1)
print(">>changed snowdepth on a day: ", weather.get_snowdepth_on_day(1))


# using the method [get_data_at_datetime] and [set_data_at_datetime] of the class to get and set data of the specific date and time within `hours` key for hourly data
print(">>Weather data with some elements at a datetime: ", weather.get_data_at_datetime(1,1, ['temp', 'precip', 'humidity']))
weather.set_data_at_datetime('2023-01-02', '01:00:00', {'temp': 25.0})
print(">>Changed weather data at a datetime: ", weather.get_data_at_datetime('2023-01-02', '01:00:00'))

# using the method [get_datetimeEpoch_at_datetime] and [set_datetimeEpoch_at_datetime] of the class to get and set datetimeEpoch of the specific date and time within `hours` key for hourly data
print(">>datetimeEpoch at a datetime: ", weather.get_datetimeEpoch_at_datetime(1,1))
weather.set_datetimeEpoch_at_datetime('2023-01-02', 1, '1111111111')
print(">>changed datetimeEpoch at a datetime: ", weather.get_datetimeEpoch_at_datetime('2023-01-02', '01:00:00'))

# using the method [get_stations_at_datetime] of the class to get and set datetimeEpoch of the specific date and time within `hours` key for hourly data
print(">>stations at a datetime: ", weather.get_stations_at_datetime(1,1))
