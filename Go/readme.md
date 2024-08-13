# Go package To Access Weather Data from Visual Crossing Weather API

## Table of Contents
* [Introduction](#introduction)
* [Using the package](#using-the-package)
* [Documentation](#documentation)
* [Contact](#contact)
* [License](#license)

## Introduction
Visual Crossing Weather offers the most user-friendly and cost-effective solution for accessing both historical and forecasted weather data. Designed with simplicity and affordability in mind, our Weather API seamlessly integrates into any application or codebase, boasting the most competitive pricing in the industry.

Our comprehensive weather data serves a wide array of clients daily, ranging from business analysts and data scientists to insurance experts, energy producers, construction planners, and academic researchers.

These Go package simplify the process of accessing weather data from [Visual Crossing Weather API](https://www.visualcrossing.com/weather-api). Users can effortlessly retrieve weather information without needing to understand the specifics of API requests. By utilizing predefined methods, you can easily fetch weather data and extract particular parameters from the responses.

## Using the package
Efficiently harness the capabilities of these Go package to access weather data from the Visual Crossing Weather API. The process involves two simple steps:
* **Data Fetching**: Begin by invoking the `FetchWeatherData` method of the `Weather` struct to retrieve and store weather data from the API.
* **Data Retrieval**: Subsequently, use methods like `GetWeatherDailyData` of the `Weather` struct to extract specific parameters from the previously fetched data.

Explore the [Demo] folder for practical examples demonstrating the usage of these methods.

## Documentation
#### Overview
This Go package is designed to simplify interactions with the Visual Crossing Weather API, providing structs to handle daily and hourly weather data, weather events, and station details. The package ensures easy data fetching and manipulation, suitable for applications in various domains such as business analytics, environmental monitoring, and academic research.

#### Key structs and Usage

1. **Weather**
   - **Purpose**: Serves as the central struct for managing weather data. It encapsulates all related weather parameters, storing JSON responses from the Weather API, and provides methods to retrieve and manipulate this data.
   - **Key Methods**:
     - `FetchWeatherData(location, fromDate, toDate, unitGroup, include, elements string)`: Fetches weather data based on specified parameters.
     - `GetWeatherData(elements ...[]string)`: Retrieves weather data encapsulated within the instance, with some elements if specified.
     - `GetWeatherDailyData(elements ...[]string)`: Retrieves daily weather data encapsulated within the instance, with some elements if specified.
     - `GetWeatherHourlyData(elements ...[]string)`: Retrieves hourly weather data encapsulated within the instance, with some elements if specified.
     - Ohter getter and setter method for individual elements for the weather data.

2. **Day**
   - **Purpose**: Manages daily weather data specifics, allowing detailed day-by-day weather analysis.

3. **Hour**
   - **Purpose**: Manages hourly weather data specifics, suitable for applications requiring time-of-day sensitivity.

4. **Event**
   - **Purpose**: Captures and handles historical weather events such as hail, tornadoes, and earthquakes.

5. **Station**
   - **Purpose**: Represents weather stations used for collecting weather data, offering insights into the source of data.

#### Demo
- **Location**: Example usage of this package can be found in the `Demo` folder within the repository.
- **Description**: Each demo illustrates the usage of the `Weather` struct, showcasing how to initiate data fetch operations and subsequently access both daily and hourly data.

### Getting Started
To start using the package, clone the repository and refer to the `Demo` folder for examples of how to use the package to fetch and display weather data. Ensure that your development environment is configured to include all necessary dependencies as specified in the package documentation.

### Additional Resources
- **Detailed API Documentation**: For more detailed information about each method and struct, refer to the [`documentation.md`](./Documentation/documentation.md) file in the [Documentation] folder.

## Contact


## License
[GNU GPL](LICENSE.txt)
