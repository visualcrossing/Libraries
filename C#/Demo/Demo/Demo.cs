using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Library;

namespace Demo
{
    internal class Demo
    {
        static void Main(string[] args)
        {

            // create weather API object with API key
            WeatherData weatherData = new WeatherData("YOUR_API_KEY");

            // fetch weather data with location, from date, to date params.

            weatherData.FetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events", "");

            //  daily weather data array list
            List<WeatherDailyData> weatherDailyData = weatherData.WeatherDailyData;

            if (weatherDailyData != null)
            {
                foreach (WeatherDailyData dailyData in weatherDailyData)
                {
                    // print max temperature
                    Console.WriteLine($"{dailyData.Datetime}, {dailyData.TempMax}");

                    // print min temperature
                    Console.WriteLine($"{dailyData.Datetime}, {dailyData.TempMin}");

                    // print humidity
                    Console.WriteLine($"{dailyData.Datetime}, {dailyData.Humidity}");

                    // hourly weather data array list
                    List<WeatherHourlyData> weatherHourlyData = dailyData.WeatherHourlyData;
                    if (weatherHourlyData != null)
                    {
                        foreach (WeatherHourlyData hourlyData in weatherHourlyData)
                        {
                            // print temperature
                            Console.WriteLine($"{hourlyData.Datetime}, {hourlyData.Temp}");

                            // print humidity
                            Console.WriteLine($"{hourlyData.Datetime}, {hourlyData.Humidity}");
                        }
                    }

                    List<Event> events = dailyData.Events;
                    if (events != null)
                    {
                        foreach (Event eventObj in events)
                        {
                            Console.WriteLine($"{eventObj.Datetime}, {eventObj.DatetimeEpoch}");
                        }
                    }
                }
            }


            Dictionary<string, Station> stations = weatherData.Stations;
            if (stations != null)
            {
                foreach (var item in stations)
                {
                    Station station = item.Value;
                    Console.WriteLine($"{item.Key}, {station.Name}");
                    Console.WriteLine($"{item.Key}, {station.Id}");
                    Console.WriteLine($"{item.Key}, {station.UseCount}");
                }
            }


            // Initialize WeatherData object
            WeatherData weatherData1 = new WeatherData();

            // Set API_KEY
            weatherData1.APIKey = "YOUR_API_KEY";

            // Fetch weather data for a specific datetime
            weatherData1.FetchWeatherData("K2A1W1", "2021-10-19");

            // Daily weather data object
            List<WeatherDailyData> weatherDailyData1 = weatherData1.WeatherDailyData;

            if (weatherDailyData1 != null)
            {
                foreach (WeatherDailyData dailyData in weatherDailyData1)
                {
                    // Print temperature
                    Console.WriteLine($"{dailyData.Datetime}, {dailyData.TempMax}");
                }
            }

            // Fetch forecast (15 days) weather data for the location
            weatherData1.FetchForecastData("K2A1W1");

            // Daily weather data list
            List<WeatherDailyData> weatherDailyData2 = weatherData.WeatherDailyData;

            if (weatherDailyData2 != null)
            {
                foreach (WeatherDailyData dailyData in weatherDailyData2)
                {
                    // Print temperature
                    Console.WriteLine($"{dailyData.Datetime}, {dailyData.TempMax}");
                }
            }

            // Create another instance of WeatherData
            WeatherData weatherData2 = new WeatherData();
            weatherData2.APIKey = "YOUR_API_KEY";

        }
    }
}
