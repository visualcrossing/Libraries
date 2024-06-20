import Foundation

/**
 * The WeatherDailyData class represents hourly weather data. It encapsulates all relevant meteorological details
 * temperature, max temperature, min temperature, max feelslike, min feelslike, feelslike, humidity, dew, precip, precipprob,
 * precipcover, preciptype, snow, snowdepth, windgust, windspeed, winddir, pressure, visibility, cloudcover,
 * solarradiation, solarenergy, uvindex, sunrise, sunriseEpoch, sunset, sunsetEpoch, moonphase, conditions,
 * description, icon, stations, and source for a specific date.
 */
class WeatherDailyData {
    private var _datetime: Date?
    private var _datetimeEpoch: Int64?
    private var _tempmax: Double?
    private var _tempmin: Double?
    private var _temp: Double?
    private var _feelslikemax: Double?
    private var _feelslikemin: Double?
    private var _feelslike: Double?
    private var _dew: Double?
    private var _humidity: Double?
    private var _precip: Double?
    private var _precipprob: Double?
    private var _precipcover: Double?
    private var _preciptype: [String]
    private var _snow: Double?
    private var _snowdepth: Double?
    private var _windgust: Double?
    private var _windspeed: Double?
    private var _winddir: Double?
    private var _pressure: Double?
    private var _cloudcover: Double?
    private var _visibility: Double?
    private var _solarradiation: Double?
    private var _solarenergy: Double?
    private var _uvindex: Double?
    private var _sunrise: String?
    private var _sunriseEpoch: Int64?
    private var _sunset: String?
    private var _sunsetEpoch: Int64?
    private var _moonphase: Double?
    private var _conditions: String?
    private var _description: String?
    private var _icon: String?
    private var _stations: [String]
    private var _source: String?
    private var _events: [Event]
    private var _weatherHourlyData: [WeatherHourlyData]

    // Constructors
    init() {
        self._preciptype = [String]()
        self._stations = [String]()
        self._events = [Event]()
        self._weatherHourlyData = [WeatherHourlyData]()
    }

    // Getters and setters for each property
    var _Datetime: Date? {
        get { return _datetime }
        set { _datetime = newValue }
    }
    var _DatetimeEpoch: Int64? {
        get { return _datetimeEpoch }
        set { _datetimeEpoch = newValue }
    }
    var _TempMax: Double? {
        get { return _tempmax }
        set { _tempmax = newValue }
    }
    var _TempMin: Double? {
        get { return _tempmin }
        set { _tempmin = newValue }
    }
    var _Temp: Double? {
        get { return _temp }
        set { _temp = newValue }
    }
    var _FeelsLikeMax: Double? {
        get { return _feelslikemax }
        set { _feelslikemax = newValue }
    }
    var _FeelsLikeMin: Double? {
        get { return _feelslikemin }
        set { _feelslikemin = newValue }
    }
    var _FeelsLike: Double? {
        get { return _feelslike }
        set { _feelslike = newValue }
    }
    var _Dew: Double? {
        get { return _dew }
        set { _dew = newValue }
    }
    var _Humidity: Double? {
        get { return _humidity }
        set { _humidity = newValue }
    }
    var _Precip: Double? {
        get { return _precip }
        set { _precip = newValue }
    }
    var _PrecipProb: Double? {
        get { return _precipprob }
        set { _precipprob = newValue }
    }
    var _PrecipCover: Double? {
        get { return _precipcover }
        set { _precipcover = newValue }
    }
    var _PrecipType: [String] {
        get { return _preciptype }
        set { _preciptype = newValue }
    }
    var _Snow: Double? {
        get { return _snow }
        set { _snow = newValue }
    }
    var _SnowDepth: Double? {
        get { return _snowdepth }
        set { _snowdepth = newValue }
    }
    var _WindGust: Double? {
        get { return _windgust }
        set { _windgust = newValue }
    }
    var _WindSpeed: Double? {
        get { return _windspeed }
        set { _windspeed = newValue }
    }
    var _WindDir: Double? {
        get { return _winddir }
        set { _winddir = newValue }
    }
    var _Pressure: Double? {
        get { return _pressure }
        set { _pressure = newValue }
    }
    var _CloudCover: Double? {
        get { return _cloudcover }
        set { _cloudcover = newValue }
    }
    var _Visibility: Double? {
        get { return _visibility }
        set { _visibility = newValue }
    }
    var _SolarRadiation: Double? {
        get { return _solarradiation }
        set { _solarradiation = newValue }
    }
    var _SolarEnergy: Double? {
        get { return _solarenergy }
        set { _solarenergy = newValue }
    }
    var _UvIndex: Double? {
        get { return _uvindex }
        set { _uvindex = newValue }
    }
    var _Sunrise: String? {
        get { return _sunrise }
        set { _sunrise = newValue }
    }
    var _SunriseEpoch: Int64? {
        get { return _sunriseEpoch }
        set { _sunriseEpoch = newValue }
    }
    var _Sunset: String? {
        get { return _sunset }
        set { _sunset = newValue }
    }
    var _SunsetEpoch: Int64? {
        get { return _sunsetEpoch }
        set { _sunsetEpoch = newValue }
    }
    var _MoonPhase: Double? {
        get { return _moonphase }
        set { _moonphase = newValue }
    }
    var _Conditions: String? {
        get { return _conditions }
        set { _conditions = newValue }
    }
    var _Description: String? {
        get { return _description }
        set { _description = newValue }
    }
    var _Icon: String? {
        get { return _icon }
        set { _icon = newValue }
    }
    var _Stations: [String] {
        get { return _stations }
        set { _stations = newValue }
    }
    var _Source: String? {
        get { return _source }
        set { _source = newValue }
    }
    var _Events: [Event] {
        get { return _events }
        set { _events = newValue }
    }
    var _WeatherHourlyData: [WeatherHourlyData] {
        get { return _weatherHourlyData }
        set { _weatherHourlyData = newValue }
    }
}
