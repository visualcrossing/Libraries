use reqwest::blocking::Client;
use serde::de;
use serde_json::Value;
use std::collections::HashMap;
use std::error::Error;
use chrono::NaiveDate;
use chrono::NaiveTime;

use crate::event::Event;
use crate::station::Station;
use crate::weather_daily_data::{self, WeatherDailyData};
use crate::weather_hourly_data::{self, WeatherHourlyData};

pub struct WeatherData {
    api_key: String,
    base_url: &'static str,
    query_cost: Option<u64>,
    latitude: Option<f64>,
    longitude: Option<f64>,
    resolved_address: Option<String>,
    address: Option<String>,
    timezone: Option<String>,
    tz_offset: Option<f64>,
    weather_daily_data: Option<Vec<WeatherDailyData>>,
    stations: Option<HashMap<String, Station>>,
}

impl WeatherData {
    pub fn new(key: String) -> WeatherData {
        WeatherData {
            api_key: key,
            base_url: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/",
            query_cost: None,
            latitude: None,
            longitude: None,
            resolved_address: None,
            address: None,
            timezone: None,
            tz_offset: None,
            weather_daily_data: None,
            stations: None,
        }
    }

    // Getter methods
    pub fn api_key(&self) -> &String {
        &self.api_key
    }

    pub fn base_url(&self) -> &'static str {
        self.base_url
    }

    pub fn query_cost(&self) -> Option<u64> {
        self.query_cost
    }

    pub fn latitude(&self) -> Option<f64> {
        self.latitude
    }

    pub fn longitude(&self) -> Option<f64> {
        self.longitude
    }

    pub fn resolved_address(&self) -> Option<&String> {
        self.resolved_address.as_ref()
    }

    pub fn address(&self) -> Option<&String> {
        self.address.as_ref()
    }

    pub fn timezone(&self) -> Option<&String> {
        self.timezone.as_ref()
    }

    pub fn tz_offset(&self) -> Option<f64> {
        self.tz_offset
    }

    pub fn weather_daily_data(&self) -> Option<&Vec<WeatherDailyData>> {
        self.weather_daily_data.as_ref()
    }

    pub fn stations(&self) -> Option<&HashMap<String, Station>> {
        self.stations.as_ref()
    }

    // Setter methods
    pub fn set_api_key(&mut self, api_key: String) {
        self.api_key = api_key;
    }

    pub fn set_query_cost(&mut self, query_cost: Option<u64>) {
        self.query_cost = query_cost;
    }

    pub fn set_latitude(&mut self, latitude: Option<f64>) {
        self.latitude = latitude;
    }

    pub fn set_longitude(&mut self, longitude: Option<f64>) {
        self.longitude = longitude;
    }

    pub fn set_resolved_address(&mut self, resolved_address: Option<String>) {
        self.resolved_address = resolved_address;
    }

    pub fn set_address(&mut self, address: Option<String>) {
        self.address = address;
    }

    pub fn set_timezone(&mut self, timezone: Option<String>) {
        self.timezone = timezone;
    }

    pub fn set_tz_offset(&mut self, tz_offset: Option<f64>) {
        self.tz_offset = tz_offset;
    }

    pub fn set_weather_daily_data(&mut self, weather_daily_data: Option<Vec<WeatherDailyData>>) {
        self.weather_daily_data = weather_daily_data;
    }

    pub fn set_stations(&mut self, stations: Option<HashMap<String, Station>>) {
        self.stations = stations;
    }

    fn get_string_or_null(value: &Value, key: &str) -> Option<String> {
        value[key].as_str().map(|s| s.to_string())
    }

    fn get_double_or_null(value: &Value, key: &str) -> Option<f64> {
        value[key].as_f64()
    }

    fn get_long_or_null(value: &Value, key: &str) -> Option<u64> {
        value[key].as_u64()
    }

    fn get_int_or_null(value: &Value, key: &str) -> Option<i32> {
        value[key].as_i64().map(|v| v as i32)
    }

    /**
     * The fetch_data function retrieves weather data by making an API request to the specified URL using the weather data API.
     * @param URL
     * @return
    */

    fn fetch_data(&self, url: &str) -> Result<String, Box<dyn Error>> {
        let client = Client::new();
        let resp = client.get(url).send()?;
        let body = resp.text()?;
        Ok(body)
    }

    /**
     * The create_weather_daily_data function creates an hourly data object from a JSON object.
     * The function checks if a key in the JSON object is null and sets the corresponding property to null if it is.
     * Otherwise, it assigns the value from the JSON object to the property.
     */

    fn create_weather_daily_data(day: &Value) -> WeatherDailyData {
        let precip_type: Option<Vec<String>> = if day["preciptype"].is_null() {
            None
        } else {
            let precip_types = day["preciptype"].as_array().unwrap();
            Some(precip_types.iter().map(|v| v.as_str().unwrap().to_string()).collect())
        };

        let stations: Option<Vec<String>> = if day["stations"].is_null() {
            None
        } else {
            let stations_array = day["stations"].as_array().unwrap();
            Some(stations_array.iter().map(|v| v.as_str().unwrap().to_string()).collect())
        };

        let events: Option<Vec<Event>> = if day["events"].is_null() {
            None
        } else {
            let events_array = day["events"].as_array().unwrap();
            Some(events_array.iter().map(|v| WeatherData::create_event(v)).collect())
        };

        let weather_hourly_data: Option<Vec<WeatherHourlyData>> = if day["hours"].is_null() {
            None
        } else {
            let hours_array = day["hours"].as_array().unwrap();
            Some(hours_array.iter().map(|v| WeatherData::create_hourly_data(v)).collect())
        };

        let mut weatherDailyData = WeatherDailyData::new();

        let date_str = WeatherData::get_string_or_null(day, "datetime").unwrap_or_else(|| {
            eprintln!("Failed to get date string");
            std::process::exit(1);
        });
    
        let naive_date = NaiveDate::parse_from_str(&date_str, "%Y-%m-%d").unwrap_or_else(|e| {
            eprintln!("Error parsing date: {}", e);
            std::process::exit(1);
        });

        weatherDailyData.set_datetime(Some(naive_date));
        weatherDailyData.set_datetime_epoch(WeatherData::get_long_or_null(day, "datetimeEpoch"));
        weatherDailyData.set_temp_max(WeatherData::get_double_or_null(day, "tempmax"));
        weatherDailyData.set_temp_min(WeatherData::get_double_or_null(day, "tempmin"));
        weatherDailyData.set_temp(WeatherData::get_double_or_null(day, "temp"));
        weatherDailyData.set_feels_like_max(WeatherData::get_double_or_null(day, "feelslikemax"));
        weatherDailyData.set_feels_like_min(WeatherData::get_double_or_null(day, "feelslikemin"));
        weatherDailyData.set_feels_like(WeatherData::get_double_or_null(day, "feelslike"));
        weatherDailyData.set_dew(WeatherData::get_double_or_null(day, "dew"));
        weatherDailyData.set_humidity(WeatherData::get_double_or_null(day, "humidity"));
        weatherDailyData.set_precip(WeatherData::get_double_or_null(day, "precip"));
        weatherDailyData.set_precip_prob(WeatherData::get_double_or_null(day, "precipprob"));
        weatherDailyData.set_precip_cover(WeatherData::get_double_or_null(day, "precipcover"));
        weatherDailyData.set_precip_type(precip_type);
        weatherDailyData.set_snow(WeatherData::get_double_or_null(day, "snow"));
        weatherDailyData.set_snow_depth(WeatherData::get_double_or_null(day, "snowdepth"));
        weatherDailyData.set_wind_gust(WeatherData::get_double_or_null(day, "windgust"));
        weatherDailyData.set_wind_speed(WeatherData::get_double_or_null(day, "windspeed"));
        weatherDailyData.set_wind_dir(WeatherData::get_double_or_null(day, "winddir"));
        weatherDailyData.set_pressure(WeatherData::get_double_or_null(day, "pressure"));
        weatherDailyData.set_cloud_cover(WeatherData::get_double_or_null(day, "cloudcover"));
        weatherDailyData.set_visibility(WeatherData::get_double_or_null(day, "visibility"));
        weatherDailyData.set_solar_radiation(WeatherData::get_double_or_null(day, "solarradiation"));
        weatherDailyData.set_solar_energy(WeatherData::get_double_or_null(day, "solarenergy"));
        weatherDailyData.set_uv_index(WeatherData::get_double_or_null(day, "uvindex"));
        weatherDailyData.set_sunrise(WeatherData::get_string_or_null(day, "sunrise"));
        weatherDailyData.set_sunrise_epoch(WeatherData::get_long_or_null(day, "sunriseEpoch"));
        weatherDailyData.set_sunset(WeatherData::get_string_or_null(day, "sunset"));
        weatherDailyData.set_sunset_epoch(WeatherData::get_long_or_null(day, "sunsetEpoch"));
        weatherDailyData.set_moon_phase(WeatherData::get_double_or_null(day, "moonphase"));
        weatherDailyData.set_conditions(WeatherData::get_string_or_null(day, "conditions"));
        weatherDailyData.set_description(WeatherData::get_string_or_null(day, "description"));
        weatherDailyData.set_icon(WeatherData::get_string_or_null(day, "icon"));
        weatherDailyData.set_stations(stations);
        weatherDailyData.set_events(events);
        weatherDailyData.set_weather_hourly_data(weather_hourly_data);
        weatherDailyData.set_source(WeatherData::get_string_or_null(day, "source"));

        weatherDailyData
    }
    
    /**
     * The create_hourly_data function creates an hourly data object from a JSON object.
     * The function checks if a key in the JSON object is null and sets the corresponding property to null if it is.
     * Otherwise, it assigns the value from the JSON object to the property.
    */
    fn create_hourly_data(hour: &Value) -> WeatherHourlyData {
        let precip_type: Option<Vec<String>> = if hour["preciptype"].is_null() {
            None
        } else {
            let precip_types = hour["preciptype"].as_array().unwrap();
            Some(precip_types.iter().map(|v| v.as_str().unwrap().to_string()).collect())
        };

        let stations: Option<Vec<String>> = if hour["stations"].is_null() {
            None
        } else {
            let stations = hour["stations"].as_array().unwrap();
            Some(stations.iter().map(|v| v.as_str().unwrap().to_string()).collect())
        };

        let mut weather_hourly_data = WeatherHourlyData::new();

        let date_str = WeatherData::get_string_or_null(hour, "datetime").unwrap_or_else(|| {
            eprintln!("Failed to get date string");
            std::process::exit(1);
        });
    
        let naive_date = NaiveTime::parse_from_str(&date_str, "%H:%M:%S").unwrap_or_else(|e| {
            eprintln!("Error parsing date: {}", e);
            std::process::exit(1);
        });

        weather_hourly_data.set_datetime(Some(naive_date));

        weather_hourly_data.set_datetime_epoch(WeatherData::get_long_or_null(hour, "datetimeEpoch"));
        weather_hourly_data.set_temp(WeatherData::get_double_or_null(hour, "temp"));
        weather_hourly_data.set_feels_like(WeatherData::get_double_or_null(hour, "feelslike"));
        weather_hourly_data.set_humidity(WeatherData::get_double_or_null(hour, "humidity"));
        weather_hourly_data.set_dew(WeatherData::get_double_or_null(hour, "dew"));
        weather_hourly_data.set_precip(WeatherData::get_double_or_null(hour, "precip"));
        weather_hourly_data.set_precip_prob(WeatherData::get_double_or_null(hour, "precipprob"));
        weather_hourly_data.set_snow(WeatherData::get_double_or_null(hour, "snow"));
        weather_hourly_data.set_snow_depth(WeatherData::get_double_or_null(hour, "snowdepth"));
        weather_hourly_data.set_precip_type(precip_type);
        weather_hourly_data.set_wind_gust(WeatherData::get_double_or_null(hour, "windgust"));
        weather_hourly_data.set_wind_speed(WeatherData::get_double_or_null(hour, "windspeed"));
        weather_hourly_data.set_wind_dir(WeatherData::get_double_or_null(hour, "winddir"));
        weather_hourly_data.set_pressure(WeatherData::get_double_or_null(hour, "pressure"));
        weather_hourly_data.set_visibility(WeatherData::get_double_or_null(hour, "visibility"));
        weather_hourly_data.set_cloud_cover(WeatherData::get_double_or_null(hour, "cloudcover"));
        weather_hourly_data.set_solar_radiation(WeatherData::get_double_or_null(hour, "solarradiation"));
        weather_hourly_data.set_solar_energy(WeatherData::get_double_or_null(hour, "solarenergy"));
        weather_hourly_data.set_uv_index(WeatherData::get_double_or_null(hour, "uvindex"));
        weather_hourly_data.set_conditions(WeatherData::get_string_or_null(hour, "conditions"));
        weather_hourly_data.set_icon(WeatherData::get_string_or_null(hour, "icon"));
        weather_hourly_data.set_stations(stations);
        weather_hourly_data.set_source(WeatherData::get_string_or_null(hour, "source"));

        weather_hourly_data
    }
    
    /**
        * The handle_weather_data function parse JSON structure from String.
        * @param jsonString
    */
    fn handle_weather_data(&mut self, json_string: &str) -> Result<(), Box<dyn Error>> {
        let obj: Value = serde_json::from_str(json_string)?;

        self.query_cost = WeatherData::get_long_or_null(&obj, "queryCost");
        self.latitude = WeatherData::get_double_or_null(&obj, "latitude");
        self.longitude = WeatherData::get_double_or_null(&obj, "longitude");
        self.resolved_address = WeatherData::get_string_or_null(&obj, "resolvedAddress");
        self.address = WeatherData::get_string_or_null(&obj, "address");
        self.timezone = WeatherData::get_string_or_null(&obj, "timezone");
        self.tz_offset = WeatherData::get_double_or_null(&obj, "tzoffset");

        // Handle daily weather data
        let mut weather_daily_data = Vec::new();
        if let Some(days) = obj["days"].as_array() {
            for day in days {
                let weather_day_data = WeatherData::create_weather_daily_data(day);
                weather_daily_data.push(weather_day_data);
            }
        } else {
            return Err("Missing 'days' field".into());
        }
        self.weather_daily_data = Some(weather_daily_data);

        // Handle stations
        let mut stations = HashMap::new();
        if let Some(stations_json) = obj["stations"].as_object() {
            for (key, value) in stations_json {
                let station_obj = value.as_object().ok_or("Invalid 'stations' field format")?;
                let mut station = Station::new();
                station.set_distance(WeatherData::get_double_or_null(&Value::Object(station_obj.clone()), "distance"));
                station.set_latitude(WeatherData::get_double_or_null(&Value::Object(station_obj.clone()), "latitude"));
                station.set_longitude(WeatherData::get_double_or_null(&Value::Object(station_obj.clone()), "longitude"));
                station.set_use_count(WeatherData::get_int_or_null(&Value::Object(station_obj.clone()), "useCount"));
                station.set_id(WeatherData::get_string_or_null(&Value::Object(station_obj.clone()), "id"));
                station.set_name(WeatherData::get_string_or_null(&Value::Object(station_obj.clone()), "name"));
                station.set_quality(WeatherData::get_int_or_null(&Value::Object(station_obj.clone()), "quality"));
                station.set_contribution(WeatherData::get_double_or_null(&Value::Object(station_obj.clone()), "contribution"));
                
                stations.insert(key.to_string(), station);
            }
        } 
        
        self.stations = Some(stations);

        Ok(())
    }

    // create_hourly_data and create_weather_daily_data methods (as provided)

    fn create_event(event_obj: &Value) -> Event {
        let mut event: Event = Event::new();

        let date_str = WeatherData::get_string_or_null(event_obj, "datetime").unwrap_or_else(|| {
            eprintln!("Failed to get date string");
            std::process::exit(1);
        });
    
        let naive_date = NaiveDate::parse_from_str(&date_str, "%Y-%m-%d").unwrap_or_else(|e| {
            eprintln!("Error parsing date: {}", e);
            std::process::exit(1);
        });

        event.set_datetime(Some(naive_date));
        event.set_datetime_epoch(WeatherData::get_long_or_null(event_obj, "datetimeEpoch"));
        event.set_event_type(WeatherData::get_string_or_null(event_obj, "type"));
        event.set_latitude(WeatherData::get_double_or_null(event_obj, "latitude"));
        event.set_longitude(WeatherData::get_double_or_null(event_obj, "longitude"));
        event.set_distance(WeatherData::get_double_or_null(event_obj, "distance"));
        event.set_description(WeatherData::get_string_or_null(event_obj, "description"));
        event.set_size(WeatherData::get_double_or_null(event_obj, "size"));

        event
    }

    /**
        * The fetch_weather_data function will fetch weather data from params.
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

    pub fn fetch_weather_data(&mut self, location: &str, from: Option<&str>, to: Option<&str>, unit_group: Option<&str>, include: Option<&str>, elements: Option<&str>) -> Result<(), Box<dyn std::error::Error>> {
        if self.api_key.is_empty() {
            return Err("API key is not set.".into());
        }

        let mut url = format!("{}{}?", self.base_url, location);

        if let Some(f) = from {
            url = format!("{}{}/{}", url, f, to.unwrap_or(""));
        }
        url = format!("{}&key={}", url, self.api_key);

        if let Some(ug) = unit_group {
            url = format!("{}&unitGroup={}", url, ug);
        }

        if let Some(inc) = include {
            url = format!("{}&include={}", url, inc);
        }

        if let Some(ele) = elements {
            url = format!("{}&elements={}", url, ele);
        }

        match self.fetch_data(&url) {
            Ok(data) => self.handle_weather_data(&data),
            Err(e) => {
                println!("Error fetching weather data: {}", e);
                // Perform any action you need to when an error occurs
                Err(e)
            }
        }
    }

     /**
         * The fetch_weather_data_forecast function will fetch the weather forecast for location for the next 15 days
        * starting at midnight at the start of the current day (local time of the requested location).
        * @param location: String
        * location param is the address, partial address or latitude,longitude location for which to retrieve weather data.
        * You can also use US ZIP Codes. If you would like to submit multiple locations in the same request,
        * consider our Multiple Location Timeline Weather API.
    */
        
    pub fn fetch_weather_data_forecast(&mut self, location: &str) -> Result<(), Box<dyn std::error::Error>> {
        self.fetch_weather_data(location, None, None, None, None, None)
    }

}
