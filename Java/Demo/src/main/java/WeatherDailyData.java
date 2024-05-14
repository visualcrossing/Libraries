import org.json.JSONArray;
import org.json.JSONObject;

import java.time.LocalDate;
import java.util.ArrayList;

/**
 * The WeatherDailyData class represents hourly weather data. It encapsulates all relevant meteorological details
 * temperature, max temperature, min temperature, max feelslike, min feelslike, feelslike, humidity, dew, precip, precippprob,
 * precipcover, preciptype, snow, snowdepth, preciptype, windgust, windspeed, winddir, pressure, visibility, cloudcover,
 * solarradiation, solarenergy, uvindex, sunrise, sunriseEpoch, sunset, sunsetEpoch, moonphase, conditions
 * description,icon, stations, and source for a specific date.
 */
public class WeatherDailyData {
    private LocalDate datetime;
    private Long datetimeEpoch;
    private Double tempmax;
    private Double tempmin;
    private Double temp;
    private Double feelslikemax;
    private Double feelslikemin;
    private Double feelslike;
    private Double dew;
    private Double humidity;
    private Double precip;
    private Double precipprob;
    private Double precipcover;
    private ArrayList<String> preciptype;
    private Double snow;
    private Double snowdepth;
    private Double windgust;
    private Double windspeed;
    private Double winddir;
    private Double pressure;
    private Double cloudcover;
    private Double visibility;
    private Double solarradiation;
    private Double solarenergy;
    private Double uvindex;
    private String sunrise;
    private Long sunriseEpoch;
    private String sunset;
    private Long sunsetEpoch;
    private Double moonphase;
    private String conditions;
    private String description;
    private String icon;
    private ArrayList<String> stations;
    private String source;
    private ArrayList<Event> events;


    private ArrayList<WeatherHourlyData> weatherHourlyData;

    // Getters and Setters
    public ArrayList<WeatherHourlyData> getHourlyData() { return weatherHourlyData; }
    public void setHourlyData(ArrayList<WeatherHourlyData> hourlyData) { this.weatherHourlyData = hourlyData; }

    private Double getDoubleOrNull(JSONObject hour, String key) {
        return hour.isNull(key) ? null : hour.getDouble(key);
    }

    private String getStringOrNull(JSONObject hour, String key) {
        return hour.isNull(key) ? null : hour.getString(key);
    }

    private Long getLongOrNull(JSONObject hour, String key) {
        return hour.isNull(key) ? null : hour.getLong(key);
    }

    /**
     * The createHourlyData function creates an hourly data object from a JSON object.
     * The function checks if a key in the JSON object is null and sets the corresponding property to null if it is.
     * Otherwise, it assigns the value from the JSON object to the property.
    */
    public WeatherHourlyData createHourlyData(JSONObject hour) {
        WeatherHourlyData weatherHourlyData = new WeatherHourlyData();

        weatherHourlyData.setDatetime(getStringOrNull(hour,"datetime"));
        weatherHourlyData.setDatetimeEpoch(getLongOrNull(hour,"datetimeEpoch"));
        weatherHourlyData.setTemp(getDoubleOrNull(hour,"temp"));
        weatherHourlyData.setFeelslike(getDoubleOrNull(hour,"feelslike"));
        weatherHourlyData.setHumidity(getDoubleOrNull(hour,"humidity"));
        weatherHourlyData.setDew(getDoubleOrNull(hour,"dew"));
        weatherHourlyData.setPrecip(getDoubleOrNull(hour,"precip"));
        weatherHourlyData.setPrecipProb(getDoubleOrNull(hour,"precipprob"));
        weatherHourlyData.setSnow(getDoubleOrNull(hour,"snow"));
        weatherHourlyData.setSnowDepth(getDoubleOrNull(hour,"snowdepth"));

        if (hour.isNull("preciptype"))
            weatherHourlyData.setPrecipType(null);
        else {
            JSONArray precipTypes = hour.getJSONArray("preciptype");
            ArrayList<String> typeList = new ArrayList<>();
            for (int k = 0; k < precipTypes.length(); k++) {
                typeList.add(precipTypes.getString(k));
            }
            weatherHourlyData.setPrecipType(typeList);
        }

        weatherHourlyData.setWindGust(getDoubleOrNull(hour,"windgust"));
        weatherHourlyData.setWindSpeed(getDoubleOrNull(hour,"windspeed"));
        weatherHourlyData.setWindDir(getDoubleOrNull(hour,"winddir"));
        weatherHourlyData.setPressure(getDoubleOrNull(hour,"pressure"));
        weatherHourlyData.setVisibility(getDoubleOrNull(hour,"visibility"));
        weatherHourlyData.setCloudCover(getDoubleOrNull(hour,"cloudcover"));
        weatherHourlyData.setSolarRadiation(getDoubleOrNull(hour,"solarradiation"));
        weatherHourlyData.setSolarEnergy(getDoubleOrNull(hour,"solarenergy"));
        weatherHourlyData.setUvIndex(getDoubleOrNull(hour,"uvindex"));
        weatherHourlyData.setConditions(getStringOrNull(hour,"conditions"));
        weatherHourlyData.setIcon(getStringOrNull(hour,"icon"));

        if (hour.isNull("stations"))
            weatherHourlyData.setStations(null);
        else {
            JSONArray stations = hour.getJSONArray("stations");
            ArrayList<String> stationList = new ArrayList<>();
            for (int k = 0; k < stations.length(); k++) {
                stationList.add(stations.getString(k));
            }
            weatherHourlyData.setStations(stationList);
        }

        weatherHourlyData.setSource(getStringOrNull(hour,"source"));

        return weatherHourlyData;
    }

