Imports System
Imports System.Collections.Specialized.BitVector32
Imports Demo.Library

Module Demo
    Sub Main(args As String())
        ' Create weather API object with API key
        Dim weatherData As New WeatherData("YOUR_API_KEY")

        ' Fetch weather data with location, from date, to date params.
        weatherData.FetchWeatherData("38.96%2C-96.02", "2020-7-10", "2020-7-12", "us", "events,hours", "")

        ' Daily weather data array list
        Dim weatherDailyData As List(Of WeatherDailyData) = weatherData.WeatherDailyData

        If weatherDailyData IsNot Nothing Then
            For Each dailyData As WeatherDailyData In weatherDailyData
                ' Print max temperature
                Console.WriteLine($"{dailyData.Datetime}, {dailyData.TempMax}")

                ' Print min temperature
                Console.WriteLine($"{dailyData.Datetime}, {dailyData.TempMin}")

                ' Print humidity
                Console.WriteLine($"{dailyData.Datetime}, {dailyData.Humidity}")

                ' Hourly weather data array list
                Dim weatherHourlyData As List(Of WeatherHourlyData) = dailyData.WeatherHourlyData
                If weatherHourlyData IsNot Nothing Then
                    For Each hourlyData As WeatherHourlyData In weatherHourlyData
                        ' Print temperature
                        Console.WriteLine($"{hourlyData.Datetime}, {hourlyData.Temp}")

                        ' Print humidity
                        Console.WriteLine($"{hourlyData.Datetime}, {hourlyData.Humidity}")
                    Next
                End If

                Dim events As List(Of [WEvent]) = dailyData.Events
                If events IsNot Nothing Then
                    For Each eventObj As [WEvent] In events
                        Console.WriteLine($"{eventObj.Datetime}, {eventObj.DatetimeEpoch}")
                    Next
                End If
            Next
        End If

        Dim stations As Dictionary(Of String, WStation) = weatherData.Stations
        If stations IsNot Nothing Then
            For Each element In stations
                Dim station As WStation = element.Value
                Console.WriteLine($"{element.Key}, {station.Name}")
                Console.WriteLine($"{element.Key}, {station.Id}")
                Console.WriteLine($"{element.Key}, {station.UseCount}")
            Next
        End If

        ' Initialize WeatherData object
        Dim weatherData1 As New WeatherData()

        ' Set API_KEY
        weatherData1.APIKey = "YOUR_API_KEY"

        ' Fetch weather data for a specific datetime
        weatherData1.FetchWeatherData("K2A1W1", "2021-10-19")

        ' Daily weather data object
        Dim weatherDailyData1 As List(Of WeatherDailyData) = weatherData1.WeatherDailyData

        If weatherDailyData1 IsNot Nothing Then
            For Each dailyData As WeatherDailyData In weatherDailyData1
                ' Print temperature
                Console.WriteLine($"{dailyData.Datetime}, {dailyData.TempMax}")
            Next
        End If

        ' Fetch forecast (15 days) weather data for the location
        weatherData1.FetchForecastData("K2A1W1")

        ' Daily weather data list
        Dim weatherDailyData2 As List(Of WeatherDailyData) = weatherData.WeatherDailyData

        If weatherDailyData2 IsNot Nothing Then
            For Each dailyData As WeatherDailyData In weatherDailyData2
                ' Print temperature
                Console.WriteLine($"{dailyData.Datetime}, {dailyData.TempMax}")
            Next
        End If

        ' Create another instance of WeatherData
        Dim weatherData2 As New WeatherData()
        weatherData2.APIKey = "YOUR_API_KEY"

    End Sub
End Module
