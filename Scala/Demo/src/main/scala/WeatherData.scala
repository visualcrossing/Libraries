import java.io.{BufferedReader, IOException, InputStreamReader}
import java.net.{HttpURLConnection, URL}
import scala.collection.mutable
import scala.collection.mutable.ArrayBuffer
import org.json4s.*
import org.json4s.native.JsonMethods.*
import org.json4s.native.Serialization

import java.time.{LocalDate, LocalDateTime}

/**
 * The WeatherData class is designed to interact with the Visual Crossing Weather API to fetch weather data for specific locations, dates, and times.
 * This class is equipped to handle various types of weather data requests, including current weather data, historical weather data, and weather forecasts.
 * The key methodalities of this class include constructing API requests, retrieving weather data, and parsing JSON responses to populate weather data models.
 * API_KEY: A private string variable that stores the API key required to authenticate requests to the Visual Crossing Weather API.
 * setAPI_KEY(String API_KEY) and getAPI_KEY(): Getters and setters for the API key, allowing it to be updated or retrieved after the instance has been created.
 * fetchWeatherData(location: String, from: String, to: String): Public method to fetch weather data between specific dates for a given location. This is particularly useful for retrieving historical weather data or future forecasts within a defined range.
 * fetchWeatherData(location: String, datetime: String): Overloaded method to fetch weather data for a specific date and location. This is useful for getting precise weather conditions on particular days.
 * fetchForecastData(location: String): Fetches the weather forecast for the next 15 days starting from midnight of the current day at the specified location. This method is ideal for applications requiring future weather predictions to plan activities or events.
 * fetchWeatherData(location: String, from: String, to: String, UnitGroup: String, include: String, elements: String)
 */

