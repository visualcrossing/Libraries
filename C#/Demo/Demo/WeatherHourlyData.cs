using System;
using System.Collections.Generic;

namespace Library
{
    /**
     * The WeatherHourlyData class represents hourly weather data. It encapsulates all relevant meteorological details
     * temperature, feelslike, humidity, dew, precip, precippprob, snow, snowdepth, preciptype, windgust, windspeed, winddir,
     * pressure, visibility, cloudcover, solarradiation, solarenergy, uvindex, conditions, icon, stations, and source for a specific hour.
     */
    public class WeatherHourlyData
    {
        private TimeSpan datetime;
        private long? datetimeEpoch;
        private double? temp;
        private double? feelslike;
        private double? humidity;
        private double? dew;
        private double? precip;
        private double? precipprob;
        private double? snow;
        private double? snowdepth;
        private List<string> preciptype;
        private double? windgust;
        private double? windspeed;
        private double? winddir;
        private double? pressure;
        private double? visibility;
        private double? cloudcover;
        private double? solarradiation;
        private double? solarenergy;
        private double? uvindex;
        private string conditions;
        private string icon;
        private List<string> stations;
        private string source;

        // Constructor
        public WeatherHourlyData()
        {
            preciptype = new List<string>();
            stations = new List<string>();
        }

        // Getters and setters
        public TimeSpan Datetime { get => datetime; set => datetime = value; }

        public void SetDatetime(string datetime)
        {
            this.datetime = string.IsNullOrEmpty(datetime) ? TimeSpan.Zero : TimeSpan.Parse(datetime);
        }

        public long? DatetimeEpoch { get => datetimeEpoch; set => datetimeEpoch = value; }
        public double? Temp { get => temp; set => temp = value; }
        public double? FeelsLike { get => feelslike; set => feelslike = value; }
        public double? Humidity { get => humidity; set => humidity = value; }
        public double? Dew { get => dew; set => dew = value; }
        public double? Precip { get => precip; set => precip = value; }
        public double? PrecipProb { get => precipprob; set => precipprob = value; }
        public double? Snow { get => snow; set => snow = value; }
        public double? SnowDepth { get => snowdepth; set => snowdepth = value; }
        public List<string> PrecipType { get => preciptype; set => preciptype = value; }
        public double? WindGust { get => windgust; set => windgust = value; }
        public double? WindSpeed { get => windspeed; set => windspeed = value; }
        public double? WindDir { get => winddir; set => winddir = value; }
        public double? Pressure { get => pressure; set => pressure = value; }
        public double? Visibility { get => visibility; set => visibility = value; }
        public double? CloudCover { get => cloudcover; set => cloudcover = value; }
        public double? SolarRadiation { get => solarradiation; set => solarradiation = value; }
        public double? SolarEnergy { get => solarenergy; set => solarenergy = value; }
        public double? UvIndex { get => uvindex; set => uvindex = value; }
        public string Conditions { get => conditions; set => conditions = value; }
        public string Icon { get => icon; set => icon = value; }
        public List<string> Stations { get => stations; set => stations = value; }
        public string Source { get => source; set => source = value; }
    }
}
