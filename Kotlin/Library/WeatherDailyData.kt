import java.time.LocalDate
/**
 * The WeatherDailyData class represents hourly weather data. It encapsulates all relevant meteorological details
 * temperature, max temperature, min temperature, max feelslike, min feelslike, feelslike, humidity, dew, precip, precippprob,
 * precipcover, preciptype, snow, snowdepth, preciptype, windgust, windspeed, winddir, pressure, visibility, cloudcover,
 * solarradiation, solarenergy, uvindex, sunrise, sunriseEpoch, sunset, sunsetEpoch, moonphase, conditions
 * description,icon, stations, and source for a specific date.
 */

class WeatherDailyData {
    var datetime: LocalDate? = null
        get() = field
        set(value) {
            field = value
        }

    var datetimeEpoch: Long? = null
        get() = field
        set(value) {
            field = value
        }

    var tempmax: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var tempmin: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var temp: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var feelslikemax: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var feelslikemin: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var feelslike: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var dew: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var humidity: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var precip: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var precipprob: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var precipcover: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var preciptype: ArrayList<String>? = ArrayList()
        get() = field
        set(value) {
            field = value ?: ArrayList()
        }

    var snow: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var snowdepth: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var windgust: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var windspeed: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var winddir: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var pressure: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var cloudcover: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var visibility: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var solarradiation: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var solarenergy: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var uvindex: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var sunrise: String? = null
        get() = field
        set(value) {
            field = value
        }

    var sunriseEpoch: Long? = null
        get() = field
        set(value) {
            field = value
        }

    var sunset: String? = null
        get() = field
        set(value) {
            field = value
        }

    var sunsetEpoch: Long? = null
        get() = field
        set(value) {
            field = value
        }

    var moonphase: Double? = null
        get() = field
        set(value) {
            field = value
        }

    var conditions: String? = null
        get() = field
        set(value) {
            field = value
        }

    var description: String? = null
        get() = field
        set(value) {
            field = value
        }

    var icon: String? = null
        get() = field
        set(value) {
            field = value
        }

    var stations: ArrayList<String>? = ArrayList()
        get() = field
        set(value) {
            field = value ?: ArrayList()
        }

    var source: String? = null
        get() = field
        set(value) {
            field = value
        }

    var events: ArrayList<Event>? = ArrayList()
        get() = field
        set(value) {
            field = value ?: ArrayList()
        }

    var weatherHourlyData: ArrayList<WeatherHourlyData>? = ArrayList()
        get() = field
        set(value) {
            field = value ?: ArrayList()
        }
}
