import org.json.JSONObject
import org.json.JSONArray
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import java.util.HashMap

/**
* The WeatherData class is designed to interact with the Visual Crossing Weather API to fetch weather data for specific locations, dates, and times.
* This class is equipped to handle various types of weather data requests, including current weather data, historical weather data, and weather forecasts.
* The key methodalities of this class include constructing API requests, retrieving weather data, and parsing JSON responses to populate weather data models.
* API_KEY: A private string variable that stores the API key required to authenticate requests to the Visual Crossing Weather API.
* setAPI_KEY(String API_KEY) and getAPI_KEY(): Getters and setters for the API key, allowing it to be updated or retrieved after the instance has been created.
* fetchWeatherData(String location, String from, String to): Public method to fetch weather data between specific dates for a given location. This is particularly useful for retrieving historical weather data or future forecasts within a defined range.
* fetchWeatherData(String location, String datetime): Overloaded method to fetch weather data for a specific date and location. This is useful for getting precise weather conditions on particular days.
* fetchForecastData(String location): Fetches the weather forecast for the next 15 days starting from midnight of the current day at the specified location. This method is ideal for applications requiring future weather predictions to plan activities or events.
* fetchWeatherData(String location, String from, String to, String UnitGroup, String include, String elements)
*/

class WeatherData(var apiKey: String = "") {
    companion object {
        const val BASE_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"
    }

    var API_KEY: String? = null
        get() = field
        set(value) {
            field = value
        }

    var queryCost: Long? = null
        get() = field
        set(value) {
            field = value
        }

    var latitude: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var longitude: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var resolvedAddress: String? = null
        get() = field
        set(value) {
            field = value
        }

    var address: String? = null
        get() = field
        set(value) {
            field = value
        }

    var timezone: String? = null
        get() = field
        set(value) {
            field = value
        }

    var tzoffset: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var weatherDailyData: ArrayList<WeatherDailyData>? = ArrayList()
        get() = field
        set(value) {
            field = value
        }

    var stations: HashMap<String, Station> = hashMapOf()
        get() = field
        set(value) {
            field = value
        }

    /**
     * The fetchData method retrieves weather data by making an API request to the specified URL using the weather data API.
     * @param URL
     * @return
     */
    private fun fetchData(url: String): String {
        val connection = URL(url).openConnection() as HttpURLConnection
        connection.requestMethod = "GET"
        connection.setRequestProperty("Authorization", "Bearer $apiKey")

        val responseCode = connection.responseCode
        if (responseCode != HttpURLConnection.HTTP_OK) {
            throw IOException("HTTP error code: $responseCode")
        }

        BufferedReader(InputStreamReader(connection.inputStream)).use { reader ->
            val response = reader.readText()
            if (response.isEmpty()) throw IOException("Can't fetch weather data")
            return response
        }.also {
            connection.disconnect()
        }
    }

    private fun clearWeatherData() {
        weatherDailyData?.forEach { day ->
            day.weatherHourlyData?.clear()
            day.events?.clear()
        }
        weatherDailyData?.clear()
        stations?.clear()
    }

    /**
     * The handleWeatherDate method parse JSON structure from String.
     * @param jsonString
     */
    private fun handleWeatherData(jsonString: String) {
        clearWeatherData()
        val obj = JSONObject(jsonString)
        queryCost = obj.getLong("queryCost")
        latitude = obj.getDouble("latitude")
        longitude = obj.getDouble("longitude")
        resolvedAddress = obj.getString("resolvedAddress")
        address = obj.getString("address")
        timezone = obj.getString("timezone")
        tzoffset = obj.getDouble("tzoffset")

        val days = obj.getJSONArray("days")
        for (i in 0 until days.length()) {
            val day = days.getJSONObject(i)
            val weatherDayData = createWeatherDailyData(day)
            weatherDailyData?.add(weatherDayData)
        }

        val stationsObj = obj.getJSONObject("stations")
        stationsObj.keys().forEach { key ->
            val stationObj = stationsObj.getJSONObject(key)
            val station = Station()
            station.distance = getDoubleOrNull(stationObj,"distance")
            station.latitude = getDoubleOrNull(stationObj,"latitude")
            station.longitude = getDoubleOrNull(stationObj,"longitude")
            station.useCount = getIntOrNull(stationObj,"useCount")
            station.id = getStringOrNull(stationObj,"id")
            station.name = getStringOrNull(stationObj,"name")
            station.quality = getIntOrNull(stationObj,"quality")
            station.contribution = getDoubleOrNull(stationObj,"contribution")

            stations[key] = station
        }
    }

