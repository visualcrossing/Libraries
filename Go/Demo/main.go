package main

import (
	"encoding/json"
	"fmt"
	"visualcrossing_weather/weather"
)

func main() {
	// ---------------------- test helper funtinality ----------------------
	type Person struct {
		Name    string
		Age     int
		City    string
		Country string
	}

	type SubPerson struct {
		Name string
		City string
	}

	original := &Person{
		Name:    "John",
		Age:     30,
		City:    "New York",
		Country: "USA",
	}
	updates := &Person{
		Age:     31,
		City:    "San Francisco",
		Country: "USA",
	}
	excludeFields := []string{"Country"}
	allowedFields := []string{"Name", "Age", "City", "Country"}

	weather.UpdateStruct(original, updates, excludeFields)
	fmt.Println(">>Updated struct:", original)

	isValid := weather.IsValidStruct(original, allowedFields)
	fmt.Println(">>Is valid struct:", isValid)

	subStruct := &SubPerson{}
	fieldsList := []string{"Name", "City"}
	weather.ExtractSubstructByFields(original, fieldsList, subStruct)
	fmt.Println(">>Sub-struct:", subStruct)

	// ---------------------- test main funtinality ----------------------
	jsonData := `
	{
		"queryCost": 48,
		"latitude": 37.7771,
		"longitude": -122.42,
		"resolvedAddress": "San Francisco, CA, United States",
		"address": "San Francisco",
		"timezone": "America/Los_Angeles",
		"tzoffset": -8.0,
		"days": [
			{
				"datetime": "2024-01-01",
				"datetimeEpoch": 1704096000,
				"tempmax": 58.0,
				"tempmin": 47.3,
				"temp": 52.6,
				"feelslikemax": 58.0,
				"feelslikemin": 45.1,
				"feelslike": 52.4,
				"dew": 48.1,
				"humidity": 84.7,
				"precip": 0.0,
				"precipprob": 0.0,
				"precipcover": 0.0,
				"preciptype": null,
				"snow": 0.0,
				"snowdepth": 0.0,
				"windgust": 6.9,
				"windspeed": 6.8,
				"winddir": 86.6,
				"pressure": 1021.5,
				"cloudcover": 24.0,
				"visibility": 9.8,
				"solarradiation": 125.9,
				"solarenergy": 10.8,
				"uvindex": 5.0,
				"severerisk": 10.0,
				"sunrise": "07:25:14",
				"sunriseEpoch": 1704122714,
				"sunset": "17:01:19",
				"sunsetEpoch": 1704157279,
				"moonphase": 0.69,
				"conditions": "Partially cloudy",
				"description": "Partly cloudy throughout the day.",
				"icon": "partly-cloudy-day",
				"stations": [
					"72585093228",
					"KSFO",
					"72493023230",
					"KHWD",
					"KOAK",
					"C5988",
					"72494023234"
				],
				"source": "obs",
				"hours": [
					{
						"datetime": "00:00:00",
						"datetimeEpoch": 1704096000,
						"temp": 50.3,
						"feelslike": 50.3,
						"humidity": 90.09,
						"dew": 47.6,
						"precip": 0.0,
						"precipprob": 0.0,
						"snow": 0.0,
						"snowdepth": 0.0,
						"preciptype": null,
						"windgust": 4.7,
						"windspeed": 4.1,
						"winddir": 103.0,
						"pressure": 1019.9,
						"visibility": 9.9,
						"cloudcover": 32.4,
						"solarradiation": 0.0,
						"solarenergy": 0.0,
						"uvindex": 0.0,
						"severerisk": 10.0,
						"conditions": "Partially cloudy",
						"icon": "partly-cloudy-night",
						"stations": [
							"72585093228",
							"KSFO",
							"72493023230",
							"KHWD",
							"KOAK",
							"C5988",
							"72494023234"
						],
						"source": "obs"
					}
				]
			}
		],
		"stations": {
			"72585093228": {
				"distance": 30142.0,
				"latitude": 37.654,
				"longitude": -122.115,
				"useCount": 0,
				"id": "72585093228",
				"name": "HAYWARD AIR TERMINAL, CA US",
				"quality": 100,
				"contribution": 0.0
			},
			"KSFO": {
				"distance": 18932.0,
				"latitude": 37.61,
				"longitude": -122.38,
				"useCount": 0,
				"id": "KSFO",
				"name": "KSFO",
				"quality": 100,
				"contribution": 0.0
			}
		}
	}`

	// Unmarshal the JSON data into a WeatherData struct
	var weatherData weather.WeatherData
	err := json.Unmarshal([]byte(jsonData), &weatherData)
	if err != nil {
		fmt.Println("! Error unmarshalling JSON:", err)
		return
	}

	// Initialize the Weather instance
	weatherInstance, err := weather.NewWeather("https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline", "3KAJKHWT3UEMRQWF2ABKVVVZE", []byte(jsonData))
	if err != nil {
		fmt.Println("! Error initializing Weather instance:", err)
		return
	}
	// Print the initialized weather data
	fmt.Println("Weather Data:", weatherInstance.GetWeatherData())

	// Test GetWeatherDailyData with and without filtering elements
	elements := []string{"datetime", "tempmax", "tempmin", "temp"}
	dailyData := weatherInstance.GetWeatherDailyData(elements)
	fmt.Println(">>Filtered Daily Data:", dailyData)

	// Test GetWeatherHourlyData with and without filtering elements
	hourlyData := weatherInstance.GetWeatherHourlyData(elements)
	fmt.Println(">>Filtered Hourly Data:", hourlyData)

	// Set new weather data
	newWeatherData := weather.WeatherData{
		QueryCost:       50,
		Latitude:        37.7749,
		Longitude:       -122.4194,
		ResolvedAddress: "San Francisco, CA, USA",
		Address:         "San Francisco",
		Timezone:        "America/Los_Angeles",
		Tzoffset:        -8.0,
		Days: []weather.Day{
			{
				Datetime:       "2024-01-02",
				DatetimeEpoch:  1704182400,
				Tempmax:        60.0,
				Tempmin:        48.0,
				Temp:           54.0,
				Feelslikemax:   60.0,
				Feelslikemin:   46.0,
				Feelslike:      54.0,
				Dew:            48.0,
				Humidity:       80.0,
				Precip:         0.2,
				Precipprob:     50.0,
				Precipcover:    30.0,
				Preciptype:     []string{"rain"},
				Snow:           0.0,
				Snowdepth:      0.0,
				Windgust:       20.0,
				Windspeed:      15.0,
				Winddir:        100.0,
				Pressure:       1015.0,
				Cloudcover:     40.0,
				Visibility:     10.0,
				Solarradiation: 200.0,
				Solarenergy:    5.0,
				Uvindex:        5.0,
				Severerisk:     10.0,
				Sunrise:        "07:30:00",
				SunriseEpoch:   1704205800,
				Sunset:         "17:00:00",
				SunsetEpoch:    1704241200,
				Moonphase:      0.5,
				Conditions:     "Partly cloudy",
				Description:    "Partly cloudy with a chance of rain.",
				Icon:           "partly-cloudy-day",
				Stations:       []string{"KSFO", "72585093228"},
				Source:         "obs",
				Hours: []weather.Hour{
					{
						Datetime:       "00:00:00",
						DatetimeEpoch:  1704182400,
						Temp:           48.0,
						Feelslike:      48.0,
						Humidity:       85.0,
						Dew:            46.0,
						Precip:         0.1,
						Precipprob:     20.0,
						Snow:           0.0,
						Snowdepth:      0.0,
						Preciptype:     []string{"rain"},
						Windgust:       10.0,
						Windspeed:      5.0,
						Winddir:        110.0,
						Pressure:       1018.0,
						Visibility:     10.0,
						Cloudcover:     50.0,
						Solarradiation: 0.0,
						Solarenergy:    0.0,
						Uvindex:        0.0,
						Severerisk:     5.0,
						Conditions:     "Rain",
						Icon:           "rain",
						Stations:       []string{"KSFO", "72585093228"},
						Source:         "obs",
					},
				},
			},
		},
		Stations: map[string]weather.Station{
			"KSFO": {
				Distance:     15000.0,
				Latitude:     37.7749,
				Longitude:    -122.4194,
				UseCount:     0,
				ID:           "KSFO",
				Name:         "San Francisco International Airport",
				Quality:      100,
				Contribution: 0.0,
			},
			"72585093228": {
				Distance:     20000.0,
				Latitude:     37.7749,
				Longitude:    -122.4194,
				UseCount:     0,
				ID:           "72585093228",
				Name:         "Some Other Station",
				Quality:      100,
				Contribution: 0.0,
			},
		},
	}
	weatherInstance.SetWeatherData(newWeatherData)

	// Print the new weather data
	fmt.Println(">>Updated Weather Data:")
	weather.PrintStruct(weatherInstance.GetWeatherData(), "")

	// Fetch from API
	data, err := weatherInstance.FetchWeatherData("location", "2024-01-01", "2024-01-15", "us", "hours", "")
	if err != nil {
		fmt.Println("! Error fetching weather data:", err)
		return
	}
	fmt.Println(">>Fetched weather data:", data)

	// Get and set usage for the specific field of the weather data
	fmt.Printf("Query Cost: %d\n", weatherInstance.GetQueryCost())
	weatherInstance.SetQueryCost(50)
	fmt.Printf("Updated Query Cost: %d\n", weatherInstance.GetQueryCost())

	fmt.Printf("Latitude: %f\n", weatherInstance.GetLatitude())
	weatherInstance.SetLatitude(37.7749)
	fmt.Printf("Updated Latitude: %f\n", weatherInstance.GetLatitude())

	fmt.Printf("Longitude: %f\n", weatherInstance.GetLongitude())
	weatherInstance.SetLongitude(-122.4194)
	fmt.Printf("Updated Longitude: %f\n", weatherInstance.GetLongitude())

	fmt.Printf("Resolved Address: %s\n", weatherInstance.GetResolvedAddress())
	weatherInstance.SetResolvedAddress("San Francisco, CA, USA")
	fmt.Printf("Updated Resolved Address: %s\n", weatherInstance.GetResolvedAddress())

	fmt.Printf("Address: %s\n", weatherInstance.GetAddress())
	weatherInstance.SetAddress("San Francisco")
	fmt.Printf("Updated Address: %s\n", weatherInstance.GetAddress())

	fmt.Printf("Timezone: %s\n", weatherInstance.GetTimezone())
	weatherInstance.SetTimezone("PST")
	fmt.Printf("Updated Timezone: %s\n", weatherInstance.GetTimezone())

	fmt.Printf("Timezone Offset: %f\n", weatherInstance.GetTzoffset())
	weatherInstance.SetTzoffset(-8.0)
	fmt.Printf("Updated Timezone Offset: %f\n", weatherInstance.GetTzoffset())

	fmt.Printf("Stations: %v\n", weatherInstance.GetStations())
	weatherInstance.SetStations(map[string]weather.Station{
		"72585093228": {Distance: 10.0, Latitude: 37.65, Longitude: -122.12, UseCount: 0, ID: "72585093228", Name: "HAYWARD AIR TERMINAL, CA US", Quality: 100, Contribution: 0.0},
	})
	fmt.Printf("Updated Stations: %v\n", weatherInstance.GetStations())

	// Retrieve and print daily datetimes
	dailyDatetimes := weatherInstance.GetDailyDatetimes()
	fmt.Println("Daily Datetimes:")
	for _, dt := range dailyDatetimes {
		fmt.Println(dt.Format("2006-01-02"))
	}
	// Retrieve and print hourly datetimes
	hourlyDatetimes := weatherInstance.GetHourlyDatetimes()
	fmt.Println("Hourly Datetimes:", hourlyDatetimes)

	// --- Get and set the specific field on the specific date
	// using `GetFieldValueOnDay` and `SetFieldValueOnDay`
	tempmax, err := weatherInstance.GetFieldValueOnDay("2024-01-02", "Tempmax")
	if err != nil {
		fmt.Println("! Error getting field value:", err)
	}
	fmt.Printf("Tempmax on a day: %v\n", tempmax)

	err = weatherInstance.SetFieldValueOnDay("2024-01-02", "Tempmax", 26.0)
	if err != nil {
		fmt.Println("! Error setting field value:", err)
	}
	tempmax, _ = weatherInstance.GetFieldValueOnDay("2024-01-02", "Tempmax")
	fmt.Printf("Updated Tempmax on a day: %v\n", tempmax)

	// using seperate functions
	temp, _ := weatherInstance.GetTempOnDay("2024-01-02")
	fmt.Printf("Temp on a day: %v\n", temp)
	weatherInstance.SetTempOnDay("2024-01-02", 50)
	temp, _ = weatherInstance.GetTempOnDay(1)
	fmt.Printf("Updated temp on a day: %v\n", temp)

	// --- Get and set the specific field at the specific datetime
	// using seperate functions
	tempAtDatetime, _ := weatherInstance.GetTempAtDatetime("2024-01-02", "01:00:00")
	fmt.Printf("Temp at a datetime: %v\n", tempAtDatetime)
	weatherInstance.SetTempAtDatetime("2024-01-02", "01:00:00", 45)
	tempAtDatetime, _ = weatherInstance.GetTempAtDatetime(1, 1)
	fmt.Printf("Updated temp at a datetime: %v\n", tempAtDatetime)

}
