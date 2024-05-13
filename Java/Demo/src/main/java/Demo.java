import java.util.ArrayList;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Demo {
    public static void main(String[] args) {

        // create weather API object with API key
        WeatherAPI weatherAPI = new WeatherAPI("YOUR_API_KEY");

        // fetch weather data with location, from date, to date params.
        weatherAPI.fetchWeatherData("K2A1W1","2021-10-19","2021-11-19");

        // get weather data object
        WeatherData weatherData = weatherAPI.getWeatherData();

        // get daily weather data array list
        ArrayList<WeatherDailyData> weatherDailyData = weatherData.getWeatherDailyData();

        if (weatherDailyData != null) {
            for (WeatherDailyData dailyData : weatherDailyData) {
                // print max temperature
                System.out.println(dailyData.getDatetime() + "," + dailyData.getTempMax());

                // print min temperature
                System.out.println(dailyData.getDatetime() + "," + dailyData.getTempMin());

                // print humidity
                System.out.println(dailyData.getDatetime() + "," + dailyData.getHumidity());

                // get hourly weather data array list
                ArrayList<WeatherHourlyData> weatherHourlyData = dailyData.getHourlyData();
                for (WeatherHourlyData hourlyData : weatherHourlyData) {
                    // print temperature
                    System.out.println(hourlyData.getDatetime() + "," + hourlyData.getTemp());

                    // print humidity
                    System.out.println(hourlyData.getDatetime() + "," + hourlyData.getHumidity());
                }
            }
        }

        // set API_KEY
        weatherAPI.setAPI_KEY("YOUR_API_KEY");

        // fetch weather data for a specific datetime
        weatherAPI.fetchWeatherData("K2A1W1","2021-10-19");

        // get weather data object
        weatherData = weatherAPI.getWeatherData();
        ArrayList<WeatherDailyData> weatherDailyData1 = weatherData.getWeatherDailyData();

        if (weatherDailyData1 != null) {
            for (WeatherDailyData dailyData : weatherDailyData1) {
                // print temperature
                System.out.println(dailyData.getDatetime() + "," + dailyData.getTempMax());
            }
        }

        // fetch forecast (15 days) weather data for the location
        weatherAPI.fetchForecastData("K2A1W1");

        // get weather data object
        weatherData = weatherAPI.getWeatherData();

        // get daily weather data array list
        ArrayList<WeatherDailyData> weatherDailyData2 = weatherData.getWeatherDailyData();

        if (weatherDailyData2 != null){
            for (WeatherDailyData dailyData : weatherDailyData2) {
                // print temperature
                System.out.println(dailyData.getDatetime() + "," + dailyData.getTempMax());
            }
        }
    }
}