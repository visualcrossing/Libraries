using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using Newtonsoft.Json.Linq;

namespace Library
{
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
    public class WeatherData
    {
        private string _apiKey;
        public static readonly string BASE_URL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/";

        private long? _queryCost;
        private double? _latitude;
        private double? _longitude;
        private string _resolvedAddress;
        private string _address;
        private string _timezone;
        private double? _tzOffset;
        private List<WeatherDailyData> _weatherDailyData;
        private Dictionary<string, Station> _stations;

        public WeatherData() { }

        public WeatherData(string apiKey)
        {
            this._apiKey = apiKey;
        }

        public string APIKey
        {
            get { return _apiKey; }
            set { _apiKey = value; }
        }

        public long? QueryCost
        {
            get { return _queryCost; }
            set { _queryCost = value; }
        }

        public double? Latitude
        {
            get { return _latitude; }
            set { _latitude = value; }
        }

        public double? Longitude
        {
            get { return _longitude; }
            set { _longitude = value; }
        }

        public string ResolvedAddress
        {
            get { return _resolvedAddress; }
            set { _resolvedAddress = value; }
        }

        public string Address
        {
            get { return _address; }
            set { _address = value; }
        }

        public string Timezone
        {
            get { return _timezone; }
            set { _timezone = value; }
        }

        public double? TZOffset
        {
            get { return _tzOffset; }
            set { _tzOffset = value; }
        }

        public List<WeatherDailyData> WeatherDailyData
        {
            get { return _weatherDailyData; }
            set { _weatherDailyData = value; }
        }

        public Dictionary<string, Station> Stations
        {
            get { return _stations; }
            set { _stations = value; }
        }

        private static string GetStringOrNull(JObject jObject, string key)
        {
            return jObject[key]?.ToString();
        }

        private static double? GetDoubleOrNull(JObject jObject, string key)
        {
            return jObject[key]?.Type == JTokenType.Null ? null : (double?)jObject[key];
        }

        private static long? GetLongOrNull(JObject jObject, string key)
        {
            return jObject[key]?.Type == JTokenType.Null ? null : (long?)jObject[key];
        }

        /**
         * The fetchData function retrieves weather data by making an API request to the specified URL using the weather data API.
         * @param URL
         * @return
        */
        private string FetchData(string url)
        {
            string result = null;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "GET";
            request.Headers["Authorization"] = "Bearer " + _apiKey;  // Adjust as per your auth method

            using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
            {
                if (response.StatusCode != HttpStatusCode.OK)
                    throw new ApplicationException("Error code: " + response.StatusCode);

                using (StreamReader reader = new StreamReader(response.GetResponseStream()))
                {
                    result = reader.ReadToEnd();
                }
            }

            return result;
        }

        private void ClearWeatherData()
        {
            if (_weatherDailyData != null)
            {
                foreach(var item in _weatherDailyData)
                {
                    item.WeatherHourlyData?.Clear();
                    item.Events?.Clear();
                }
            }
            _weatherDailyData?.Clear();

            _stations?.Clear();

        }

        /**
        * The handleWeatherDate function parse JSON structure from String.
        * @param jsonString
        */
        private void HandleWeatherData(string jsonString)
        {
            ClearWeatherData();
            JObject obj = JObject.Parse(jsonString);

            _queryCost = (long?)obj["queryCost"];
            _latitude = (double?)obj["latitude"];
            _longitude = (double?)obj["longitude"];
            _resolvedAddress = (string)obj["resolvedAddress"];
            _address = (string)obj["address"];
            _timezone = (string)obj["timezone"];
            _tzOffset = (double?)obj["tzoffset"];
            _weatherDailyData = new List<WeatherDailyData>();

            JArray days = (JArray)obj["days"];
            foreach (JObject day in days)
            {
                WeatherDailyData weatherDayData = CreateWeatherDailyData(day);
                _weatherDailyData.Add(weatherDayData);
            }

            JObject stationsJson = (JObject)obj["stations"];
            _stations = new Dictionary<string, Station>();
            foreach (var kvp in stationsJson)
            {
                JObject stationObj = (JObject)kvp.Value;

                Station station = new Station
                {
                    Distance = (double?)stationObj["distance"],
                    Latitude = (double?)stationObj["latitude"],
                    Longitude = (double?)stationObj["longitude"],
                    UseCount = (int?)stationObj["useCount"],
                    Id = (string)stationObj["id"],
                    Name = (string)stationObj["name"],
                    Quality = (int?)stationObj["quality"],
                    Contribution = (double?)stationObj["contribution"]
                };

                _stations[kvp.Key] = station;
            }
        }

