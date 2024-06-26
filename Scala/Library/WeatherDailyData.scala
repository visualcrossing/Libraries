import java.time.LocalDate
import scala.collection.mutable.ArrayBuffer

/**
 * The WeatherDailyData class represents hourly weather data. It encapsulates all relevant meteorological details
 * temperature, max temperature, min temperature, max feelslike, min feelslike, feelslike, humidity, dew, precip, precippprob,
 * precipcover, preciptype, snow, snowdepth, preciptype, windgust, windspeed, winddir, pressure, visibility, cloudcover,
 * solarradiation, solarenergy, uvindex, sunrise, sunriseEpoch, sunset, sunsetEpoch, moonphase, conditions
 * description,icon, stations, and source for a specific date.
 */

case class WeatherDailyData(
                             private var _datetime: Option[LocalDate] = None,
                             private var _datetimeEpoch: Option[Long] = None,
                             private var _tempmax: Option[Double] = None,
                             private var _tempmin: Option[Double] = None,
                             private var _temp: Option[Double] = None,
                             private var _feelslikemax: Option[Double] = None,
                             private var _feelslikemin: Option[Double] = None,
                             private var _feelslike: Option[Double] = None,
                             private var _dew: Option[Double] = None,
                             private var _humidity: Option[Double] = None,
                             private var _precip: Option[Double] = None,
                             private var _precipprob: Option[Double] = None,
                             private var _precipcover: Option[Double] = None,
                             private var _preciptype: Option[ArrayBuffer[String]] = None,
                             private var _snow: Option[Double] = None,
                             private var _snowdepth: Option[Double] = None,
                             private var _windgust: Option[Double] = None,
                             private var _windspeed: Option[Double] = None,
                             private var _winddir: Option[Double] = None,
                             private var _pressure: Option[Double] = None,
                             private var _cloudcover: Option[Double] = None,
                             private var _visibility: Option[Double] = None,
                             private var _solarradiation: Option[Double] = None,
                             private var _solarenergy: Option[Double] = None,
                             private var _uvindex: Option[Double] = None,
                             private var _sunrise: Option[String] = None,
                             private var _sunriseEpoch: Option[Long] = None,
                             private var _sunset: Option[String] = None,
                             private var _sunsetEpoch: Option[Long] = None,
                             private var _moonphase: Option[Double] = None,
                             private var _conditions: Option[String] = None,
                             private var _description: Option[String] = None,
                             private var _icon: Option[String] = None,
                             private var _stations: Option[ArrayBuffer[String]] = None,
                             private var _source: Option[String] = None,
                             private var _events: Option[ArrayBuffer[Event]] = None,
                             private var _weatherHourlyData: Option[ArrayBuffer[WeatherHourlyData]] = None
                           ) {

  def datetime: Option[LocalDate] = _datetime
  def datetime_=(datetime: Option[String]): Unit = {
    _datetime = datetime.map(LocalDate.parse)
  }

  def datetimeEpoch: Option[Long] = _datetimeEpoch
  def datetimeEpoch_=(datetimeEpoch: Option[Long]): Unit = {
    _datetimeEpoch = datetimeEpoch
  }

  def tempmax: Option[Double] = _tempmax
  def tempmax_=(tempmax: Option[Double]): Unit = {
    _tempmax = tempmax
  }

  def tempmin: Option[Double] = _tempmin
  def tempmin_=(tempmin: Option[Double]): Unit = {
    _tempmin = tempmin
  }

  def temp: Option[Double] = _temp
  def temp_=(temp: Option[Double]): Unit = {
    _temp = temp
  }

  def feelslikemax: Option[Double] = _feelslikemax
  def feelslikemax_=(feelslikemax: Option[Double]): Unit = {
    _feelslikemax = feelslikemax
  }

  def feelslikemin: Option[Double] = _feelslikemin
  def feelslikemin_=(feelslikemin: Option[Double]): Unit = {
    _feelslikemin = feelslikemin
  }

  def feelslike: Option[Double] = _feelslike
  def feelslike_=(feelslike: Option[Double]): Unit = {
    _feelslike = feelslike
  }

  def dew: Option[Double] = _dew
  def dew_=(dew: Option[Double]): Unit = {
    _dew = dew
  }

  def humidity: Option[Double] = _humidity
  def humidity_=(humidity: Option[Double]): Unit = {
    _humidity = humidity
  }

  def precip: Option[Double] = _precip
  def precip_=(precip: Option[Double]): Unit = {
    _precip = precip
  }

  def precipprob: Option[Double] = _precipprob
  def precipprob_=(precipprob: Option[Double]): Unit = {
    _precipprob = precipprob
  }

  def precipcover: Option[Double] = _precipcover
  def precipcover_=(precipcover: Option[Double]): Unit = {
    _precipcover = precipcover
  }

  def preciptype: Option[ArrayBuffer[String]] = _preciptype
  def preciptype_=(preciptype: Option[ArrayBuffer[String]]): Unit = {
    _preciptype = preciptype
  }

  def snow: Option[Double] = _snow
  def snow_=(snow: Option[Double]): Unit = {
    _snow = snow
  }

  def snowdepth: Option[Double] = _snowdepth
  def snowdepth_=(snowdepth: Option[Double]): Unit = {
    _snowdepth = snowdepth
  }

  def windgust: Option[Double] = _windgust
  def windgust_=(windgust: Option[Double]): Unit = {
    _windgust = windgust
  }

  def windspeed: Option[Double] = _windspeed
  def windspeed_=(windspeed: Option[Double]): Unit = {
    _windspeed = windspeed
  }

  def winddir: Option[Double] = _winddir
  def winddir_=(winddir: Option[Double]): Unit = {
    _winddir = winddir
  }

  def pressure: Option[Double] = _pressure
  def pressure_=(pressure: Option[Double]): Unit = {
    _pressure = pressure
  }

  def cloudcover: Option[Double] = _cloudcover
  def cloudcover_=(cloudcover: Option[Double]): Unit = {
    _cloudcover = cloudcover
  }

  def visibility: Option[Double] = _visibility
  def visibility_=(visibility: Option[Double]): Unit = {
    _visibility = visibility
  }

  def solarradiation: Option[Double] = _solarradiation
  def solarradiation_=(solarradiation: Option[Double]): Unit = {
    _solarradiation = solarradiation
  }

  def solarenergy: Option[Double] = _solarenergy
  def solarenergy_=(solarenergy: Option[Double]): Unit = {
    _solarenergy = solarenergy
  }

  def uvindex: Option[Double] = _uvindex
  def uvindex_=(uvindex: Option[Double]): Unit = {
    _uvindex = uvindex
  }

  def sunrise: Option[String] = _sunrise
  def sunrise_=(sunrise: Option[String]): Unit = {
    _sunrise = sunrise
  }

  def sunriseEpoch: Option[Long] = _sunriseEpoch
  def sunriseEpoch_=(sunriseEpoch: Option[Long]): Unit = {
    _sunriseEpoch = sunriseEpoch
  }

  def sunset: Option[String] = _sunset
  def sunset_=(sunset: Option[String]): Unit = {
    _sunset = sunset
  }

  def sunsetEpoch: Option[Long] = _sunsetEpoch
  def sunsetEpoch_=(sunsetEpoch: Option[Long]): Unit = {
    _sunsetEpoch = sunsetEpoch
  }

  def moonphase: Option[Double] = _moonphase
  def moonphase_=(moonphase: Option[Double]): Unit = {
    _moonphase = moonphase
  }

  def conditions: Option[String] = _conditions
  def conditions_=(conditions: Option[String]): Unit = {
    _conditions = conditions
  }

  def description: Option[String] = _description
  def description_=(description: Option[String]): Unit = {
    _description = description
  }

  def icon: Option[String] = _icon
  def icon_=(icon: Option[String]): Unit = {
    _icon = icon
  }

  def stations: Option[ArrayBuffer[String]] = _stations
  def stations_=(stations: Option[ArrayBuffer[String]]): Unit = {
    _stations = stations
  }

  def source: Option[String] = _source
  def source_=(source: Option[String]): Unit = {
    _source = source
  }

  def events: Option[ArrayBuffer[Event]] = _events
  def events_=(events: Option[ArrayBuffer[Event]]): Unit = {
    _events = events
  }

  def weatherHourlyData: Option[ArrayBuffer[WeatherHourlyData]] = _weatherHourlyData
  def weatherHourlyData_=(weatherHourlyData: Option[ArrayBuffer[WeatherHourlyData]]): Unit = {
    _weatherHourlyData = weatherHourlyData
  }
}