case class WeatherData(private var _API_KEY: String = "") {

  implicit val formats: Formats = DefaultFormats

  val BASE_URL: String = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"

  private var queryCost: Option[Long] = None
  private var latitude: Option[Double] = None
  private var longitude: Option[Double] = None
  private var resolvedAddress: Option[String] = None
  private var address: Option[String] = None
  private var timezone: Option[String] = None
  private var tzoffset: Option[Double] = None
  private var weatherDailyData: ArrayBuffer[WeatherDailyData] = ArrayBuffer()
  private var stations: mutable.HashMap[String, Station] = mutable.HashMap()

  def API_KEY: String = _API_KEY
  def API_KEY_=(key: String): Unit = _API_KEY = key

  /**
   * The fetchData method retrieves weather data by making an API request to the specified URL using the weather data API.
   *
   * @param URL
   * @return
   */
  @throws[IOException]
  private def fetchData(url: String): String = {
    var connection: HttpURLConnection = null
    try {
      val urlObj = new URL(url)
      connection = urlObj.openConnection().asInstanceOf[HttpURLConnection]
      connection.setRequestMethod("GET")
      connection.setRequestProperty("Authorization", "Bearer your_api_token_here")

      val responseCode = connection.getResponseCode
      if (responseCode != HttpURLConnection.HTTP_OK) throw new IOException("HTTP error code: " + responseCode)

      val in = new BufferedReader(new InputStreamReader(connection.getInputStream))
      val response = new StringBuilder
      var inputLine: String = null

      while ({ inputLine = in.readLine(); inputLine != null }) {
        response.append(inputLine)
      }

      if (response.toString == null) throw new IOException("Can't fetch weather data")
      response.toString
    } finally {
      if (connection != null) connection.disconnect()
    }
  }

  private def handleWeatherDate(jsonString: String): Unit = {

    try {
      val obj = parse(jsonString)

      setQueryCost((obj \ "queryCost").extractOpt[Long])
      setLatitude((obj \ "latitude").extractOpt[Double])
      setLongitude((obj \ "longitude").extractOpt[Double])
      setResolvedAddress((obj \ "resolvedAddress").extractOpt[String])
      setAddress((obj \ "address").extractOpt[String])
      setTimezone((obj \ "timezone").extractOpt[String])
      setTzoffset((obj \ "tzoffset").extractOpt[Double])
      setWeatherDailyData(ArrayBuffer())
      val days = (obj \ "days").extract[Array[JValue]]

      for (day <- days) {
        val weatherDayData = createWeatherDailyData(day)
        getWeatherDailyData += weatherDayData
      }

      val stations = (obj \ "stations").extract[Map[String, JValue]]

      this.stations = mutable.HashMap()
      for ((key, stationObj) <- stations) {
        val station = Station()

        station.distance = (stationObj \ "distance").extractOpt[Double]
        station.latitude = (stationObj \ "latitude").extractOpt[Double]
        station.longitude = (stationObj \ "longitude").extractOpt[Double]
        station.useCount = (stationObj \ "useCount").extractOpt[Int]
        station.id = (stationObj \ "id").extractOpt[String]
        station.name = (stationObj \ "name").extractOpt[String]
        station.quality = (stationObj \ "quality").extractOpt[Int]
        station.contribution = (stationObj \ "contribution").extractOpt[Double]

        this.stations.put(key, station)
      }
    } catch {
      case e: Exception => e.printStackTrace()
    }
  }

  /**
   * The fetchWeatherData method will fetch weather data from params.
   *
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
  def fetchWeatherData(location: String, from: String, to: String, UnitGroup: String, include: String, elements: String): Unit = {
    try {
      if (API_KEY == null || API_KEY.isEmpty) throw new Exception()

      val urlString = s"$BASE_URL$location/$from/$to?key=$API_KEY&include=$include&elements=$elements&unitGroup=$UnitGroup"
      val jsonString = fetchData(urlString)
      handleWeatherDate(jsonString)
    } catch {
      case e: Exception => e.printStackTrace()
    }
  }

  /**
   * The fetchWeatherData method will fetch weather data from first date to second date.
   *
   * @param location : String
   *                 location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
   *                 You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
   *                 consider our Multiple Location Timeline Weather API.
   * @param from     : String
   *                 from param is the start date for which to retrieve weather data. Dates should be in the format yyyy-MM-dd.
   *                 For example 2020-10-19 for October 19th, 2020 or 2017-02-03 for February 3rd, 2017.
   * @param to       : String
   *                 to param is the end date for which to retrieve weather data.
   *                 All dates and times are in local time of the specified location and should be in the format yyyy-MM-dd.
   */
  def fetchWeatherData(location: String, from: String, to: String): Unit = {
    try {
      if (API_KEY == null || API_KEY.isEmpty) throw new Exception()

      val urlString = s"$BASE_URL$location/$from/$to?key=$API_KEY"
      val jsonString = fetchData(urlString)
      handleWeatherDate(jsonString)
    } catch {
      case e: Exception => e.printStackTrace()
    }
  }

  /**
   * The fetchWeatherData method will fetch weather data for a specific datetime.
   *
   * @param location : String
   *                 location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
   *                 You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
   *                 consider our Multiple Location Timeline Weather API.
   * @param datetime : String
   *                 datetime param is the specific date for which to retrieve weather data.
   *                 All dates and times are in local time of the specified location and should be in the format yyyy-MM-dd.
   */
  def fetchWeatherData(location: String, datetime: String): Unit = {
    try {
      if (API_KEY == null || API_KEY.isEmpty) throw new Exception()

      val urlString = s"$BASE_URL$location/$datetime?key=$API_KEY"
      val jsonString = fetchData(urlString)
      handleWeatherDate(jsonString)
    } catch {
      case e: Exception => e.printStackTrace()
    }
  }

  /**
   * The fetchForecastData method will fetch the weather forecast for location for the next 15 days
   * starting at midnight at the start of the current day (local time of the requested location).
   *
   * @param location : String
   *                 location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
   *                 You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
   *                 consider our Multiple Location Timeline Weather API.
   */
  def fetchForecastData(location: String): Unit = {
    try {
      if (API_KEY == null || API_KEY.isEmpty) throw new Exception()

      val urlString = s"$BASE_URL$location?key=$API_KEY"
      val jsonString = fetchData(urlString)
      handleWeatherDate(jsonString)
    } catch {
      case e: Exception => e.printStackTrace()
    }
  }

  def setWeatherDailyData(weatherDailyData: ArrayBuffer[WeatherDailyData]): Unit = this.weatherDailyData = weatherDailyData
  def getWeatherDailyData: ArrayBuffer[WeatherDailyData] = weatherDailyData

  def getWeatherDataByDay(day: LocalDate): WeatherDailyData = {
    for (weatherDailyData <- weatherDailyData) {
      if (weatherDailyData.datetime == Some(day)) return weatherDailyData
    }
    null
  }

  def getWeatherDataByDay(index: Int): WeatherDailyData = weatherDailyData(index)

  /**
   * The createWeatherDailyData method creates an hourly data object from a JSON object.
   * The method checks if a key in the JSON object is null and sets the corresponding property to null if it is.
   * Otherwise, it assigns the value from the JSON object to the property.
   */
  private def createWeatherDailyData(day: JValue): WeatherDailyData = {
    val dayData = WeatherDailyData()
    dayData.datetime = (day \ "datetime").extractOpt[String]
    dayData.datetimeEpoch = (day \ "datetimeEpoch").extractOpt[Long]
    dayData.tempmax = (day \ "tempmax").extractOpt[Double]
    dayData.tempmin = (day \ "tempmin").extractOpt[Double]
    dayData.temp = (day \ "temp").extractOpt[Double]
    dayData.feelslikemax = (day \ "feelslikemax").extractOpt[Double]
    dayData.feelslikemin = (day \ "feelslikemin").extractOpt[Double]
    dayData.feelslike = (day \ "feelslike").extractOpt[Double]
    dayData.dew = (day \ "dew").extractOpt[Double]
    dayData.humidity = (day \ "humidity").extractOpt[Double]
    dayData.precip = (day \ "precip").extractOpt[Double]
    dayData.precipprob = (day \ "precipprob").extractOpt[Double]
    dayData.precipcover = (day \ "precipcover").extractOpt[Double]
    dayData.preciptype = (day \ "preciptype").extractOpt[ArrayBuffer[String]]
    dayData.snow = (day \ "snow").extractOpt[Double]
    dayData.snowdepth = (day \ "snowdepth").extractOpt[Double]
    dayData.windgust = (day \ "windgust").extractOpt[Double]
    dayData.windspeed = (day \ "windspeed").extractOpt[Double]
    dayData.winddir = (day \ "winddir").extractOpt[Double]
    dayData.pressure = (day \ "pressure").extractOpt[Double]
    dayData.cloudcover = (day \ "cloudcover").extractOpt[Double]
    dayData.visibility = (day \ "visibility").extractOpt[Double]
    dayData.solarradiation = (day \ "solarradiation").extractOpt[Double]
    dayData.solarenergy = (day \ "solarenergy").extractOpt[Double]
    dayData.uvindex = (day \ "uvindex").extractOpt[Double]
    dayData.sunrise = (day \ "sunrise").extractOpt[String]
    dayData.sunriseEpoch = (day \ "sunriseEpoch").extractOpt[Long]
    dayData.sunset = (day \ "sunset").extractOpt[String]
    dayData.sunsetEpoch = (day \ "sunsetEpoch").extractOpt[Long]
    dayData.moonphase = (day \ "moonphase").extractOpt[Double]
    dayData.conditions = (day \ "conditions").extractOpt[String]
    dayData.description = (day \ "description").extractOpt[String]
    dayData.icon = (day \ "icon").extractOpt[String]
    dayData.stations = (day \ "stations").extractOpt[ArrayBuffer[String]]

    val events = (day \ "events").extract[Option[List[JValue]]].getOrElse(List())
    val eventList = ArrayBuffer[Event]()
    for (event <- events) {
      val eventObj = Event()
      eventObj.datetime = (event \ "datetime").extractOpt[String]
      eventObj.datetimeEpoch = (event \ "datetimeEpoch").extractOpt[Long]
      eventObj.`type` = (event \ "type").extractOpt[String]
      eventObj.latitude = (event \ "latitude").extractOpt[Double]
      eventObj.longitude = (event \ "longitude").extractOpt[Double]
      eventObj.distance = (event \ "distance").extractOpt[Double]
      eventObj.description = (event \ "description").extractOpt[String]
      eventObj.size = (event \ "size").extractOpt[Double]

      eventList += eventObj
    }
    dayData.events = Some(eventList)

    dayData.source = (day \ "source").extractOpt[String]

    val hours = (day \ "hours").extract[List[JValue]]
    val hourlyDataList = ArrayBuffer[WeatherHourlyData]()

    for (hour <- hours) {
      val weatherHourlyData = createHourlyData(hour)
      hourlyDataList += weatherHourlyData
    }
    dayData.weatherHourlyData = Some(hourlyDataList)

    return dayData
  }

  /**
   * The createHourlyData method creates an hourly data object from a JSON object.
   * The method checks if a key in the JSON object is null and sets the corresponding property to null if it is.
   * Otherwise, it assigns the value from the JSON object to the property.
   */
  private def createHourlyData(hour: JValue): WeatherHourlyData = {
    val hourData = WeatherHourlyData()

    hourData.datetime = (hour \ "datetime").extractOpt[String]
    hourData.datetimeEpoch = (hour \ "datetimeEpoch").extractOpt[Long]
    hourData.temp = (hour \ "temp").extractOpt[Double]
    hourData.feelslike = (hour \ "feelslike").extractOpt[Double]
    hourData.humidity = (hour \ "humidity").extractOpt[Double]
    hourData.dew = (hour \ "dew").extractOpt[Double]
    hourData.precip = (hour \ "precip").extractOpt[Double]
    hourData.precipprob = (hour \ "precipprob").extractOpt[Double]
    hourData.snow = (hour \ "snow").extractOpt[Double]
    hourData.snowdepth = (hour \ "snowdepth").extractOpt[Double]
    hourData.preciptype = (hour \ "preciptype").extractOpt[Array[String]]
    hourData.windgust = (hour \ "windgust").extractOpt[Double]
    hourData.windspeed = (hour \ "windspeed").extractOpt[Double]
    hourData.winddir = (hour \ "winddir").extractOpt[Double]
    hourData.pressure = (hour \ "pressure").extractOpt[Double]
    hourData.visibility = (hour \ "visibility").extractOpt[Double]
    hourData.cloudcover = (hour \ "cloudcover").extractOpt[Double]
    hourData.solarradiation = (hour \ "solarradiation").extractOpt[Double]
    hourData.solarenergy = (hour \ "solarenergy").extractOpt[Double]
    hourData.uvindex = (hour \ "uvindex").extractOpt[Double]
    hourData.conditions = (hour \ "conditions").extractOpt[String]
    hourData.icon = (hour \ "icon").extractOpt[String]
    hourData.stations = (hour \ "stations").extractOpt[Array[String]]
    hourData.source = (hour \ "source").extractOpt[String]

    return hourData
  }

  def getQueryCost: Option[Long] = queryCost
  def setQueryCost(queryCost: Option[Long]): Unit = this.queryCost = queryCost

  def getLatitude: Option[Double] = latitude
  def setLatitude(latitude: Option[Double]): Unit = this.latitude = latitude

  def getLongitude: Option[Double] = longitude
  def setLongitude(longitude: Option[Double]): Unit = this.longitude = longitude

  def getResolvedAddress: Option[String] = resolvedAddress
  def setResolvedAddress(resolvedAddress: Option[String]): Unit = this.resolvedAddress = resolvedAddress

  def getAddress: Option[String] = address
  def setAddress(address: Option[String]): Unit = this.address = address

  def getTimezone: Option[String] = timezone
  def setTimezone(timezone: Option[String]): Unit = this.timezone = timezone

  def getTzoffset: Option[Double] = tzoffset
  def setTzoffset(tzoffset: Option[Double]): Unit = this.tzoffset = tzoffset

  def getStations: mutable.HashMap[String, Station] = stations
  def setStations(stations: mutable.HashMap[String, Station]): Unit = this.stations = stations
}