        /**
         * The createWeatherDailyData function creates an hourly data object from a JSON object.
         * The function checks if a key in the JSON object is null and sets the corresponding property to null if it is.
         * Otherwise, it assigns the value from the JSON object to the property.
         */
        private WeatherDailyData CreateWeatherDailyData(JObject day)
        {
            WeatherDailyData weatherDailyData = new WeatherDailyData();

            // Access fields within each 'day' object
            weatherDailyData.Datetime = DateTime.Parse(day["datetime"].ToString());
            weatherDailyData.DatetimeEpoch = GetLongOrNull(day, "datetimeEpoch");
            weatherDailyData.TempMax = GetDoubleOrNull(day, "tempmax");
            weatherDailyData.TempMin = GetDoubleOrNull(day, "tempmin");
            weatherDailyData.Temp = GetDoubleOrNull(day, "temp");
            weatherDailyData.FeelsLikeMax = GetDoubleOrNull(day, "feelslikemax");
            weatherDailyData.FeelsLikeMin = GetDoubleOrNull(day, "feelslikemin");
            weatherDailyData.FeelsLike = GetDoubleOrNull(day, "feelslike");
            weatherDailyData.Dew = GetDoubleOrNull(day, "dew");
            weatherDailyData.Humidity = GetDoubleOrNull(day, "humidity");
            weatherDailyData.Precip = GetDoubleOrNull(day, "precip");
            weatherDailyData.PrecipProb = GetDoubleOrNull(day, "precipprob");
            weatherDailyData.PrecipCover = GetDoubleOrNull(day, "precipcover");

            if (day["preciptype"]?.Type == JTokenType.Null || day["preciptype"] == null)
                weatherDailyData.PrecipType = null;
            else
            {
                JArray precipTypes = (JArray)day["preciptype"];
                List<string> typeList = new List<string>();
                foreach (var type in precipTypes)
                    typeList.Add((string)type);
                weatherDailyData.PrecipType = typeList;
            }

            weatherDailyData.Snow = GetDoubleOrNull(day, "snow");
            weatherDailyData.SnowDepth = GetDoubleOrNull(day, "snowdepth");
            weatherDailyData.WindGust = GetDoubleOrNull(day, "windgust");
            weatherDailyData.WindSpeed = GetDoubleOrNull(day, "windspeed");
            weatherDailyData.WindDir = GetDoubleOrNull(day, "winddir");
            weatherDailyData.Pressure = GetDoubleOrNull(day, "pressure");
            weatherDailyData.CloudCover = GetDoubleOrNull(day, "cloudcover");
            weatherDailyData.Visibility = GetDoubleOrNull(day, "visibility");
            weatherDailyData.SolarRadiation = GetDoubleOrNull(day, "solarradiation");
            weatherDailyData.SolarEnergy = GetDoubleOrNull(day, "solarenergy");
            weatherDailyData.UvIndex = GetDoubleOrNull(day, "uvindex");
            weatherDailyData.Sunrise = GetStringOrNull(day, "sunrise");
            weatherDailyData.SunriseEpoch = GetLongOrNull(day, "sunriseEpoch");
            weatherDailyData.Sunset = GetStringOrNull(day, "sunset");
            weatherDailyData.SunsetEpoch = GetLongOrNull(day, "sunsetEpoch");
            weatherDailyData.MoonPhase = GetDoubleOrNull(day, "moonphase");
            weatherDailyData.Conditions = GetStringOrNull(day, "conditions");
            weatherDailyData.Description = GetStringOrNull(day, "description");
            weatherDailyData.Icon = GetStringOrNull(day, "icon");

            if (day["stations"]?.Type == JTokenType.Null || day["stations"] == null)
                weatherDailyData.Stations = null;
            else
            {
                JArray stations = (JArray)day["stations"];
                List<string> stationList = new List<string>();
                foreach (var station in stations)
                    stationList.Add((string)station);
                weatherDailyData.Stations = stationList;
            }

            if (day["events"]?.Type == JTokenType.Null || day["events"] == null)
                weatherDailyData.Events = null;
            else
            {
                JArray events = (JArray)day["events"];
                List<Event> eventList = new List<Event>();
                foreach (JObject eventObj in events)
                {
                    Event eventItem = new Event
                    {
                        Datetime = DateTime.Parse(eventObj["datetime"].ToString()),
                        DatetimeEpoch = GetLongOrNull(eventObj, "datetimeEpoch"),
                        Type = GetStringOrNull(eventObj, "type"),
                        Latitude = GetDoubleOrNull(eventObj, "latitude"),
                        Longitude = GetDoubleOrNull(eventObj, "longitude"),
                        Distance = GetDoubleOrNull(eventObj, "distance"),
                        Description = GetStringOrNull(eventObj, "description"),
                        Size = GetDoubleOrNull(eventObj, "size")
                    };
                    eventList.Add(eventItem);
                }
                weatherDailyData.Events = eventList;
            }

            if (day["hours"]?.Type == JTokenType.Null || day["hours"] == null)
                weatherDailyData.WeatherHourlyData = null;
            else
            {
                JArray hours = (JArray)day["hours"];
                List<WeatherHourlyData> hourlyDataList = new List<WeatherHourlyData>();
                foreach (JObject hour in hours)
                {
                    WeatherHourlyData hourlyData = CreateHourlyData(hour);
                    hourlyDataList.Add(hourlyData);
                }
                weatherDailyData.WeatherHourlyData = hourlyDataList;
            }

            weatherDailyData.Source = GetStringOrNull(day, "source");

            return weatherDailyData;
        }

