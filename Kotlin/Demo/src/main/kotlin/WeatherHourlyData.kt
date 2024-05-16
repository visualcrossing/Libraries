import java.time.LocalTime

/**
 * The WeatherHourlyData class represents hourly weather data. It encapsulates all relevant meteorological details
 * temperature, feelslike, humidity, dew, precip, precippprob, snow, snowdepth, preciptype, windgust, windspeed, winddir,
 * pressure, visibility, cloudcover, solarradiation, solarenergy, uvindex, conditions, icon, stations, and source for a specific hour.
 */

class WeatherHourlyData {
    var datetime: LocalTime? = null
        get() = field
        set(value) {
            field = value;
        }

    var datetimeEpoch: Long? = null
        get() = field
        set(value) {
            field = value
        }

    var temp: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var feelslike: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var humidity: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var dew: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var precip: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var precipProb: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var snow: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var snowDepth: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var precipType: ArrayList<String>? = null
        get() = field
        set(value) {
            field = value
        }

    var windGust: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var windSpeed: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var windDir: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var pressure: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var visibility: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var cloudCover: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var solarRadiation: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var solarEnergy: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var uvIndex: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var conditions: String? = null
        get() = field
        set(value) {
            field = value
        }

    var icon: String? = null
        get() = field
        set(value) {
            field = value
        }

    var stations: ArrayList<String>? = null
        get() = field
        set(value) {
            field = value
        }

    var source: String? = null
        get() = field
        set(value) {
            field = value
        }
}
