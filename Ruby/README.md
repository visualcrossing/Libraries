# WeatherVisual

## Description

`WeatherVisual` is a Ruby module for fetching and processing weather data from the Visual Crossing Weather API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'weather_visual'
```

And then execute:

``` sh
bundle install
```

## Usage

### Initialization

```ruby
require 'weather_visual'

api_key = 'YOUR_API_KEY_HERE'
weather = WeatherVisual::WeatherData.new(api_key)
```

### Fetch Weather Data

```ruby
location = 'New York, NY'
from_date = '2023-01-01'
to_date = '2023-01-07'
data = weather.fetch_weather_data(location, from_date, to_date, 'us', 'hours', ['temp', 'humidity'])
```

### Get and Set Weather Data

```ruby
weather.set_weather_data(data)
retrieved_data = weather.get_weather_data
```

### Get Daily and Hourly Weather Data
```ruby
daily_data = weather.get_weather_daily_data
hourly_data = weather.get_weather_hourly_data
```

### Get and Set Specific Data
```ruby
day_index = 0
hour_index = 0
weather.set_temp_at_datetime(day_index, hour_index, 25)
temp = weather.get_temp_at_datetime(day_index, hour_index)
```

### Clear Weather Data
```ruby
weather.clear_weather_data
cleared_data = weather.get_weather_data
```