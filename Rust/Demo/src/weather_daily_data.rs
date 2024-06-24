use chrono::{NaiveDate, NaiveDateTime};

use std::option::Option;

use crate::weather_hourly_data::WeatherHourlyData;
use crate::event::Event;

pub struct WeatherDailyData {
    datetime: Option<NaiveDate>,
    datetime_epoch: Option<u64>,
    temp_max: Option<f64>,
    temp_min: Option<f64>,
    temp: Option<f64>,
    feels_like_max: Option<f64>,
    feels_like_min: Option<f64>,
    feels_like: Option<f64>,
    dew: Option<f64>,
    humidity: Option<f64>,
    precip: Option<f64>,
    precip_prob: Option<f64>,
    precip_cover: Option<f64>,
    precip_type: Option<Vec<String>>,
    snow: Option<f64>,
    snow_depth: Option<f64>,
    wind_gust: Option<f64>,
    wind_speed: Option<f64>,
    wind_dir: Option<f64>,
    pressure: Option<f64>,
    cloud_cover: Option<f64>,
    visibility: Option<f64>,
    solar_radiation: Option<f64>,
    solar_energy: Option<f64>,
    uv_index: Option<f64>,
    sunrise: Option<String>,
    sunrise_epoch: Option<u64>,
    sunset: Option<String>,
    sunset_epoch: Option<u64>,
    moon_phase: Option<f64>,
    conditions: Option<String>,
    description: Option<String>,
    icon: Option<String>,
    stations: Option<Vec<String>>,
    source: Option<String>,
    events: Option<Vec<Event>>,
    weather_hourly_data: Option<Vec<WeatherHourlyData>>,
}

impl WeatherDailyData {
    pub fn new() -> WeatherDailyData {
        WeatherDailyData {
            datetime: None,
            datetime_epoch: None,
            temp_max: None,
            temp_min: None,
            temp: None,
            feels_like_max: None,
            feels_like_min: None,
            feels_like: None,
            dew: None,
            humidity: None,
            precip: None,
            precip_prob: None,
            precip_cover: None,
            precip_type: None,
            snow: None,
            snow_depth: None,
            wind_gust: None,
            wind_speed: None,
            wind_dir: None,
            pressure: None,
            cloud_cover: None,
            visibility: None,
            solar_radiation: None,
            solar_energy: None,
            uv_index: None,
            sunrise: None,
            sunrise_epoch: None,
            sunset: None,
            sunset_epoch: None,
            moon_phase: None,
            conditions: None,
            description: None,
            icon: None,
            stations: None,
            source: None,
            events: None,
            weather_hourly_data: None,
        }
    }

    // Getters and setters
    pub fn datetime(&self) -> Option<NaiveDate> {
        self.datetime
    }

    pub fn set_datetime(&mut self, datetime: Option<NaiveDate>) {
        self.datetime = datetime;
    }

    pub fn datetime_epoch(&self) -> Option<u64> {
        self.datetime_epoch
    }

    pub fn set_datetime_epoch(&mut self, datetime_epoch: Option<u64>) {
        self.datetime_epoch = datetime_epoch;
    }

    pub fn temp_max(&self) -> Option<f64> {
        self.temp_max
    }

    pub fn set_temp_max(&mut self, temp_max: Option<f64>) {
        self.temp_max = temp_max;
    }

    pub fn temp_min(&self) -> Option<f64> {
        self.temp_min
    }

    pub fn set_temp_min(&mut self, temp_min: Option<f64>) {
        self.temp_min = temp_min;
    }

    pub fn temp(&self) -> Option<f64> {
        self.temp
    }

    pub fn set_temp(&mut self, temp: Option<f64>) {
        self.temp = temp;
    }

    pub fn feels_like_max(&self) -> Option<f64> {
        self.feels_like_max
    }

    pub fn set_feels_like_max(&mut self, feels_like_max: Option<f64>) {
        self.feels_like_max = feels_like_max;
    }

    pub fn feels_like_min(&self) -> Option<f64> {
        self.feels_like_min
    }

    pub fn set_feels_like_min(&mut self, feels_like_min: Option<f64>) {
        self.feels_like_min = feels_like_min;
    }

    pub fn feels_like(&self) -> Option<f64> {
        self.feels_like
    }

    pub fn set_feels_like(&mut self, feels_like: Option<f64>) {
        self.feels_like = feels_like;
    }

    pub fn dew(&self) -> Option<f64> {
        self.dew
    }

    pub fn set_dew(&mut self, dew: Option<f64>) {
        self.dew = dew;
    }

    pub fn humidity(&self) -> Option<f64> {
        self.humidity
    }

    pub fn set_humidity(&mut self, humidity: Option<f64>) {
        self.humidity = humidity;
    }

    pub fn precip(&self) -> Option<f64> {
        self.precip
    }

    pub fn set_precip(&mut self, precip: Option<f64>) {
        self.precip = precip;
    }

    pub fn precip_prob(&self) -> Option<f64> {
        self.precip_prob
    }

    pub fn set_precip_prob(&mut self, precip_prob: Option<f64>) {
        self.precip_prob = precip_prob;
    }

    pub fn precip_cover(&self) -> Option<f64> {
        self.precip_cover
    }

