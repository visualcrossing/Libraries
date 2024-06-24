use std::collections::HashMap;
use reqwest::blocking::Client;
use chrono::prelude::*;
use serde_json::Value;

mod weather_data;
mod weather_daily_data;
mod weather_hourly_data;
mod station;
mod event;

use weather_data :: {WeatherData};
use weather_daily_data :: {WeatherDailyData};
use weather_hourly_data :: {WeatherHourlyData};
use station :: {Station};
use event :: {Event};


fn main() {
    // Create weather API object with API key
    let mut weather_data = WeatherData::new("YOUR_API_KEY".to_string());

    // Fetch weather data with location, from date, to date params.
    weather_data.fetch_weather_data("38.96,-96.02", Some("2020-7-10"), Some("2020-7-12"), Some("us"), Some("events,hours"), Some("")).unwrap();

    // Daily weather data array list
    if let Some(weather_daily_data) = &weather_data.weather_daily_data() {
        for i in 0..weather_daily_data.len() {
            if let Some(daily_data) = weather_daily_data.get(i) {
                let datetime = daily_data.datetime().unwrap();
                println!("{:?}, {:?}", datetime, daily_data.temp_max().unwrap());
                println!("{:?}, {:?}", datetime, daily_data.temp_min().unwrap());
                println!("{:?}, {:?}", datetime, daily_data.humidity().unwrap());

                // Hourly weather data array list
                if let Some(weather_hourly_data) = &daily_data.weather_hourly_data() {
                    for hourly_data in weather_hourly_data {
                        // Print temperature

                        let hourtime = hourly_data.datetime().unwrap();
                        println!("{:?}, {:?}", hourtime, hourly_data.temp().unwrap());
                        println!("{:?}, {:?}", hourtime, hourly_data.humidity().unwrap());                        
                    }
                }
                
                if let Some(events) = &daily_data.events() {
                    for event_obj in events {
                        if let Some(datetime) = event_obj.datetime() {
                            println!("{:?}, {:?}", datetime, event_obj.datetime_epoch());
                        }
                    }
                }
            } else {
                println!("No data found for index {}", i);
            }            
            
        }
    }

    // Dictionary of stations
    if let Some(stations) = weather_data.stations() {
        for (key, station) in stations.iter() {
            if let Some(name) = &station.name() {
                println!("{}, {}", key, name);
            }
            if let Some(id) = &station.id() {
                println!("{}, {}", key, id);
            }
            if let Some(use_count) = station.use_count() {
                println!("{}, {}", key, use_count);
            }
        }
    }

    // Initialize WeatherData object
    let mut weather_data1 = WeatherData::new("".to_string());

    // Set API_KEY
    weather_data1.set_api_key("YOUR_API_KEY".to_string());

    // Fetch weather data for a specific datetime
    weather_data1.fetch_weather_data("K2A1W1", Some("2021-10-19"), Some("2021-10-19"), None, None, None).unwrap();

    // Daily weather data object
    if let Some(weather_daily_data1) = &weather_data1.weather_daily_data() {
        for daily_data in weather_daily_data1.iter() {
            // Print temperature
            if let Some(datetime) = daily_data.datetime() {
                println!("{:?}, {:?}", datetime, daily_data.temp_max().unwrap());
            }
        }
    }

    // Fetch forecast (15 days) weather data for the location
    weather_data1.fetch_weather_data_forecast("K2A1W1").unwrap();

    // Daily weather data list
    if let Some(weather_daily_data2) = &weather_data1.weather_daily_data() {
        for daily_data in weather_daily_data2.iter() {
            // Print temperature
            if let Some(datetime) = daily_data.datetime() {
                println!("{:?}, {:?}", datetime, daily_data.temp_max().unwrap());
            }
        }
    }

    // Create another instance of WeatherData
    let mut weather_data2 = WeatherData::new("".to_string());
    weather_data2.set_api_key("YOUR_API_KEY".to_string());
}