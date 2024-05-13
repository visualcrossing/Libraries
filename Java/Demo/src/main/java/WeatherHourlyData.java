import java.util.ArrayList;
/**
 * The WeatherHourlyData class represents hourly weather data. It encapsulates all relevant meteorological details
 * temperature, feelslike, humidity, dew, precip, precippprob, snow, snowdepth, preciptype, windgust, windspeed, winddir,
 * pressure, visibility, cloudcover, solarradiation, solarenergy, uvindex, conditions, icon, stations, and source for a specific hour.
 */
public class WeatherHourlyData {
    private String datetime;
    private Long datetimeEpoch;
    private Double temp;
    private Double feelslike;
    private Double humidity;
    private Double dew;
    private Double precip;
    private Double precipprob;
    private Double snow;
    private Double snowdepth;
    private ArrayList<String> preciptype;
    private Double windgust;
    private Double windspeed;
    private Double winddir;
    private Double pressure;
    private Double visibility;
    private Double cloudcover;
    private Double solarradiation;
    private Double solarenergy;
    private Double uvindex;
    private String conditions;
    private String icon;
    private ArrayList<String> stations;
    private String source;

    // Constructor
    public WeatherHourlyData() {}

    // Getters and Setters
    public String getDatetime() { return datetime; }

    public void setDatetime(String datetime) { this.datetime = datetime; }

    public long getDatetimeEpoch() { return datetimeEpoch; }

    public void setDatetimeEpoch(long datetimeEpoch) { this.datetimeEpoch = datetimeEpoch; }

    public Double getTemp() { return temp; }

    public void setTemp(Double temp) { this.temp = temp; }

    public Double getFeelslike() { return feelslike; }

    public void setFeelslike(Double feelslike) { this.feelslike = feelslike; }

    public Double getHumidity() { return humidity; }

    public void setHumidity(Double humidity) { this.humidity = humidity; }

    public Double getDew() { return dew; }

    public void setDew(Double dew) { this.dew = dew; }

    public Double getPrecip() { return precip; }

    public void setPrecip(Double precip) { this.precip = precip; }

    public Double getPreciPprob() { return precipprob; }

    public void setPrecipProb(Double precipprob) { this.precipprob = precipprob; }

    public Double getSnow() { return snow; }

    public void setSnow(Double snow) { this.snow = snow; }

    public Double getSnowDepth() { return snowdepth; }

    public void setSnowDepth(Double snowdepth) { this.snowdepth = snowdepth; }

    public ArrayList<String> getPrecipType() { return preciptype; }

    public void setPrecipType(ArrayList<String> preciptype) { this.preciptype = preciptype; }

    public Double getWindGust() { return windgust; }

    public void setWindGust(Double windgust) { this.windgust = windgust; }

    public Double getWindSpeed() { return windspeed; }

    public void setWindSpeed(Double windspeed) { this.windspeed = windspeed; }

    public Double getWindDir() { return winddir; }

    public void setWindDir(Double winddir) { this.winddir = winddir; }

    public Double getPressure() { return pressure; }

    public void setPressure(Double pressure) { this.pressure = pressure; }

    public Double getVisibility() { return visibility; }

    public void setVisibility(Double visibility) { this.visibility = visibility; }

    public Double getCloudCover() { return cloudcover; }

    public void setCloudCover(Double cloudcover) { this.cloudcover = cloudcover; }

    public Double getSolarRadiation() { return solarradiation; }

    public void setSolarRadiation(Double solarradiation) { this.solarradiation = solarradiation; }

    public Double getSolarEnergy() { return solarenergy; }

    public void setSolarEnergy(Double solarenergy) { this.solarenergy = solarenergy; }

    public Double getUvIndex() { return uvindex; }

    public void setUvIndex(Double uvindex) { this.uvindex = uvindex; }

    public String getConditions() { return conditions; }

    public void setConditions(String conditions) { this.conditions = conditions; }

    public String getIcon() { return icon; }

    public void setIcon(String icon) { this.icon = icon; }

    public ArrayList<String> getStations() { return stations; }

    public void setStations(ArrayList<String> stations) { this.stations = stations; }

    public String getSource() { return source; }

    public void setSource(String source) { this.source = source; }
}