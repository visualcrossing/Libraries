# demo/weather_demo.R

# Load the package
library(weatherVisual)

# Create a new instance of the WeatherData class
weather_data <- WeatherData$new()

# Set some weather data for demonstration purposes
weather_data$set_timezone("America/New_York")
weather_data$set_tzoffset(-5)
weather_data$set_stations(list("Station1", "Station2"))

# Print the current timezone
cat("Timezone:", weather_data$get_timezone(), "\n")

# Print the timezone offset
cat("Timezone Offset:", weather_data$get_tzoffset(), "\n")

# Print the list of stations
cat("Stations:", weather_data$get_stations(), "\n")

# Assuming your weather data includes some daily data
weather_data$weather_data$days <- list(
  list(datetime = "2023-05-20", temp = 20, tempmax = 25, tempmin = 15, hours = list()),
  list(datetime = "2023-05-21", temp = 22, tempmax = 27, tempmin = 17, hours = list())
)

# Retrieve and print daily datetimes
daily_datetimes <- weather_data$get_daily_datetimes()
cat("Daily Datetimes:", daily_datetimes, "\n")

# Retrieve and print temperature on a specific day
temp_on_day <- weather_data$get_temp_on_day("2023-05-20")
cat("Temperature on 2023-05-20:", temp_on_day, "\n")

# Set a new temperature for a specific day
weather_data$set_temp_on_day("2023-05-20", 21)
new_temp_on_day <- weather_data$get_temp_on_day("2023-05-20")
cat("New Temperature on 2023-05-20:", new_temp_on_day, "\n")