        /**
         * The createHourlyData function creates an hourly data object from a JSON object.
         * The function checks if a key in the JSON object is null and sets the corresponding property to null if it is.
         * Otherwise, it assigns the value from the JSON object to the property.
        */
        private WeatherHourlyData CreateHourlyData(JObject hour)
        {
            WeatherHourlyData weatherHourlyData = new WeatherHourlyData();

            weatherHourlyData.Datetime = TimeSpan.Parse(hour["datetime"].ToString());
            weatherHourlyData.DatetimeEpoch = GetLongOrNull(hour, "datetimeEpoch");
            weatherHourlyData.Temp = GetDoubleOrNull(hour, "temp");
            weatherHourlyData.FeelsLike = GetDoubleOrNull(hour, "feelslike");
            weatherHourlyData.Humidity = GetDoubleOrNull(hour, "humidity");
            weatherHourlyData.Dew = GetDoubleOrNull(hour, "dew");
            weatherHourlyData.Precip = GetDoubleOrNull(hour, "precip");
            weatherHourlyData.PrecipProb = GetDoubleOrNull(hour, "precipprob");
            weatherHourlyData.Snow = GetDoubleOrNull(hour, "snow");
            weatherHourlyData.SnowDepth = GetDoubleOrNull(hour, "snowdepth");

            if (hour["preciptype"]?.Type == JTokenType.Null || hour["preciptype"] == null)
                weatherHourlyData.PrecipType = null;
            else
            {
                JArray precipTypes = (JArray)hour["preciptype"];
                List<string> typeList = new List<string>();
                foreach (var type in precipTypes)
                    typeList.Add((string)type);
                weatherHourlyData.PrecipType = typeList;
            }

            weatherHourlyData.WindGust = GetDoubleOrNull(hour, "windgust");
            weatherHourlyData.WindSpeed = GetDoubleOrNull(hour, "windspeed");
            weatherHourlyData.WindDir = GetDoubleOrNull(hour, "winddir");
            weatherHourlyData.Pressure = GetDoubleOrNull(hour, "pressure");
            weatherHourlyData.Visibility = GetDoubleOrNull(hour, "visibility");
            weatherHourlyData.CloudCover = GetDoubleOrNull(hour, "cloudcover");
            weatherHourlyData.SolarRadiation = GetDoubleOrNull(hour, "solarradiation");
            weatherHourlyData.SolarEnergy = GetDoubleOrNull(hour, "solarenergy");
            weatherHourlyData.UvIndex = GetDoubleOrNull(hour, "uvindex");
            weatherHourlyData.Conditions = GetStringOrNull(hour, "conditions");
            weatherHourlyData.Icon = GetStringOrNull(hour, "icon");

            if (hour["stations"]?.Type == JTokenType.Null || hour["stations"] == null)
                weatherHourlyData.Stations = null;
            else
            {
                JArray stations = (JArray)hour["stations"];
                List<string> stationList = new List<string>();
                foreach (var station in stations)
                    stationList.Add((string)station);
                weatherHourlyData.Stations = stationList;
            }

            weatherHourlyData.Source = GetStringOrNull(hour, "source");

            return weatherHourlyData;
        }

