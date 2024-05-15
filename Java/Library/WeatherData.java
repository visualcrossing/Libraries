import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

/**
 * The WeatherData class is designed to interact with the Visual Crossing Weather API to fetch weather data for specific locations, dates, and times.
 * This class is equipped to handle various types of weather data requests, including current weather data, historical weather data, and weather forecasts.
 * The key methodalities of this class include constructing API requests, retrieving weather data, and parsing JSON responses to populate weather data models.
 * API_KEY: A private string variable that stores the API key required to authenticate requests to the Visual Crossing Weather API.
 * setAPI_KEY(String API_KEY) and getAPI_KEY(): Getters and setters for the API key, allowing it to be updated or retrieved after the instance has been created.
 * fetchWeatherData(String location, String from, String to): Public method to fetch weather data between specific dates for a given location. This is particularly useful for retrieving historical weather data or future forecasts within a defined range.
 * fetchWeatherData(String location, String datetime): Overloaded method to fetch weather data for a specific date and location. This is useful for getting precise weather conditions on particular days.
 * fetchForecastData(String location): Fetches the weather forecast for the next 15 days starting from midnight of the current day at the specified location. This method is ideal for applications requiring future weather predictions to plan activities or events.
 * fetchWeatherData(String location, String from, String to, String UnitGroup, String include, String elements)
 */
public class WeatherData{
    private String API_KEY;
    public static final String BASE_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/";

    private Long queryCost;
    private Double latitude;
    private Double longitude;
    private String resolvedAddress;
    private String address;
    private String timezone;
    private Double tzoffset;
    private ArrayList<WeatherDailyData> weatherDailyData;
    private HashMap<String, Station> stations;

    public WeatherData(){}

    public WeatherData(String API_KEY) {
        this.API_KEY = API_KEY;
    }

    public void setAPI_KEY(String API_KEY) { this.API_KEY = API_KEY;}

    public String getAPI_KEY() { return API_KEY;}