    /**
     * The fetchWeatherData method will fetch weather data from params.
     * @param location
     * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
     * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
     * consider our Multiple Location Timeline Weather API.
     * @param from
     * from param is the start date for which to retrieve weather data. Dates should be in the format yyyy-MM-dd.
     * For example 2020-10-19 for October 19th, 2020 or 2017-02-03 for February 3rd, 2017.
     * @param to
     * to param is the end date for which to retrieve weather data.
     * All dates and times are in local time of the specified location and should be in the format yyyy-MM-dd.
     * @param UnitGroup
     * The system of units used for the output data.
     * Supported values are us, uk, metric, base. See Unit groups and measurement units for more information. Defaults to US system of units.
     * @param include
     * Specifies the sections you would like to include in the result data. This allows you to reduce query cost and latency. Specify this as a comma separated list. For example: &include=obs,fcst to include the historical observations and forecast data. The options are:
     *  - days – daily data
     *  - hours – hourly data
     *  - alerts – weather alerts
     *  - current – current conditions or conditions at requested time.
     *  - events – historical events such as a hail, tornadoes, wind damage and earthquakes (not enabled by default)
     *  - obs – historical observations from weather stations
     *  - remote – historical observations from remote source such as satellite or radar
     *  - fcst – forecast based on 16 day models.
     *  - stats – historical statistical normals and daily statistical forecast
     *  - statsfcst – use the full statistical forecast information for dates in the future beyond the current model forecast. Permits hourly statistical forecast.
     * @param elements
     * Specifies the specific weather elements you would like to include in the response as a comma separated list.
     * For example &elements=tempmax,tempmin,temp will request the only the tempmax, tempmin and temp response elements.
     * For the full list of available elements, see the response below.
     */
    fun fetchWeatherData(location: String, from: String, to: String, unitGroup: String = "us", include: String = "days", elements: String = "all") {
        try {
            val urlString = "$BASE_URL$location/$from/$to?key=$apiKey&include=$include&elements=$elements&unitGroup=$unitGroup"
            val jsonString = fetchData(urlString)
            handleWeatherData(jsonString)
        }catch (e: Exception) {
            e.printStackTrace()
        }
    }

    /**
     * The fetchWeatherData method will fetch weather data from first date to second date.
     * @param location : String
     * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
     * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
     * consider our Multiple Location Timeline Weather API.
     * @param from     : String
     * from param is the start date for which to retrieve weather data. Dates should be in the format yyyy-MM-dd.
     * For example 2020-10-19 for October 19th, 2020 or 2017-02-03 for February 3rd, 2017.
     * @param to       : String
     * to param is the end date for which to retrieve weather data.
     * All dates and times are in local time of the specified location and should be in the format yyyy-MM-dd.
     */
    fun fetchWeatherData(location: String, from: String, to:String) {
        try {
            val urlString = "$BASE_URL$location/$from/$to?key=$apiKey"
            val jsonString = fetchData(urlString)
            handleWeatherData(jsonString)
        }catch (e: Exception) {
            e.printStackTrace()
        }
    }

    /**
     * The fetchWeatherData method will fetch weather data for a specific datetime.
     * @param location : String
     * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
     * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
     * consider our Multiple Location Timeline Weather API.
     * @param datetime : String
     * datetime param is the specific date for which to retrieve weather data.
     * All dates and times are in local time of the specified location and should be in the format yyyy-MM-dd.
     */
    fun fetchWeatherData(location: String, datetime: String) {
        try {
            val urlString = "$BASE_URL$location/$datetime?key=$apiKey"
            val jsonString = fetchData(urlString)
            handleWeatherData(jsonString)
        }catch (e: Exception) {
            e.printStackTrace()
        }
    }