    pub fn set_precip_cover(&mut self, precip_cover: Option<f64>) {
        self.precip_cover = precip_cover;
    }

    pub fn precip_type(&self) -> &Option<Vec<String>> {
        &self.precip_type
    }

    pub fn set_precip_type(&mut self, precip_type: Option<Vec<String>>) {
        self.precip_type = precip_type;
    }

    pub fn snow(&self) -> Option<f64> {
        self.snow
    }

    pub fn set_snow(&mut self, snow: Option<f64>) {
        self.snow = snow;
    }

    pub fn snow_depth(&self) -> Option<f64> {
        self.snow_depth
    }

    pub fn set_snow_depth(&mut self, snow_depth: Option<f64>) {
        self.snow_depth = snow_depth;
    }

    pub fn wind_gust(&self) -> Option<f64> {
        self.wind_gust
    }

    pub fn set_wind_gust(&mut self, wind_gust: Option<f64>) {
        self.wind_gust = wind_gust;
    }

    pub fn wind_speed(&self) -> Option<f64> {
        self.wind_speed
    }

    pub fn set_wind_speed(&mut self, wind_speed: Option<f64>) {
        self.wind_speed = wind_speed;
    }

    pub fn wind_dir(&self) -> Option<f64> {
        self.wind_dir
    }

    pub fn set_wind_dir(&mut self, wind_dir: Option<f64>) {
        self.wind_dir = wind_dir;
    }

    pub fn pressure(&self) -> Option<f64> {
        self.pressure
    }

    pub fn set_pressure(&mut self, pressure: Option<f64>) {
        self.pressure = pressure;
    }

    pub fn cloud_cover(&self) -> Option<f64> {
        self.cloud_cover
    }

    pub fn set_cloud_cover(&mut self, cloud_cover: Option<f64>) {
        self.cloud_cover = cloud_cover;
    }

    pub fn visibility(&self) -> Option<f64> {
        self.visibility
    }

    pub fn set_visibility(&mut self, visibility: Option<f64>) {
        self.visibility = visibility;
    }

    pub fn solar_radiation(&self) -> Option<f64> {
        self.solar_radiation
    }

    pub fn set_solar_radiation(&mut self, solar_radiation: Option<f64>) {
        self.solar_radiation = solar_radiation;
    }

    pub fn solar_energy(&self) -> Option<f64> {
        self.solar_energy
    }

    pub fn set_solar_energy(&mut self, solar_energy: Option<f64>) {
        self.solar_energy = solar_energy;
    }

    pub fn uv_index(&self) -> Option<f64> {
        self.uv_index
    }

    pub fn set_uv_index(&mut self, uv_index: Option<f64>) {
        self.uv_index = uv_index;
    }

    pub fn sunrise(&self) -> &Option<String> {
        &self.sunrise
    }

    pub fn set_sunrise(&mut self, sunrise: Option<String>) {
        self.sunrise = sunrise;
    }

    pub fn sunrise_epoch(&self) -> Option<u64> {
        self.sunrise_epoch
    }

    pub fn set_sunrise_epoch(&mut self, sunrise_epoch: Option<u64>) {
        self.sunrise_epoch = sunrise_epoch;
    }

    pub fn sunset(&self) -> &Option<String> {
        &self.sunset
    }

    pub fn set_sunset(&mut self, sunset: Option<String>) {
        self.sunset = sunset;
    }

    pub fn sunset_epoch(&self) -> Option<u64> {
        self.sunset_epoch
    }

    pub fn set_sunset_epoch(&mut self, sunset_epoch: Option<u64>) {
        self.sunset_epoch = sunset_epoch;
    }

    pub fn moon_phase(&self) -> Option<f64> {
        self.moon_phase
    }

    pub fn set_moon_phase(&mut self, moon_phase: Option<f64>) {
        self.moon_phase = moon_phase;
    }

    pub fn conditions(&self) -> &Option<String> {
        &self.conditions
    }

    pub fn set_conditions(&mut self, conditions: Option<String>) {
        self.conditions = conditions;
    }

    pub fn description(&self) -> &Option<String> {
        &self.description
    }

    pub fn set_description(&mut self, description: Option<String>) {
        self.description = description;
    }

    pub fn icon(&self) -> &Option<String> {
        &self.icon
    }

    pub fn set_icon(&mut self, icon: Option<String>) {
        self.icon = icon;
    }

    pub fn stations(&self) -> &Option<Vec<String>> {
        &self.stations
    }

    pub fn set_stations(&mut self, stations: Option<Vec<String>>) {
        self.stations = stations;
    }

    pub fn source(&self) -> &Option<String> {
        &self.source
    }

    pub fn set_source(&mut self, source: Option<String>) {
        self.source = source;
    }

    pub fn events(&self) -> &Option<Vec<Event>> {
        &self.events
    }

    pub fn set_events(&mut self, events: Option<Vec<Event>>) {
        self.events = events;
    }

    pub fn weather_hourly_data(&self) -> &Option<Vec<WeatherHourlyData>> {
        &self.weather_hourly_data
    }

    pub fn set_weather_hourly_data(&mut self, weather_hourly_data: Option<Vec<WeatherHourlyData>>) {
        self.weather_hourly_data = weather_hourly_data;
    }
}