    /**
     * The fetchData method retrieves weather data by making an API request to the specified URL using the weather data API.
     * @param URL
     * @return
     */
    private String fetchData(String URL) throws IOException {
        String result = null;
        HttpURLConnection connection = null;
        try {
            java.net.URL url = new URL(URL);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Authorization", "Bearer your_api_token_here");

            int responseCode = connection.getResponseCode();
            if (responseCode != HttpURLConnection.HTTP_OK) {
                throw new IOException("HTTP error code: " + responseCode);
            }

            try (BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
                String inputLine;
                StringBuilder response = new StringBuilder();
                while ((inputLine = in.readLine()) != null) {
                    response.append(inputLine);
                }
                result = response.toString();
                if (result == null)
                    throw new IOException("Can't fetch weather data");

                return result;
            }
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }
    private void clearWeatherData(){
        if (weatherDailyData == null) return;

        for (int i = 0;i < weatherDailyData.toArray().length;i++){
            ArrayList<WeatherHourlyData> weatherHourlyDataList = weatherDailyData.get(i).getHourlyData();
            ArrayList<Event> eventsList = weatherDailyData.get(i).getEvents();

            if (weatherHourlyDataList != null)
                weatherHourlyDataList.clear();

            if (eventsList != null)
                eventsList.clear();
        }
        if (stations != null)
            stations.clear();

        weatherDailyData.clear();
    }
    /**
     * The handleWeatherDate method parse JSON structure from String.
     * @param jsonString
     */
    private void handleWeatherDate(String jsonString){
        clearWeatherData();
        try {
            JSONObject obj = new JSONObject(jsonString);

            setQueryCost(obj.getLong("queryCost"));
            setLatitude(obj.getDouble("latitude"));
            setLongitude(obj.getDouble("longitude"));
            setResolvedAddress(obj.getString("resolvedAddress"));
            setAddress(obj.getString("address"));
            setTimezone(obj.getString("timezone"));
            setTzoffset(obj.getDouble("tzoffset"));
            setWeatherDailyData(new ArrayList<>());
            JSONArray days = obj.getJSONArray("days");
            for (int i = 0; i < days.length(); i++) {
                JSONObject day = days.getJSONObject(i);
                WeatherDailyData weatherDayData = createWeatherDailyData(day);
                getWeatherDailyData().add(weatherDayData);
            }

            JSONObject stations = obj.getJSONObject("stations");

            this.stations = new HashMap<>();
            // Iterate over each key in the "stations" object
            for (String key : stations.keySet()) {
                JSONObject stationObj = stations.getJSONObject(key);

                Station station = new Station();
                station.setDistance(getDoubleOrNull(stationObj,"distance"));
                station.setLatitude(getDoubleOrNull(stationObj,"latitude"));
                station.setLongitude(getDoubleOrNull(stationObj,"longitude"));
                station.setUseCount(getIntegerOrNull(stationObj,"useCount"));
                station.setId(getStringOrNull(stationObj,"id"));
                station.setName(getStringOrNull(stationObj,"name"));
                station.setQuality(getIntegerOrNull(stationObj,"quality"));
                station.setContribution(getDoubleOrNull(stationObj,"contribution"));

                this.stations.put(key, station);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * The fetchWeatherData method will fetch weather data from params.
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
    public void fetchWeatherData(String location, String from, String to, String UnitGroup, String include, String elements) {
        try{
            // Check API
            if (API_KEY == null || API_KEY.length() == 0) throw new Exception();

            // Construct the URL by appending the location and API key to the base URL
            String urlString = BASE_URL + location + "/" + from + "/" + to + "?key=" + API_KEY + "&include=" + include + "&elements=" + elements + "&unitGroup=" + UnitGroup; ;

            // Fetch data from the API
            String jsonString = fetchData(urlString);
            System.out.println(urlString);
            // Process the JSON string containing the weather data
            handleWeatherDate(jsonString);
        }catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * The fetchWeatherData method will fetch weather data from first date to second date.
     * @param location : String
     * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
     * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
     * consider our Multiple Location Timeline Weather API.
     * @param from     : String
     * from param is the start date for which to retrieve weather data. Dates should be in the format yyyy-MM-dd.
     * For example 2020-10-19 for October 19th, 2020 or 2017-02-03 for February 3rd, 2017.
     * @param to       : String
     * to param is the end date for which to retrieve weather data.
     * All dates and times are in local time of the specified location and should be in the format yyyy-MM-dd.
     */
    public void fetchWeatherData(String location, String from, String to) {
        try{
            // Check API
            if (API_KEY == null || API_KEY.length() == 0) throw new Exception();

            // Construct the URL by appending the location and API key to the base URL
            String urlString = BASE_URL + location + "/" + from + "/" + to + "?key=" + API_KEY;

            // Fetch data from the API
            String jsonString = fetchData(urlString);

            // Process the JSON string containing the weather data
            handleWeatherDate(jsonString);
        }catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * The fetchWeatherData method will fetch weather data for a specific datetime.
     * @param location : String
     * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
     * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
     * consider our Multiple Location Timeline Weather API.
     * @param datetime : String
     * datetime param is the specific date for which to retrieve weather data.
     * All dates and times are in local time of the specified location and should be in the format yyyy-MM-dd.
     */
    public void fetchWeatherData(String location, String datetime) {
        try {
            // Check API
            if (API_KEY == null || API_KEY.length() == 0) throw new Exception();

            // Construct the URL by appending the location and API key to the base URL
            String urlString = BASE_URL + location + "/" + datetime + "?key=" + API_KEY;

            // Fetch data from the API
            String jsonString = fetchData(urlString);

            // Process the JSON string containing the weather data
            handleWeatherDate(jsonString);
        }catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * The fetchForecastData method will fetch the weather forecast for location for the next 15 days
     * starting at midnight at the start of the current day (local time of the requested location).
     * @param location: String
     * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
     * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
     * consider our Multiple Location Timeline Weather API.
     */
    public void fetchForecastData(String location) {
        try {
            // Check API
            if (API_KEY == null || API_KEY.length() == 0) throw new Exception();

            // Construct the URL by appending the location and API key to the base URL
            String urlString = BASE_URL + location + "?key=" + API_KEY;

            // Fetch data from the API
            String jsonString = fetchData(urlString);

            // Process the JSON string containing the weather data
            handleWeatherDate(jsonString);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public void setWeatherDailyData(ArrayList<WeatherDailyData> weatherDailyData) { this.weatherDailyData = weatherDailyData; }

    public ArrayList<WeatherDailyData> getWeatherDailyData() { return weatherDailyData; }

    public WeatherDailyData getWeatherDataByDay(LocalDate day){
        for(WeatherDailyData weatherDailyData : weatherDailyData){
            if (weatherDailyData.getDatetime() == day)
                return weatherDailyData;
        }
        return null;
    }

    public WeatherDailyData getWeatherDataByDay(int index){
        return weatherDailyData.get(index);
    }

    private Integer getIntegerOrNull(JSONObject day, String key){
        return day.isNull(key) ? null : day.getInt(key);
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
     * The createWeatherDailyData method creates an hourly data object from a JSON object.
     * The method checks if a key in the JSON object is null and sets the corresponding property to null if it is.
     * Otherwise, it assigns the value from the JSON object to the property.
     */
    private WeatherDailyData createWeatherDailyData(JSONObject day) {
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

        if (day.isNull("events"))
            weatherDailyData.setEvents(null);
        else{
            JSONArray events = day.getJSONArray("events");
            ArrayList<Event> eventList = new ArrayList<>();

            for (int j = 0; j < events.length(); j++) {
                JSONObject event = events.getJSONObject(j);
                Event eventObj = new Event();
                eventObj.setDatetime(LocalDateTime.parse(Objects.requireNonNull(getStringOrNull(event, "datetime"))));
                eventObj.setDatetimeEpoch(getLongOrNull(event,"datetimeEpoch"));
                eventObj.setType(getStringOrNull(event,"type"));
                eventObj.setLatitude(getDoubleOrNull(event,"latitude"));
                eventObj.setLongitude(getDoubleOrNull(event,"longitude"));
                eventObj.setDistance(getDoubleOrNull(event,"distance"));
                eventObj.setDescription(getStringOrNull(event,"description"));
                eventObj.setSize(getDoubleOrNull(event,"size"));

                eventList.add(eventObj);
            }
            weatherDailyData.setEvents(eventList);
        }

        weatherDailyData.setSource(getStringOrNull(day,"source"));

        if (day.isNull("hours"))
            weatherDailyData.setHourlyData(null);
        else{
            JSONArray hours = day.getJSONArray("hours");
            weatherDailyData.setHourlyData(new ArrayList<>());

            for (int j = 0; j < hours.length(); j++) {
                JSONObject hour = hours.getJSONObject(j);
                WeatherHourlyData weatherHourlyData = createHourlyData(hour);
                weatherDailyData.getHourlyData().add(weatherHourlyData);
            }
        }
        return weatherDailyData;
    }

    /**
     * The createHourlyData method creates an hourly data object from a JSON object.
     * The method checks if a key in the JSON object is null and sets the corresponding property to null if it is.
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

    public HashMap<String, Station> getStations() { return stations; }
    public void setStations(HashMap<String, Station> stations) { this.stations = stations; }
}
