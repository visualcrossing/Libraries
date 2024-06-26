import java.time.LocalTime

/**
 * The WeatherHourlyData class represents hourly weather data. It encapsulates all relevant meteorological details
 * temperature, feelslike, humidity, dew, precip, precippprob, snow, snowdepth, preciptype, windgust, windspeed, winddir,
 * pressure, visibility, cloudcover, solarradiation, solarenergy, uvindex, conditions, icon, stations, and source for a specific hour.
 */

class WeatherHourlyData(
                         private var _datetime: Option[LocalTime] = None,
                         private var _datetimeEpoch: Option[Long] = None,
                         private var _temp: Option[Double] = None,
                         private var _feelslike: Option[Double] = None,
                         private var _humidity: Option[Double] = None,
                         private var _dew: Option[Double] = None,
                         private var _precip: Option[Double] = None,
                         private var _precipprob: Option[Double] = None,
                         private var _snow: Option[Double] = None,
                         private var _snowdepth: Option[Double] = None,
                         private var _preciptype: Option[Array[String]] = None,
                         private var _windgust: Option[Double] = None,
                         private var _windspeed: Option[Double] = None,
                         private var _winddir: Option[Double] = None,
                         private var _pressure: Option[Double] = None,
                         private var _visibility: Option[Double] = None,
                         private var _cloudcover: Option[Double] = None,
                         private var _solarradiation: Option[Double] = None,
                         private var _solarenergy: Option[Double] = None,
                         private var _uvindex: Option[Double] = None,
                         private var _conditions: Option[String] = None,
                         private var _icon: Option[String] = None,
                         private var _stations: Option[Array[String]] = None,
                         private var _source: Option[String] = None
                       ) {

  def this() = this(
    None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None, None
  )

  def datetime: Option[LocalTime] = _datetime
  def datetime_=(datetime: Option[String]): Unit = {
    _datetime = datetime.map(LocalTime.parse)
  }

  def datetimeEpoch: Option[Long] = _datetimeEpoch
  def datetimeEpoch_=(datetimeEpoch: Option[Long]): Unit = {
    _datetimeEpoch = datetimeEpoch
  }

  def temp: Option[Double] = _temp
  def temp_=(temp: Option[Double]): Unit = {
    _temp = temp
  }

  def feelslike: Option[Double] = _feelslike
  def feelslike_=(feelslike: Option[Double]): Unit = {
    _feelslike = feelslike
  }

  def humidity: Option[Double] = _humidity
  def humidity_=(humidity: Option[Double]): Unit = {
    _humidity = humidity
  }

  def dew: Option[Double] = _dew
  def dew_=(dew: Option[Double]): Unit = {
    _dew = dew
  }

  def precip: Option[Double] = _precip
  def precip_=(precip: Option[Double]): Unit = {
    _precip = precip
  }

  def precipprob: Option[Double] = _precipprob
  def precipprob_=(precipprob: Option[Double]): Unit = {
    _precipprob = precipprob
  }

  def snow: Option[Double] = _snow
  def snow_=(snow: Option[Double]): Unit = {
    _snow = snow
  }

  def snowdepth: Option[Double] = _snowdepth
  def snowdepth_=(snowdepth: Option[Double]): Unit = {
    _snowdepth = snowdepth
  }

  def preciptype: Option[Array[String]] = _preciptype
  def preciptype_=(preciptype: Option[Array[String]]): Unit = {
    _preciptype = preciptype
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

  def visibility: Option[Double] = _visibility
  def visibility_=(visibility: Option[Double]): Unit = {
    _visibility = visibility
  }

  def cloudcover: Option[Double] = _cloudcover
  def cloudcover_=(cloudcover: Option[Double]): Unit = {
    _cloudcover = cloudcover
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

  def conditions: Option[String] = _conditions
  def conditions_=(conditions: Option[String]): Unit = {
    _conditions = conditions
  }

  def icon: Option[String] = _icon
  def icon_=(icon: Option[String]): Unit = {
    _icon = icon
  }

  def stations: Option[Array[String]] = _stations
  def stations_=(stations: Option[Array[String]]): Unit = {
    _stations = stations
  }

  def source: Option[String] = _source
  def source_=(source: Option[String]): Unit = {
    _source = source
  }
}
