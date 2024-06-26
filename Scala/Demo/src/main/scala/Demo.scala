import scala.collection.mutable.{ArrayBuffer, HashMap}

// TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
object Demo extends App {
  // create weather API object with API key
  val weatherData = WeatherData("YOUR_API_KEY")

  // fetch weather data with location, from date, to date params.
  weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events,hours", "")

  // get daily weather data array list
  val weatherDailyData: ArrayBuffer[WeatherDailyData] = weatherData.getWeatherDailyData

  if (weatherDailyData != null) {
    for (dailyData <- weatherDailyData) {
      // print max temperature
      println(s"${dailyData.datetime.get}, ${dailyData.tempmax.get}")

      // print min temperature
      println(s"${dailyData.datetime.get}, ${dailyData.tempmax.get}")

      // print humidity
      println(s"${dailyData.datetime.get}, ${dailyData.humidity.get}")

      // get hourly weather data array list
      val weatherHourlyData: Option[ArrayBuffer[WeatherHourlyData]] = dailyData.weatherHourlyData
      weatherHourlyData.foreach { hourlyDataArray =>
        for (hourlyData <- hourlyDataArray) {
          // print temperature
          println(s"${hourlyData.datetime.get}, ${hourlyData.temp.get}")

          // print humidity
          println(s"${hourlyData.datetime.get}, ${hourlyData.humidity.get}")
        }
      }

      val events: Option[ArrayBuffer[Event]] = dailyData.events
      events.foreach { eventArray =>
        for (event <- eventArray) {
          println(s"${event.datetime.get}, ${event.datetimeEpoch.get}")
        }
      }

      val stationHashMap: HashMap[String, Station] = weatherData.getStations

    }
  }

  val stationHashMap: HashMap[String, Station] = weatherData.getStations
  stationHashMap.keys.foreach { key =>
    val station = stationHashMap(key)
    println(key)
    println(station.name.get)
    println(station.distance.get)
    println(station.id.get)
  }

  // set API_KEY
  weatherData.API_KEY = "YOUR_API_KEY"

  // fetch weather data for a specific datetime
  weatherData.fetchWeatherData("K2A1W1", "2021-10-19")

  // get daily weather data object
  val weatherDailyData1: ArrayBuffer[WeatherDailyData] = weatherData.getWeatherDailyData

  if (weatherDailyData1 != null) {
    for (dailyData <- weatherDailyData1) {
      // print temperature
      println(s"${dailyData.datetime.get}, ${dailyData.tempmax.get}")
    }
  }

  // fetch forecast (15 days) weather data for the location
  weatherData.fetchForecastData("K2A1W1")

  // get daily weather data array list
  val weatherDailyData2: ArrayBuffer[WeatherDailyData] = weatherData.getWeatherDailyData

  if (weatherDailyData2 != null) {
    for (dailyData <- weatherDailyData2) {
      // print temperature
      println(s"${dailyData.datetime.get}, ${dailyData.tempmax.get}")
    }
  }

  val weatherData1 = WeatherData()
  weatherData1.API_KEY = "YOUR_API_KEY"
}
