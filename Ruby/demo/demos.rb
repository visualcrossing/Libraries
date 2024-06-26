#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/weather_visual'
require 'json'

# Initialize the WeatherVisual object with your API key
api_key = 'YOUR_API_KEY'
weather = WeatherVisual::WeatherData.new(api_key)

# Fetch weather data for a specific location and date range
location = 'New York, NY'
from_date = '2024-01-01'
to_date = '2024-01-07'

puts "Fetching weather data for #{location} from #{from_date} to #{to_date}..."
data = weather.fetch_weather_data(location, from_date, to_date, 'us', 'hours')
puts "Fetched weather data successfully."

# Set the fetched weather data
weather.set_weather_data(data)

# Retrieve and display daily weather data
daily_data = weather.get_weather_daily_data
puts "Daily Weather Data:"
puts JSON.pretty_generate(daily_data)

# Retrieve and display hourly weather data
hourly_data = weather.get_weather_hourly_data
puts "Hourly Weather Data:"
puts JSON.pretty_generate(hourly_data)

# Get and set query cost
puts "Query cost: #{weather.get_query_cost}"
weather.set_query_cost(0.8)
puts "Updated query cost: #{weather.get_query_cost}"

# --- Get and set specific weather parameters for a specific day ---
# Get daily data for a specific day
puts "Daily data on a day: #{weather.get_data_on_day('2024-01-02')}"

# Get specific element on a given day
puts "Humidity on 2024-01-02: #{weather.get_data_on_day('2024-01-02', ['humidity'])}"

# Set specific element on a given day
weather.set_humidity_on_day('2024-01-02', 65)
puts "Updated humidity on 2024-01-02: #{weather.get_humidity_on_day('2024-01-02')}"


# --- Get and set specific weather parameters for a specific day and time ---
day_index = 0   # First day in the data
hour_index = 0  # First hour in the data

# Get temperature at a specific datetime
puts "Temperature at datetime: #{weather.get_temp_at_datetime('2024-01-02', '00:00:00')}"

# Set temperature at a specific datetime
weather.set_temp_at_datetime('2024-01-02', '00:00:00', 72.0)
puts "Updated Temperature at datetime: #{weather.get_temp_at_datetime('2024-01-02', '00:00:00')}"

# Retrieve temperature at a specific datetime
temp = weather.get_temp_at_datetime(day_index, hour_index)
puts "Temperature at datetime: #{temp}"

# Set new temperature at a specific datetime
weather.set_temp_at_datetime(day_index, hour_index, 25)
puts "Set new temperature at datetime successfully."

# Retrieve and display updated temperature at a specific datetime
temp = weather.get_temp_at_datetime(day_index, hour_index)
puts "Updated Temperature at datetime: #{temp}"

# --- Clear weather data
weather.clear_weather_data
puts "Cleared weather data."

# Verify weather data is cleared
cleared_data = weather.get_weather_data
puts "Cleared Weather Data:"
puts JSON.pretty_generate(cleared_data)

puts "Demo script completed successfully."
