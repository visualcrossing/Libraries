
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * The WeatherAPI class is designed to interact with the Visual Crossing Weather API to fetch weather data for specific locations, dates, and times.
 * This class is equipped to handle various types of weather data requests, including current weather data, historical weather data, and weather forecasts.
 * The key functionalities of this class include constructing API requests, retrieving weather data, and parsing JSON responses to populate weather data models.

 * API_KEY: A private string variable that stores the API key required to authenticate requests to the Visual Crossing Weather API.
 * getWeatherData(): Returns the current instance of the WeatherData object, allowing access to the structured weather data stored within.
 * setAPI_KEY(String API_KEY) and getAPI_KEY(): Getters and setters for the API key, allowing it to be updated or retrieved after the instance has been created.
 * fetchWeatherData(String location, String from, String to): Public method to fetch weather data between specific dates for a given location. This is particularly useful for retrieving historical weather data or future forecasts within a defined range.
 * fetchWeatherData(String location, String datetime): Overloaded method to fetch weather data for a specific date and location. This is useful for getting precise weather conditions on particular days.
 * fetchForecastData(String location): Fetches the weather forecast for the next 15 days starting from midnight of the current day at the specified location. This method is ideal for applications requiring future weather predictions to plan activities or events.
 */
public class WeatherAPI {

    private String API_KEY;
    public static final String BASE_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/";

    private WeatherData weatherData;

    public WeatherAPI(String API_KEY) {
        this.API_KEY = API_KEY;
        weatherData = new WeatherData();
    }

    public WeatherData getWeatherData() {return weatherData;}

    public void setAPI_KEY(String API_KEY) { this.API_KEY = API_KEY;}

    public String getAPI_KEY() { return API_KEY;}

    /**
     * The fetchData function retrieves weather data by making an API request to the specified URL using the weather data API.
     * @param URL
     * @return
     */
    private String fetchData(String URL){
        HttpURLConnection connection = null;
         try {
             URL url = new URL(URL);
             connection = (HttpURLConnection) url.openConnection();
             connection.setRequestMethod("GET");
             connection.setRequestProperty("Authorization", "Bearer your_api_token_here");
             int responseCode = connection.getResponseCode();
             if (responseCode == HttpURLConnection.HTTP_OK) {
                 BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                 String inputLine;
                 StringBuilder response = new StringBuilder();
                 while ((inputLine = in.readLine()) != null) {
                     response.append(inputLine);
                 }
                 in.close();
                 return response.toString();
             } else {
                 System.out.println("Failed to fetch weather data using API.");
             }
         } catch (IOException e) {
             e.printStackTrace();
             return null;
         } finally {
             if (connection != null) {
                 connection.disconnect();
             }
         }
         return null;

    }

    /**
     * The handleWeatherDate function parse JSON structure from String.
     * @param jsonString
     */
    private void handleWeatherDate(String jsonString){
        try {
            JSONObject obj = new JSONObject(jsonString);

            weatherData.setQueryCost(obj.getLong("queryCost"));
            weatherData.setLatitude(obj.getDouble("latitude"));
            weatherData.setLongitude(obj.getDouble("longitude"));
            weatherData.setResolvedAddress(obj.getString("resolvedAddress"));
            weatherData.setAddress(obj.getString("address"));
            weatherData.setTimezone(obj.getString("timezone"));
            weatherData.setTzoffset(obj.getDouble("tzoffset"));
            weatherData.setWeatherDailyData(new ArrayList<>());
            JSONArray days = obj.getJSONArray("days");
            for (int i = 0; i < days.length(); i++) {
                JSONObject day = days.getJSONObject(i);
                WeatherDailyData weatherDayData = weatherData.createWeatherDailyData(day);
                weatherData.getWeatherDailyData().add(weatherDayData);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * The fetchWeatherData function will fetch weather data from first date to second date.
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
        // Construct the URL by appending the location and API key to the base URL
        String urlString = BASE_URL + location + "/" + from + "/" + to + "?key=" + API_KEY;

        // Fetch data from the API
        String jsonString = fetchData(urlString);

        // Process the JSON string containing the weather data
        if (jsonString == null)
            System.out.println("Can't fetch weather data with the location, from date, and to date");
        else
            handleWeatherDate(jsonString);
    }

    /**
     * The fetchWeatherData function will fetch weather data for a specific datetime.
     * @param location : String
     * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
     * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
     * consider our Multiple Location Timeline Weather API.
     * @param datetime : String
     * datetime param is the specific date for which to retrieve weather data.
     * All dates and times are in local time of the specified location and should be in the format yyyy-MM-dd.
     */
    public void fetchWeatherData(String location, String datetime) {
        // Construct the URL by appending the location and API key to the base URL
        String urlString = BASE_URL + location + "/" + datetime + "?key=" + API_KEY;

        // Fetch data from the API
        String jsonString = fetchData(urlString);

        // Process the JSON string containing the weather data
        if (jsonString == null)
            System.out.println("Can't fetch weather data with the location and datetime");
        else
            handleWeatherDate(jsonString);
    }

    /**
     * The fetchForecastData function will fetch the weather forecast for location for the next 15 days
     * starting at midnight at the start of the current day (local time of the requested location).
     * @param location: String
     * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
     * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
     * consider our Multiple Location Timeline Weather API.
     */
    public void fetchForecastData(String location) {
        // Construct the URL by appending the location and API key to the base URL
        String urlString = BASE_URL + location + "?key=" + API_KEY;

        // Fetch data from the API
        String jsonString = fetchData(urlString);

        // Process the JSON string containing the weather data
        if (jsonString == null)
            System.out.println("Can't fetch weather data with the location");
        else
            handleWeatherDate(jsonString);
    }

}