    /**
     * The fetchForecastData method will fetch the weather forecast for location for the next 15 days
     * starting at midnight at the start of the current day (local time of the requested location).
     * @param location: String
     * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
     * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
     * consider our Multiple Location Timeline Weather API.
     */
    fun fetchForecastData(location: String) {
        try {
            val urlString = "$BASE_URL$location?key=$apiKey"
            val jsonString = fetchData(urlString)
            handleWeatherData(jsonString)
        }catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun getDoubleOrNull(obj: JSONObject, key: String): Double? = if (obj.isNull(key)) null else obj.getDouble(key)
    private fun getIntOrNull(obj: JSONObject, key: String): Int? = if (obj.isNull(key)) null else obj.getInt(key)
    private fun getStringOrNull(obj: JSONObject, key: String): String? = if (obj.isNull(key)) null else obj.getString(key)
    private fun getLongOrNull(obj: JSONObject, key: String): Long? = if (obj.isNull(key)) null else obj.getLong(key)

    /**
     * The createWeatherDailyData method creates an hourly data object from a JSON object.
     * The method checks if a key in the JSON object is null and sets the corresponding property to null if it is.
     * Otherwise, it assigns the value from the JSON object to the property.
     */
    private fun createWeatherDailyData(day: JSONObject): WeatherDailyData {
        val weatherDailyData = WeatherDailyData()

        // Access fields within each 'day' object
        weatherDailyData.datetime = LocalDate.parse(getStringOrNull(day, "datetime"))
        weatherDailyData.datetimeEpoch = getLongOrNull(day, "datetimeEpoch")
        weatherDailyData.tempmax = getDoubleOrNull(day, "tempmax")
        weatherDailyData.tempmin = getDoubleOrNull(day, "tempmin")
        weatherDailyData.temp = getDoubleOrNull(day, "temp")
        weatherDailyData.feelslikemax = getDoubleOrNull(day, "feelslikemax")
        weatherDailyData.feelslikemin = getDoubleOrNull(day, "feelslikemin")
        weatherDailyData.feelslike = getDoubleOrNull(day, "feelslike")
        weatherDailyData.dew = getDoubleOrNull(day, "dew")
        weatherDailyData.humidity = getDoubleOrNull(day, "humidity")
        weatherDailyData.precip = getDoubleOrNull(day, "precip")
        weatherDailyData.precipprob = getDoubleOrNull(day, "precipprob")
        weatherDailyData.precipcover = getDoubleOrNull(day, "precipcover")

        if (day.isNull("preciptype"))
            weatherDailyData.preciptype = null
        else {
            val precipTypes = day.getJSONArray("preciptype")
            val typeList = ArrayList<String>()
            for (j in 0 until precipTypes.length()) {
                typeList.add(precipTypes.getString(j))
            }
            weatherDailyData.preciptype = typeList
        }

        weatherDailyData.snow = getDoubleOrNull(day, "snow")
        weatherDailyData.snowdepth = getDoubleOrNull(day, "snowdepth")
        weatherDailyData.windgust = getDoubleOrNull(day, "windgust")
        weatherDailyData.windspeed = getDoubleOrNull(day, "windspeed")
        weatherDailyData.winddir = getDoubleOrNull(day, "winddir")
        weatherDailyData.pressure = getDoubleOrNull(day, "pressure")
        weatherDailyData.cloudcover = getDoubleOrNull(day, "cloudcover")
        weatherDailyData.visibility = getDoubleOrNull(day, "visibility")
        weatherDailyData.solarradiation = getDoubleOrNull(day, "solarradiation")
        weatherDailyData.solarenergy = getDoubleOrNull(day, "solarenergy")
        weatherDailyData.uvindex = getDoubleOrNull(day, "uvindex")
        weatherDailyData.sunrise = getStringOrNull(day, "sunrise")
        weatherDailyData.sunriseEpoch = getLongOrNull(day, "sunriseEpoch")
        weatherDailyData.sunset = getStringOrNull(day, "sunset")
        weatherDailyData.sunsetEpoch = getLongOrNull(day, "sunsetEpoch")
        weatherDailyData.moonphase = getDoubleOrNull(day, "moonphase")
        weatherDailyData.conditions = getStringOrNull(day, "conditions")
        weatherDailyData.description = getStringOrNull(day, "description")
        weatherDailyData.icon = getStringOrNull(day, "icon")

        if (day.isNull("stations"))
            weatherDailyData.stations = null
        else {
            val stations = day.getJSONArray("stations")
            val stationList = ArrayList<String>()
            for (j in 0 until stations.length()) {
                stationList.add(stations.getString(j))
            }
            weatherDailyData.stations = stationList
        }

        if (day.isNull("events"))
            weatherDailyData.events = null
        else {
            val events = day.getJSONArray("events")
            val eventList = ArrayList<Event>()

            for (j in 0 until events.length()) {
                val event = events.getJSONObject(j)
                val eventObj = Event()
                eventObj.datetime = LocalDateTime.parse(getStringOrNull(event, "datetime"))
                eventObj.datetimeEpoch = getLongOrNull(event, "datetimeEpoch")
                eventObj.type = getStringOrNull(event, "type")
                eventObj.latitude = getDoubleOrNull(event, "latitude")
                eventObj.longitude = getDoubleOrNull(event, "longitude")
                eventObj.distance = getDoubleOrNull(event, "distance")
                eventObj.description = getStringOrNull(event, "description")
                eventObj.size = getDoubleOrNull(event, "size")

                eventList.add(eventObj)
            }
            weatherDailyData.events = eventList
        }

        weatherDailyData.source = getStringOrNull(day, "source")

        if (!day.isNull("hours")) {
            val hours = day.getJSONArray("hours")
            val hourlyDataList = ArrayList<WeatherHourlyData>()
            for (j in 0 until hours.length()) {
                val hour = hours.getJSONObject(j)
                val weatherHourlyData = createHourlyData(hour)
                hourlyDataList.add(weatherHourlyData)
            }
            weatherDailyData.weatherHourlyData = hourlyDataList
        }
        return weatherDailyData
    }

    /**
     * The createHourlyData method creates an hourly data object from a JSON object.
     * The method checks if a key in the JSON object is null and sets the corresponding property to null if it is.
     * Otherwise, it assigns the value from the JSON object to the property.
     */
    private fun createHourlyData(hour: JSONObject): WeatherHourlyData {
        val weatherHourlyData = WeatherHourlyData()

        if (getStringOrNull(hour, "datetime") == null)
            weatherHourlyData.datetime = null
        else
            weatherHourlyData.datetime = (LocalTime.parse(getStringOrNull(hour, "datetime")))
        weatherHourlyData.datetimeEpoch = getLongOrNull(hour, "datetimeEpoch")
        weatherHourlyData.temp = getDoubleOrNull(hour, "temp")
        weatherHourlyData.feelslike = getDoubleOrNull(hour, "feelslike")
        weatherHourlyData.humidity = getDoubleOrNull(hour, "humidity")
        weatherHourlyData.dew = getDoubleOrNull(hour, "dew")
        weatherHourlyData.precip = getDoubleOrNull(hour, "precip")
        weatherHourlyData.precipProb = getDoubleOrNull(hour, "precipprob")
        weatherHourlyData.snow = getDoubleOrNull(hour, "snow")
        weatherHourlyData.snowDepth = getDoubleOrNull(hour, "snowdepth")

        if (hour.isNull("preciptype")) {
            weatherHourlyData.precipType = null
        } else {
            val precipTypes = hour.getJSONArray("preciptype")
            val typeList = ArrayList<String>()
            for (k in 0 until precipTypes.length()) {
                typeList.add(precipTypes.getString(k))
            }
            weatherHourlyData.precipType = typeList
        }

        weatherHourlyData.windGust = getDoubleOrNull(hour, "windgust")
        weatherHourlyData.windSpeed = getDoubleOrNull(hour, "windspeed")
        weatherHourlyData.windDir = getDoubleOrNull(hour, "winddir")
        weatherHourlyData.pressure = getDoubleOrNull(hour, "pressure")
        weatherHourlyData.visibility = getDoubleOrNull(hour, "visibility")
        weatherHourlyData.cloudCover = getDoubleOrNull(hour, "cloudcover")
        weatherHourlyData.solarRadiation = getDoubleOrNull(hour, "solarradiation")
        weatherHourlyData.solarEnergy = getDoubleOrNull(hour, "solarenergy")
        weatherHourlyData.uvIndex = getDoubleOrNull(hour, "uvindex")
        weatherHourlyData.conditions = getStringOrNull(hour, "conditions")
        weatherHourlyData.icon = getStringOrNull(hour, "icon")

        if (hour.isNull("stations")) {
            weatherHourlyData.stations = null
        } else {
            val stations = hour.getJSONArray("stations")
            val stationList = ArrayList<String>()
            for (k in 0 until stations.length()) {
                stationList.add(stations.getString(k))
            }
            weatherHourlyData.stations = stationList
        }

        weatherHourlyData.source = getStringOrNull(hour, "source")

        return weatherHourlyData
    }
}
