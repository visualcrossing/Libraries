import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;

public class WeatherData{
    private Long queryCost;
    private Double latitude;
    private Double longitude;
    private String resolvedAddress;
    private String address;
    private String timezone;
    private Double tzoffset;

    private ArrayList<WeatherDailyData> weatherDailyData;

    public WeatherData() {}
    public void setWeatherDailyData(ArrayList<WeatherDailyData> weatherDailyData) { this.weatherDailyData = weatherDailyData; }

    public ArrayList<WeatherDailyData> getWeatherDailyData() { return weatherDailyData; }

    public WeatherDailyData getWeatherDataByDay(String day){
        for(WeatherDailyData weatherDailyData : weatherDailyData){
            if (weatherDailyData.getDatetime() == day)
                return weatherDailyData;
        }
        return null;
    }

    public WeatherDailyData getWeatherDataByDay(int index){
        return weatherDailyData.get(index);
    }

    private Double getDoubleOrNull(JSONObject day, String key) {
        return day.isNull(key) ? null : day.getDouble(key);
    }

    private String getStringOrNull(JSONObject day, String key) {
        return day.isNull(key) ? null : day.getString(key);
    }

    private Long getLongOrNull(JSONObject day, String key) {
        return day.isNull(key) ? null : day.getLong(key);
    }

    /**
     * The createWeatherDailyData function creates an hourly data object from a JSON object.
     * The function checks if a key in the JSON object is null and sets the corresponding property to null if it is.
     * Otherwise, it assigns the value from the JSON object to the property.
     */
    public WeatherDailyData createWeatherDailyData(JSONObject day) {
        WeatherDailyData weatherDailyData = new WeatherDailyData();

        // Access fields within each 'day' object
        weatherDailyData.setDatetime(getStringOrNull(day,"datetime"));
        weatherDailyData.setDatetimeEpoch(getLongOrNull(day,"datetimeEpoch"));
        weatherDailyData.setTempMax(getDoubleOrNull(day,"tempmax"));
        weatherDailyData.setTempMin(getDoubleOrNull(day,"tempmin"));
        weatherDailyData.setTemp(getDoubleOrNull(day,"temp"));
        weatherDailyData.setFeelslikeMax(getDoubleOrNull(day,"feelslikemax"));
        weatherDailyData.setFeelslikeMin(getDoubleOrNull(day,"feelslikemin"));
        weatherDailyData.setFeelslike(getDoubleOrNull(day,"feelslike"));
        weatherDailyData.setDew(getDoubleOrNull(day,"dew"));
        weatherDailyData.setHumidity(getDoubleOrNull(day,"humidity"));
        weatherDailyData.setPrecip(getDoubleOrNull(day,"precip"));
        weatherDailyData.setPrecipprob(getDoubleOrNull(day,"precipprob"));
        weatherDailyData.setPrecipCover(getDoubleOrNull(day,"precipcover"));

        if (day.isNull("preciptype"))
            weatherDailyData.setPreciptype(null);
        else {
            JSONArray precipTypes = day.getJSONArray("preciptype");
            ArrayList<String> typeList = new ArrayList<>();
            for (int j = 0; j < precipTypes.length(); j++) {
                typeList.add(precipTypes.getString(j));
            }
            weatherDailyData.setPreciptype(typeList);
        }

        weatherDailyData.setSnow(getDoubleOrNull(day,"snow"));
        weatherDailyData.setSnowdepth(getDoubleOrNull(day,"snowdepth"));
        weatherDailyData.setWindgust(getDoubleOrNull(day,"windgust"));
        weatherDailyData.setWindSpeed(getDoubleOrNull(day,"windspeed"));
        weatherDailyData.setWinddir(getDoubleOrNull(day,"winddir"));
        weatherDailyData.setPressure(getDoubleOrNull(day,"pressure"));
        weatherDailyData.setCloudCover(getDoubleOrNull(day,"cloudcover"));
        weatherDailyData.setVisibility(getDoubleOrNull(day,"visibility"));
        weatherDailyData.setSolarRadiation(getDoubleOrNull(day,"solarradiation"));
        weatherDailyData.setSolarEnergy(getDoubleOrNull(day,"solarenergy"));
        weatherDailyData.setUvIndex(getDoubleOrNull(day,"uvindex"));
        weatherDailyData.setSunRise(getStringOrNull(day,"sunrise"));
        weatherDailyData.setSunRiseEpoch(getLongOrNull(day,"sunriseEpoch"));
        weatherDailyData.setSunSet(getStringOrNull(day,"sunset"));
        weatherDailyData.setSunSetEpoch(getLongOrNull(day,"sunsetEpoch"));
        weatherDailyData.setMoonPhase(getDoubleOrNull(day,"moonphase"));
        weatherDailyData.setConditions(getStringOrNull(day,"conditions"));
        weatherDailyData.setDescription(getStringOrNull(day,"description"));
        weatherDailyData.setIcon(getStringOrNull(day,"icon"));

        if (day.isNull("stations"))
            weatherDailyData.setStations(null);
        else {
            JSONArray stations = day.getJSONArray("stations");
            ArrayList<String> stationList = new ArrayList<>();
            for (int j = 0; j < stations.length(); j++) {
                stationList.add(stations.getString(j));
            }
            weatherDailyData.setStations(stationList);
        }

        weatherDailyData.setSource(getStringOrNull(day,"source"));

        if (day.isNull("hours"))
            weatherDailyData.setHourlyData(null);
        else{
            JSONArray hours = day.getJSONArray("hours");
            weatherDailyData.setHourlyData(new ArrayList<>());

            for (int j = 0; j < hours.length(); j++) {
                JSONObject hour = hours.getJSONObject(j);
                WeatherHourlyData weatherHourlyData = weatherDailyData.createHourlyData(hour);
                weatherDailyData.getHourlyData().add(weatherHourlyData);
            }
        }
        return weatherDailyData;
    }

    public Long getQueryCost() { return queryCost; }

    public void setQueryCost(Long queryCost) { this.queryCost = queryCost; }

    public Double getLatitude() { return latitude; }

    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }

    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public String getResolvedAddress() { return resolvedAddress; }

    public void setResolvedAddress(String resolvedAddress) { this.resolvedAddress = resolvedAddress; }

    public String getAddress() { return address; }

    public void setAddress(String address) { this.address = address; }

    public String getTimezone() { return timezone; }

    public void setTimezone(String timezone) { this.timezone = timezone; }

    public Double getTzoffset() { return tzoffset; }

    public void setTzoffset(Double tzoffset) { this.tzoffset = tzoffset; }
}