        /**
        * The fetchWeatherData function will fetch weather data from params.
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
        public void FetchWeatherData(string location, string from, string to, string unitGroup, string include, string elements)
        {
            try
            {
                // Check API
                if (string.IsNullOrEmpty(APIKey))
                    throw new InvalidOperationException("API key is not set.");

                // Construct the URL by appending the location and API key to the base URL
                string urlString = $"{BASE_URL}{location}/{from}/{to}?key={APIKey}&include={include}&elements={elements}&unitGroup={unitGroup}";

                // Fetch data from the API
                string jsonString = FetchData(urlString);

                HandleWeatherData(jsonString);
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
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
        public void FetchWeatherData(string location, string from, string to)
        {
            try
            {
                // Check API
                if (string.IsNullOrEmpty(APIKey))
                    throw new InvalidOperationException("API key is not set.");

                // Construct the URL by appending the location and API key to the base URL
                string urlString = $"{BASE_URL}{location}/{from}/{to}?key={APIKey}";

                // Fetch data from the API
                string jsonString = FetchData(urlString);
                

                // Process the JSON string containing the weather data
                HandleWeatherData(jsonString);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error fetching weather data: {e.Message}");
            }
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
        public void FetchWeatherData(string location, string datetime)
        {
            try
            {
                // Check API
                if (string.IsNullOrEmpty(APIKey))
                    throw new InvalidOperationException("API key is not set.");

                // Construct the URL by appending the location and API key to the base URL
                string urlString = $"{BASE_URL}{location}/{datetime}?key={APIKey}";

                // Fetch data from the API
                string jsonString = FetchData(urlString);

                // Process the JSON string containing the weather data
                HandleWeatherData(jsonString);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error fetching weather data: {e.Message}");
            }
        }

        /**
        * The fetchForecastData function will fetch the weather forecast for location for the next 15 days
        * starting at midnight at the start of the current day (local time of the requested location).
        * @param location: String
        * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
        * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
        * consider our Multiple Location Timeline Weather API.
        */
        public void FetchWeatherData(string location)
        {
            try
            {
                // Check API
                if (string.IsNullOrEmpty(APIKey))
                    throw new InvalidOperationException("API key is not set.");

                // Construct the URL by appending the location and API key to the base URL
                string urlString = $"{BASE_URL}{location}?key={APIKey}";

                // Fetch data from the API
                string jsonString = FetchData(urlString);

                // Process the JSON string containing the weather data
                HandleWeatherData(jsonString);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error fetching weather data: {e.Message}");
            }
        }

        /**
         * The fetchForecastData function will fetch the weather forecast for location for the next 15 days
         * starting at midnight at the start of the current day (local time of the requested location).
         * @param location: String
         * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
         * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
         * consider our Multiple Location Timeline Weather API.
         */
        public void FetchForecastData(String location)
        {
            try
            {
                // Check API
                if (string.IsNullOrEmpty(APIKey))
                    throw new InvalidOperationException("API key is not set.");

                // Construct the URL by appending the location and API key to the base URL
                string urlString = $"{BASE_URL}{location}?key={APIKey}";

                // Fetch data from the API
                string jsonString = FetchData(urlString);

                // Process the JSON string containing the weather data
                HandleWeatherData(jsonString);
            }
            catch (Exception e)
            {
                Console.WriteLine($"Error fetching weather data: {e.Message}");
            }
        }

    }
}
