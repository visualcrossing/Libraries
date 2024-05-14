import java.util.ArrayList;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class Demo {
    public static void main(String[] args) {

        // create weather API object with API key
        WeatherData weatherData = new WeatherData("YOUR_API_KEY");

        // fetch weather data with location, from date, to date params.

        weatherData.fetchWeatherData("38.96%2C-96.02","2020-7-10","2020-7-12","us","events","");

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
                if (weatherHourlyData != null) {
                    for (WeatherHourlyData hourlyData : weatherHourlyData) {
                        // print temperature
                        System.out.println(hourlyData.getDatetime() + "," + hourlyData.getTemp());

                        // print humidity
                        System.out.println(hourlyData.getDatetime() + "," + hourlyData.getHumidity());
                    }
                }

                ArrayList<Event> events = dailyData.getEvents();
                if (events != null) {
                    for (Event event : events) {
                        System.out.println(event.getDatetime() + "," + event.getDatetimeEpoch());
                    }
                }
            }
        }


        // set API_KEY
        weatherData.setAPI_KEY("YOUR_API_KEY");

        // fetch weather data for a specific datetime
        weatherData.fetchWeatherData("K2A1W1","2021-10-19");

        // get daily weather data object
        ArrayList<WeatherDailyData> weatherDailyData1 = weatherData.getWeatherDailyData();

        if (weatherDailyData1 != null) {
            for (WeatherDailyData dailyData : weatherDailyData1) {
                // print temperature
                System.out.println(dailyData.getDatetime() + "," + dailyData.getTempMax());
            }
        }

        // fetch forecast (15 days) weather data for the location
        weatherData.fetchForecastData("K2A1W1");

        // get daily weather data array list
        ArrayList<WeatherDailyData> weatherDailyData2 = weatherData.getWeatherDailyData();

        if (weatherDailyData2 != null){
            for (WeatherDailyData dailyData : weatherDailyData2) {
                // print temperature
                System.out.println(dailyData.getDatetime() + "," + dailyData.getTempMax());
            }
        }

        WeatherData weatherData1 = new WeatherData();
        weatherData1.setAPI_KEY("YOUR_API_KEY");
    }
}