    public LocalDate getDatetime() { return datetime; }

    public void setDatetime(String datetime) {
        if (datetime == null)
            this.datetime = null;
        else
            this.datetime = LocalDate.parse(datetime);
    }

    public Long getDatetimeEpoch() { return datetimeEpoch; }

    public void setDatetimeEpoch(Long datetimeEpoch) { this.datetimeEpoch = datetimeEpoch; }

    public Double getTempMax() { return tempmax; }

    public void setTempMax(Double tempmax) { this.tempmax = tempmax; }

    public Double getTempMin() { return tempmin; }

    public void setTempMin(Double tempmin) { this.tempmin = tempmin; }

    public Double getTemp() { return temp; }

    public void setTemp(Double temp) { this.temp = temp; }

    public Double getFeelslikeMax() { return feelslikemax; }

    public void setFeelslikeMax(Double feelslikemax) { this.feelslikemax = feelslikemax; }

    public Double getFeelslikeMin() { return feelslikemin; }

    public void setFeelslikeMin(Double feelslikemin) { this.feelslikemin = feelslikemin; }

    public Double getFeelslike() { return feelslike; }

    public void setFeelslike(Double feelslike) { this.feelslike = feelslike; }

    public Double getDew() { return dew; }

    public void setDew(Double dew) { this.dew = dew; }

    public Double getHumidity() { return humidity; }

    public void setHumidity(Double humidity) { this.humidity = humidity; }

    public Double getPrecip() { return precip; }

    public void setPrecip(Double precip) { this.precip = precip; }

    public Double getPrecipprob() { return precipprob; }

    public void setPrecipprob(Double precipprob) { this.precipprob = precipprob; }

    public Double getPrecipCover() { return precipcover; }

    public void setPrecipCover(Double precipcover) { this.precipcover = precipcover; }

    public ArrayList<String> getPreciptype() { return preciptype; }

    public void setPreciptype(ArrayList<String> preciptype) { this.preciptype = preciptype; }

    public Double getSnow() { return snow; }

    public void setSnow(Double snow) { this.snow = snow; }

    public Double getSnowdepth() { return snowdepth; }

    public void setSnowdepth(Double snowdepth) { this.snowdepth = snowdepth; }

    public Double getWindgust() { return windgust; }

    public void setWindgust(Double windgust) { this.windgust = windgust; }

    public Double getWindSpeed() { return windspeed; }

    public void setWindSpeed(Double windspeed) { this.windspeed = windspeed; }

    public Double getWinddir() { return winddir; }

    public void setWinddir(Double winddir) { this.winddir = winddir; }

    public Double getPressure() { return pressure; }

    public void setPressure(Double pressure) { this.pressure = pressure; }

    public Double getCloudCover() { return cloudcover; }

    public void setCloudCover(Double cloudcover) { this.cloudcover = cloudcover; }

    public Double getVisibility() { return visibility; }

    public void setVisibility(Double visibility) { this.visibility = visibility; }

    public Double getSolarRadiation() { return solarradiation; }

    public void setSolarRadiation(Double solarradiation) { this.solarradiation = solarradiation; }

    public Double getSolarEnergy() { return solarenergy; }

    public void setSolarEnergy(Double solarenergy) { this.solarenergy = solarenergy; }

    public Double getUvIndex() { return uvindex; }

    public void setUvIndex(Double uvindex) { this.uvindex = uvindex; }

    public String getSunRise() { return sunrise; }

    public void setSunRise(String sunrise) { this.sunrise = sunrise; }

    public Long getSunRiseEpoch() { return sunriseEpoch; }

    public void setSunRiseEpoch(Long sunriseEpoch) { this.sunriseEpoch = sunriseEpoch; }

    public String getSunSet() { return sunset; }

    public void setSunSet(String sunset) { this.sunset = sunset; }

    public Long getSunSetEpoch() { return sunsetEpoch; }

    public void setSunSetEpoch(Long sunsetEpoch) { this.sunsetEpoch = sunsetEpoch; }

    public Double getMoonPhase() { return moonphase; }

    public void setMoonPhase(Double moonphase) { this.moonphase = moonphase; }

    public String getConditions() { return conditions; }

    public void setConditions(String conditions) { this.conditions = conditions; }

    public String getDescription() { return description; }

    public void setDescription(String description) { this.description = description; }

    public String getIcon() { return icon; }

    public void setIcon(String icon) { this.icon = icon; }

    public ArrayList<String> getStations() { return stations; }

    public void setStations(ArrayList<String> stations) { this.stations = stations; }

    public ArrayList<Event> getEvents() {return events; }
    public void setEvents(ArrayList<Event> events) { this.events = events; }

    public String getSource() { return source; }

    public void setSource(String source) { this.source = source; }
}