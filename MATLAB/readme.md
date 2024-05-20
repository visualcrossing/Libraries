# MATLAB Library To Access Weather Data from VisaulCrossing API

## Table of Contents
* [Introduction](#introduction)
* [Using the Library](#using-the-library)
* [Documentation](#documentation)
* [Contributing](#contributing)
* [Contact](#contact)
* [License](#license)

## Introduction
Visual Crossing Weather offers the most user-friendly and cost-effective solution for accessing both historical and forecasted weather data. Designed with simplicity and affordability in mind, our Weather API seamlessly integrates into any application or codebase, boasting the most competitive pricing in the industry.

Our comprehensive weather data serves a wide array of clients daily, ranging from business analysts and data scientists to insurance experts, energy producers, construction planners, and academic researchers.

These MATLAB library simplify the process of accessing weather data from [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api). Users can effortlessly retrieve weather information without needing to understand the specifics of API requests. By utilizing predefined methods, you can easily fetch weather data and extract particular parameters from the responses.

## Using the Library
Efficiently harness the capabilities of these MATLAB library to access weather data from the Visual Crossing Weather API. The process involves two simple steps:
* **Data Fetching**: Begin by invoking the `fetch_weather_data` method from the `Weather` class to retrieve and store weather data from the API.
* **Data Retrieval**: Subsequently, use methods like `get_weather_data` from the `Weather` class to extract specific parameters from the previously fetched data.

Explore the [Demos] folder for practical examples demonstrating the usage of these methods.

## Documentation
#### Overview
This MATLAB library is designed to simplify interactions with the Visual Crossing Weather API, providing classes to handle daily and hourly weather data, weather events, and station details. The library ensures easy data fetching and manipulation, suitable for applications in various domains such as business analytics, environmental monitoring, and academic research.

#### Key Class, Methods and Usage

1. **Weather Class Introduction**
   - **Purpose**: Serves as the central class for fetching and managing weather data. It encapsulates all related weather parameters, storing JSON responses from the Weather API, and provides methods to retrieve and manipulate this data.
   - **Atrributes**:
     - `base_url` (str): Base URL of the API.
     - `api_key` (str): API key for accessing the API.
   - **Key Methods**:
     - `fetch_weather_data(obj, location, from_date, to_date, unit_group, include, elements)`: Fetches weather data based on specified parameters.
     - `get_weather_data(obj, elements)`: Retrieves weather data encapsulated within the instance.
     - `get_weather_daily_data(obj, elements)`: Retrieves daily weather data within the instance.
     - `get_weather_hourly_data(obj, elements)`: Retrieves hourly weather data.

2. **Get and Set Weather Element on Specific Day**
   - **Purpose**: Get and set individual weather element on specific day.
   - **Key Methods**:
     - Various getters and setters for weather attributes like temperature, precipitation, wind speed, etc on specific day.

3. **Get and Set Weather Element on Specific Time**
   - **Purpose**: Get and set individual weather element at specific time (e.g. '00:00:00', '01:00:00', etc.).
   - **Key Methods**:
     - Various getters and setters for weather attributes like temperature, precipitation, wind speed, etc at specific time.

4. **Get the MATLAB Datetime Object**
   - **Purpose**: Retrieves a list of datetime objects representing daily or hourly datetime from the weather data.
   - **Key Methods**:
     -  `get_daily_datetimes` for daily datetime, and `get_hourly_datetimes` for hourly datetime.

5. **Additional Functions**
   - **Purpose**: Make managing and processing the weather data more easier.
   - **Key Methods**:
     - `set_struct`, `update_struct`, `is_valid_struct`, `extract_substruct_by_keys`.

#### Demos
- **Location**: Demos can be found in the `Demo` folder within the repository.
- **Description**: Each demo illustrates the usage of the `Weather` class, showcasing how to initiate data fetch operations and subsequently access both daily and hourly data.

### Getting Started
To start using the library, clone the repository and refer to the `Demo` folder for examples of how to use the library to fetch and display weather data. Ensure that your development environment is configured to include all necessary dependencies as specified in the library documentation.

### Additional Resources
- **Detailed API Documentation**: For more detailed information about each method and class, refer to the [`documentation.md`](./Documentation/documentation.md) file in the [Documentation] folder.

## Contributing
This MATLAB library is an open initiative that relies on volunteers who are motivated by [Visual Crossing](https://www.visualcrossing.com/) to improve and extend our interfaces and services. Contributions to the library are highly appreciated. After gathering sufficient feedback and addressing any errors and suggestions, this library will be distributed on the MATLAB Central File Exchange(e.g. namely, Weather VisualCrossing Toolbox).

## Contact


## License
[GNU GPL](LICENSE.txt)
