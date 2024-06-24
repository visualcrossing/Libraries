## Detailed Documentation
### [<Back to readme](../readme.md)

Here, we will give the detailed documentation to use the Rust libraries to access the [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api).

#### 1. **WeatherData Class**
   - **Description**: Acts as the central component for fetching and managing weather data from the Visual Crossing Weather API.
   - **Usage**:
     - **` fetch_weather_data(&mut self, location: &str, from: Option<&str>, to: Option<&str>, unit_group: Option<&str>, include: Option<&str>, elements: Option<&str>)`**: Fetches weather data for a specified location and date range.
       - **Parameters**:
         - `location`: Address or latitude-longitude of the desired location.
         - `from`: Start date in `yyyy-MM-dd` format.
         - `to`: End date in `yyyy-MM-dd` format.
         - `unitGroup`: Unit system for the data (`us`, `uk`, `metric`, `base`).
         - `include`: Data sections to include (`days`, `hours`, `alerts`, etc.).
       - **Returns**: void
       - **Example**:
         ```Rust
          // Create weather API object with API key
          let mut weather_data = WeatherData::new("YOUR_API_KEY".to_string());

          // Fetch weather data with location, from date, to date params.
          weather_data.fetch_weather_data("38.96,-96.02", Some("2020-7-10"), Some("2020-7-12"), Some("us"), Some("events,hours"), Some("")).unwrap();

         ```
     - **`weather_daily_data()`**: Retrieves the daily weather data.
       - **Returns**: `WeatherDailyData`
     - **`weather_hourly_data()`**: Retrieves the hourly weather data.
       - **Returns**: `WeatherHourlyData`

#### 2. **WeatherDailyData Class**
   - **Description**: Manages daily weather data storage and retrieval.
   - **Properties**:
     - Temperature, precipitation, wind speed, and other daily metrics.
   - **Functions**:
     - Getters and setters for each weather attribute such as temperature, humidity, etc.
   - **Example**:
     ```Rust
       // Create weather API object with API key
        let mut weather_data = WeatherData::new("YOUR_API_KEY".to_string());

        // Fetch weather data with location, from date, to date params.
        weather_data.fetch_weather_data("38.96,-96.02", Some("2020-7-10"), Some("2020-7-12"), Some("us"), Some("events,hours"), Some("")).unwrap();

        // Daily weather data array list
        if let Some(weather_daily_data) = &weather_data.weather_daily_data() {
          for i in 0..weather_daily_data.len() {
              let datetime = daily_data.datetime().unwrap();
              println!("{:?}, {:?}", datetime, daily_data.temp_max().unwrap());
              println!("{:?}, {:?}", datetime, daily_data.temp_min().unwrap());
              println!("{:?}, {:?}", datetime, daily_data.humidity().unwrap());
          }
        }
     ```

#### 3. **WeatherHourlyData Class**
   - **Description**: Manages hourly weather data storage and retrieval.
   - **Properties**:
     - Hour-specific attributes like temperature, wind speed, and humidity.
   - **Functions**:
     - Getters and setters for each weather attribute.
   - **Example**:
     ```Rust
        // Create weather API object with API key
        let mut weather_data = WeatherData::new("YOUR_API_KEY".to_string());

        // Fetch weather data with location, from date, to date params.
        weather_data.fetch_weather_data("38.96,-96.02", Some("2020-7-10"), Some("2020-7-12"), Some("us"), Some("events,hours"), Some("")).unwrap();

        // Daily weather data array list
        if let Some(weather_daily_data) = &weather_data.weather_daily_data() {
            for i in 0..weather_daily_data.len() {
                if let Some(daily_data) = weather_daily_data.get(i) {
                   
                    // Hourly weather data array list
                    if let Some(weather_hourly_data) = &daily_data.weather_hourly_data() {
                        for hourly_data in weather_hourly_data {
                            // Print temperature

                            let hourtime = hourly_data.datetime().unwrap();
                            println!("{:?}, {:?}", hourtime, hourly_data.temp().unwrap());
                            println!("{:?}, {:?}", hourtime, hourly_data.humidity().unwrap());                        
                        }
                    }
                    
                } else {
                    println!("No data found for index {}", i);
                }            
                
            }
        }
     ```

#### 4. **Event Class**
   - **Description**: Handles storage and retrieval of significant weather events such as storms and earthquakes.
   - **Properties**:
     - Event type, date, impact level, and description.
   - **Functions**:
     - Getters and setters for event details.
   - **Example**:
     ```Rust
        // Create weather API object with API key
        let mut weather_data = WeatherData::new("YOUR_API_KEY".to_string());

        // Fetch weather data with location, from date, to date params.
        weather_data.fetch_weather_data("38.96,-96.02", Some("2020-7-10"), Some("2020-7-12"), Some("us"), Some("events,hours"), Some("")).unwrap();

        // Daily weather data array list
        if let Some(weather_daily_data) = &weather_data.weather_daily_data() {
            for i in 0..weather_daily_data.len() {
                if let Some(daily_data) = weather_daily_data.get(i) {                   
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
     ```

#### 5. **Station Class**
   - **Description**: Represents a weather station, providing details about the source of weather data.
   - **Properties**:
     - Station ID, name, latitude, and longitude.
   - **Functions**:
     - Getters and setters for station attributes.
   - **Example**:
     ```Rust
        // Create weather API object with API key
        let mut weather_data = WeatherData::new("YOUR_API_KEY".to_string());

        // Fetch weather data with location, from date, to date params.
        weather_data.fetch_weather_data("38.96,-96.02", Some("2020-7-10"), Some("2020-7-12"), Some("us"), Some("events,hours"), Some("")).unwrap();

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
     ```

### Conclusion
This documentation aims to provide a comprehensive guide for developers to utilize the Weather Data Library effectively. By following the examples and using the described functions, developers can integrate robust weather data functionalities into their applications, enhancing the richness and usability of their projects.