use std::option::Option;
use std::time::Duration;
use chrono::NaiveTime;

pub struct WeatherHourlyData {
    datetime: Option<NaiveTime>,
    datetime_epoch: Option<u64>,
    temp: Option<f64>,
    feels_like: Option<f64>,
    humidity: Option<f64>,
    dew: Option<f64>,
    precip: Option<f64>,
    precip_prob: Option<f64>,
    snow: Option<f64>,
    snow_depth: Option<f64>,
    precip_type: Option<Vec<String>>,
    wind_gust: Option<f64>,
    wind_speed: Option<f64>,
    wind_dir: Option<f64>,
    pressure: Option<f64>,
    visibility: Option<f64>,
    cloud_cover: Option<f64>,
    solar_radiation: Option<f64>,
    solar_energy: Option<f64>,
    uv_index: Option<f64>,
    conditions: Option<String>,
    icon: Option<String>,
    stations: Option<Vec<String>>,
    source: Option<String>,
}

impl WeatherHourlyData {
    pub fn new() -> WeatherHourlyData {
        WeatherHourlyData {
            datetime: None,
            datetime_epoch: None,
            temp: None,
            feels_like: None,
            humidity: None,
            dew: None,
            precip: None,
            precip_prob: None,
            snow: None,
            snow_depth: None,
            precip_type: None,
            wind_gust: None,
            wind_speed: None,
            wind_dir: None,
            pressure: None,
            visibility: None,
            cloud_cover: None,
            solar_radiation: None,
            solar_energy: None,
            uv_index: None,
            conditions: None,
            icon: None,
            stations: None,
            source: None,
        }
    }

    // Getters and setters
    pub fn datetime(&self) -> Option<NaiveTime> {
        self.datetime
    }

    pub fn set_datetime(&mut self, datetime: Option<NaiveTime>) {
        self.datetime = datetime;
    }

    pub fn datetime_epoch(&self) -> Option<u64> {
        self.datetime_epoch
    }

    pub fn set_datetime_epoch(&mut self, datetime_epoch: Option<u64>) {
        self.datetime_epoch = datetime_epoch;
    }

    pub fn temp(&self) -> Option<f64> {
        self.temp
    }

    pub fn set_temp(&mut self, temp: Option<f64>) {
        self.temp = temp;
    }

    pub fn feels_like(&self) -> Option<f64> {
        self.feels_like
    }

    pub fn set_feels_like(&mut self, feels_like: Option<f64>) {
        self.feels_like = feels_like;
    }

    pub fn humidity(&self) -> Option<f64> {
        self.humidity
    }

    pub fn set_humidity(&mut self, humidity: Option<f64>) {
        self.humidity = humidity;
    }

    pub fn dew(&self) -> Option<f64> {
        self.dew
    }

    pub fn set_dew(&mut self, dew: Option<f64>) {
        self.dew = dew;
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

    pub fn precip_type(&self) -> &Option<Vec<String>> {
        &self.precip_type
    }

    pub fn set_precip_type(&mut self, precip_type: Option<Vec<String>>) {
        self.precip_type = precip_type;
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

    pub fn visibility(&self) -> Option<f64> {
        self.visibility
    }

    pub fn set_visibility(&mut self, visibility: Option<f64>) {
        self.visibility = visibility;
    }

    pub fn cloud_cover(&self) -> Option<f64> {
        self.cloud_cover
    }

    pub fn set_cloud_cover(&mut self, cloud_cover: Option<f64>) {
        self.cloud_cover = cloud_cover;
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

    pub fn conditions(&self) -> &Option<String> {
        &self.conditions
    }

    pub fn set_conditions(&mut self, conditions: Option<String>) {
        self.conditions = conditions;
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
}
