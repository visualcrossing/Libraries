import Foundation

/**
 * The WeatherHourlyData class represents hourly weather data. It encapsulates all relevant meteorological details
 * temperature, feelslike, humidity, dew, precip, precipprob, snow, snowdepth, preciptype, windgust, windspeed, winddir,
 * pressure, visibility, cloudcover, solarradiation, solarenergy, uvindex, conditions, icon, stations, and source for a specific hour.
 */
class WeatherHourlyData {
    private var _datetime: TimeInterval?
    private var _datetimeEpoch: Int64?
    private var _temp: Double?
    private var _feelslike: Double?
    private var _humidity: Double?
    private var _dew: Double?
    private var _precip: Double?
    private var _precipprob: Double?
    private var _snow: Double?
    private var _snowdepth: Double?
    private var _preciptype: [String]
    private var _windgust: Double?
    private var _windspeed: Double?
    private var _winddir: Double?
    private var _pressure: Double?
    private var _visibility: Double?
    private var _cloudcover: Double?
    private var _solarradiation: Double?
    private var _solarenergy: Double?
    private var _uvindex: Double?
    private var _conditions: String?
    private var _icon: String?
    private var _stations: [String]
    private var _source: String?

    // Constructor
    init() {
        _preciptype = [String]()
        _stations = [String]()
    }

    // Properties for each field
    var _Datetime: TimeInterval? {
        get { return _datetime }
        set { _datetime = newValue }
    }

    func _setDatetime( _datetime: String) {
        if _datetime.isEmpty {
            self._datetime = 0
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            if let date = formatter.date(from: _datetime) {
                self._datetime = date.timeIntervalSince1970
            }
        }
    }

    var _DatetimeEpoch: Int64? {
        get { return _datetimeEpoch }
        set { _datetimeEpoch = newValue }
    }
    var _Temp: Double? {
        get { return _temp }
        set { _temp = newValue }
    }
    var _FeelsLike: Double? {
        get { return _feelslike }
        set { _feelslike = newValue }
    }
    var _Humidity: Double? {
        get { return _humidity }
        set { _humidity = newValue }
    }
    var _Dew: Double? {
        get { return _dew }
        set { _dew = newValue }
    }
    var _Precip: Double? {
        get { return _precip }
        set { _precip = newValue }
    }
    var _PrecipProb: Double? {
        get { return _precipprob }
        set { _precipprob = newValue }
    }
    var _Snow: Double? {
        get { return _snow }
        set { _snow = newValue }
    }
    var _SnowDepth: Double? {
        get { return _snowdepth }
        set { _snowdepth = newValue }
    }
    var _PrecipType: [String] {
        get { return _preciptype }
        set { _preciptype = newValue }
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
    var _Visibility: Double? {
        get { return _visibility }
        set { _visibility = newValue }
    }
    var _CloudCover: Double? {
        get { return _cloudcover }
        set { _cloudcover = newValue }
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
    var _Conditions: String? {
        get { return _conditions }
        set { _conditions = newValue }
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
}
