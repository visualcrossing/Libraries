using System;
using System.Collections.Generic;

namespace Library
{
    /**
     * The WeatherDailyData class represents hourly weather data. It encapsulates all relevant meteorological details
     * temperature, max temperature, min temperature, max feelslike, min feelslike, feelslike, humidity, dew, precip, precippprob,
     * precipcover, preciptype, snow, snowdepth, preciptype, windgust, windspeed, winddir, pressure, visibility, cloudcover,
     * solarradiation, solarenergy, uvindex, sunrise, sunriseEpoch, sunset, sunsetEpoch, moonphase, conditions
     * description,icon, stations, and source for a specific date.
     */
    public class WeatherDailyData
    {
        private DateTime datetime;
        private long? datetimeEpoch;
        private double? tempmax;
        private double? tempmin;
        private double? temp;
        private double? feelslikemax;
        private double? feelslikemin;
        private double? feelslike;
        private double? dew;
        private double? humidity;
        private double? precip;
        private double? precipprob;
        private double? precipcover;
        private List<string> preciptype;
        private double? snow;
        private double? snowdepth;
        private double? windgust;
        private double? windspeed;
        private double? winddir;
        private double? pressure;
        private double? cloudcover;
        private double? visibility;
        private double? solarradiation;
        private double? solarenergy;
        private double? uvindex;
        private string sunrise;
        private long? sunriseEpoch;
        private string sunset;
        private long? sunsetEpoch;
        private double? moonphase;
        private string conditions;
        private string description;
        private string icon;
        private List<string> stations;
        private string source;
        private List<Event> events;
        private List<WeatherHourlyData> weatherHourlyData;

        // Constructors
        public WeatherDailyData()
        {
            this.preciptype = new List<string>();
            this.stations = new List<string>();
            this.events = new List<Event>();
            this.weatherHourlyData = new List<WeatherHourlyData>();
        }

        // Getters and setters for each property
        public DateTime Datetime { get => datetime; set => datetime = value; }
        public long? DatetimeEpoch { get => datetimeEpoch; set => datetimeEpoch = value; }
        public double? TempMax { get => tempmax; set => tempmax = value; }
        public double? TempMin { get => tempmin; set => tempmin = value; }
        public double? Temp { get => temp; set => temp = value; }
        public double? FeelsLikeMax { get => feelslikemax; set => feelslikemax = value; }
        public double? FeelsLikeMin { get => feelslikemin; set => feelslikemin = value; }
        public double? FeelsLike { get => feelslike; set => feelslike = value; }
        public double? Dew { get => dew; set => dew = value; }
        public double? Humidity { get => humidity; set => humidity = value; }
        public double? Precip { get => precip; set => precip = value; }
        public double? PrecipProb { get => precipprob; set => precipprob = value; }
        public double? PrecipCover { get => precipcover; set => precipcover = value; }
        public List<string> PrecipType { get => preciptype; set => preciptype = value; }
        public double? Snow { get => snow; set => snow = value; }
        public double? SnowDepth { get => snowdepth; set => snowdepth = value; }
        public double? WindGust { get => windgust; set => windgust = value; }
        public double? WindSpeed { get => windspeed; set => windspeed = value; }
        public double? WindDir { get => winddir; set => winddir = value; }
        public double? Pressure { get => pressure; set => pressure = value; }
        public double? CloudCover { get => cloudcover; set => cloudcover = value; }
        public double? Visibility { get => visibility; set => visibility = value; }
        public double? SolarRadiation { get => solarradiation; set => solarradiation = value; }
        public double? SolarEnergy { get => solarenergy; set => solarenergy = value; }
        public double? UvIndex { get => uvindex; set => uvindex = value; }
        public string Sunrise { get => sunrise; set => sunrise = value; }
        public long? SunriseEpoch { get => sunriseEpoch; set => sunriseEpoch = value; }
        public string Sunset { get => sunset; set => sunset = value; }
        public long? SunsetEpoch { get => sunsetEpoch; set => sunsetEpoch = value; }
        public double? MoonPhase { get => moonphase; set => moonphase = value; }
        public string Conditions { get => conditions; set => conditions = value; }
        public string Description { get => description; set => description = value; }
        public string Icon { get => icon; set => icon = value; }
        public List<string> Stations { get => stations; set => stations = value; }
        public string Source { get => source; set => source = value; }
        public List<Event> Events { get => events; set => events = value; }
        public List<WeatherHourlyData> WeatherHourlyData { get => weatherHourlyData; set => weatherHourlyData = value; }
    }
}
