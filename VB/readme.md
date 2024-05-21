# VB Library To Access Weather Data from VisaulCrossing API

## Table of Contents
* [Introduction](#introduction)
* [Using the Library](#using-the-library)
* [Documentation](#documentation)
* [Contact](#contact)
* [License](#license)

## Introduction
Visual Crossing Weather offers the most user-friendly and cost-effective solution for accessing both historical and forecasted weather data. Designed with simplicity and affordability in mind, our Weather API seamlessly integrates into any application or codebase, boasting the most competitive pricing in the industry.

Our comprehensive weather data serves a wide array of clients daily, ranging from business analysts and data scientists to insurance experts, energy producers, construction planners, and academic researchers.

This VB library simplifies the process of accessing weather data from [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api). Users can effortlessly retrieve weather information without needing to understand the specifics of API requests. By utilizing predefined functions, you can easily fetch weather data and extract particular parameters from the responses.

## Using the Library
Efficiently harness the capabilities of this VB library to access weather data from the Visual Crossing Weather API. The process involves two simple steps:
* **Data Fetching**: Begin by invoking the `FetchWeatherData` function from the `WeatherData` class to retrieve and store weather data from the API.
* **Data Retrieval**: Subsequently, use functions like `WeatherDailyData` from the `WeatherData` class to extract specific parameters from the previously fetched data.

Explore the [Demo] folder for practical examples demonstrating the usage of these functions.

## Documentation
#### Overview
This VB library is designed to simplify interactions with the Visual Crossing Weather API, providing classes to handle daily and hourly weather data, weather events, and station details. The library ensures easy data fetching and manipulation, suitable for applications in various domains such as business analytics, environmental monitoring, and academic research.

#### Key Classes and Usage

1. **WeatherData**
   - **Purpose**: Serves as the central class for managing weather data. It encapsulates all related weather parameters, storing JSON responses from the Weather API, and provides functions to retrieve and manipulate this data.
   - **Key functions**:
     - `FetchWeatherData(location As String, fromdate As String, todate As String, unitGroup As String, include As String, elements As String)`: Fetches weather data based on specified parameters.
     - `WeatherDailyData`: Retrieves daily weather data encapsulated within the instance.
     - `WeatherHourlyData`: Retrieves hourly weather data.

2. **WeatherDailyData**
   - **Purpose**: Manages daily weather data specifics, allowing detailed day-by-day weather analysis.
   - **Key functions**:
     - Various getters and setters for weather attributes like temperature, precipitation, wind speed, etc.

3. **WeatherHourlyData**
   - **Purpose**: Manages hourly weather data specifics, suitable for applications requiring time-of-day sensitivity.
   - **Key functions**:
     - Similar to `WeatherDailyData`, with time-specific attributes.

4. **WEvent**
   - **Purpose**: Captures and handles historical weather events such as hail, tornadoes, and earthquakes.
   - **Key functions**:
     - Getters and setters for event-specific details.

5. **WStation**
   - **Purpose**: Represents weather stations used for collecting weather data, offering insights into the source of data.
   - **Key functions**:
     - Getters and setters for station attributes like ID, name, and geographical coordinates.

#### Demos
- **Location**: Demos can be found in the `Demo` class within the repository.
- **Description**: Each demo illustrates the usage of the `WeatherData` class, showcasing how to initiate data fetch operations and subsequently access both daily and hourly data.

### Getting Started
To start using the library, clone the repository and refer to the `Demo` class for examples of how to use the library to fetch and display weather data. Ensure that your development environment is configured to include all necessary dependencies as specified in the library documentation.

### Additional Resources
- **Detailed API Documentation**: For more detailed information about each function and class, refer to the [`documentation.md`](./Documentation/documentation.md) file in the [Documentation] folder.

## Contact


## License
[GNU GPL](LICENSE.txt)
