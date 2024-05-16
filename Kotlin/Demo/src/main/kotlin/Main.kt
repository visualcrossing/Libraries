import java.util.function.Consumer

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
fun main() {

    // create weather API object with API key
    val weatherData = WeatherData("YOUR_API_KEY")


    // fetch weather data with location, from date, to date params.
    weatherData.fetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "")


    // get daily weather data array list
    val weatherDailyData: ArrayList<WeatherDailyData>? = weatherData.weatherDailyData

    if (weatherDailyData != null) {
        for (dailyData in weatherDailyData) {
            // print max temperature
            println(dailyData.datetime.toString() + "," + dailyData.tempmax)

            // print min temperature
            println(dailyData.datetime.toString() + "," + dailyData.tempmin)

            // print humidity
            println(dailyData.datetime.toString() + "," + dailyData.humidity)

            // get hourly weather data array list
            val weatherHourlyData: ArrayList<WeatherHourlyData>? = dailyData.weatherHourlyData
            if (weatherHourlyData != null) {
                for (hourlyData in weatherHourlyData) {
                    // print temperature
                    println(hourlyData.datetime.toString() + "," + hourlyData.temp)

                    // print humidity
                    println(hourlyData.datetime.toString() + "," + hourlyData.humidity)
                }
            }

            val events = dailyData.events
            if (events != null) {
                for (event in events) {
                    println(event.datetime.toString() + "," + event.datetimeEpoch)
                }
            }
        }
    }

    val stationHashMap = weatherData.stations
    stationHashMap.keys.forEach(Consumer { key: String ->
        val station = stationHashMap[key]
        println(key)
        println(station!!.name)
        println(station!!.distance)
        println(station!!.distance)
    })


    // set API_KEY
    weatherData.API_KEY = ("YOUR_API_KEY")


    // fetch weather data for a specific datetime
    weatherData.fetchWeatherData("K2A1W1", "2021-10-19")


    // get daily weather data object
    val weatherDailyData1: ArrayList<WeatherDailyData>? = weatherData.weatherDailyData

    if (weatherDailyData1 != null) {
        for (dailyData in weatherDailyData1) {
            // print temperature
            println(dailyData.datetime.toString() + "," + dailyData.tempmax)
        }
    }


    // fetch forecast (15 days) weather data for the location
    weatherData.fetchForecastData("K2A1W1")


    // get daily weather data array list
    val weatherDailyData2: ArrayList<WeatherDailyData>? = weatherData.weatherDailyData

    if (weatherDailyData2 != null) {
        for (dailyData in weatherDailyData2) {
            // print temperature
            println(dailyData.datetime.toString() + "," + dailyData.tempmax)
        }
    }

    val weatherData1 = WeatherData()
    weatherData1.API_KEY = ("YOUR_API_KEY")
}