Imports System
Imports System.Collections.Generic
Imports System.Collections.Specialized.BitVector32
Imports System.IO
Imports System.Net
Imports System.Runtime.InteropServices.JavaScript.JSType
Imports Newtonsoft.Json.Linq

Namespace Library
    ''' <summary>
    ''' The WeatherData class is designed to interact with the Visual Crossing Weather API to fetch weather data for specific locations, dates, and times.
    ''' This class is equipped to handle various types of weather data requests, including current weather data, historical weather data, and weather forecasts.
    ''' The key functionalities of this class include constructing API requests, retrieving weather data, and parsing JSON responses to populate weather data models.
    ''' API_KEY: A private string variable that stores the API key required to authenticate requests to the Visual Crossing Weather API.
    ''' setAPI_KEY(String API_KEY) and getAPI_KEY(): Getters and setters for the API key, allowing it to be updated or retrieved after the instance has been created.
    ''' FetchWeatherData(location As String, fromdate As String, todate As String): Public method to fetch weather data between specific dates for a given location. This is particularly useful for retrieving historical weather data or future forecasts within a defined range.
    ''' FetchWeatherData(location As String, datetime As String): Overloaded method to fetch weather data for a specific date and location. This is useful for getting precise weather conditions on particular days.
    ''' FetchForecastData(location As String): Fetches the weather forecast for the next 15 days starting from midnight of the current day at the specified location. This method is ideal for applications requiring future weather predictions to plan activities or events.
    ''' FetchWeatherData(location As String, fromdate As String, todate As String, unitGroup As String, include As String, elements As String)
    ''' </summary>
    Public Class WeatherData
        Private _apiKey As String
        Public Shared ReadOnly BASE_URL As String = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"

        Private _queryCost As Long?
        Private _latitude As Double?
        Private _longitude As Double?
        Private _resolvedAddress As String
        Private _address As String
        Private _timezone As String
        Private _tzOffset As Double?
        Private _weatherDailyData As List(Of WeatherDailyData)
        Private _stations As Dictionary(Of String, WStation)

        Public Sub New()
        End Sub

        Public Sub New(apiKey As String)
            Me._apiKey = apiKey
        End Sub

        Public Property APIKey As String
            Get
                Return _apiKey
            End Get
            Set(value As String)
                _apiKey = value
            End Set
        End Property

        Public Property QueryCost As Long?
            Get
                Return _queryCost
            End Get
            Set(value As Long?)
                _queryCost = value
            End Set
        End Property

        Public Property Latitude As Double?
            Get
                Return _latitude
            End Get
            Set(value As Double?)
                _latitude = value
            End Set
        End Property

        Public Property Longitude As Double?
            Get
                Return _longitude
            End Get
            Set(value As Double?)
                _longitude = value
            End Set
        End Property

        Public Property ResolvedAddress As String
            Get
                Return _resolvedAddress
            End Get
            Set(value As String)
                _resolvedAddress = value
            End Set
        End Property

        Public Property Address As String
            Get
                Return _address
            End Get
            Set(value As String)
                _address = value
            End Set
        End Property

        Public Property Timezone As String
            Get
                Return _timezone
            End Get
            Set(value As String)
                _timezone = value
            End Set
        End Property

        Public Property TZOffset As Double?
            Get
                Return _tzOffset
            End Get
            Set(value As Double?)
                _tzOffset = value
            End Set
        End Property

        Public Property WeatherDailyData As List(Of WeatherDailyData)
            Get
                Return _weatherDailyData
            End Get
            Set(value As List(Of WeatherDailyData))
                _weatherDailyData = value
            End Set
        End Property

        Public Property Stations As Dictionary(Of String, WStation)
            Get
                Return _stations
            End Get
            Set(value As Dictionary(Of String, WStation))
                _stations = value
            End Set
        End Property

        Private Shared Function GetStringOrNull(jObject As JObject, key As String) As String
            Return If(jObject(key)?.ToString(), Nothing)
        End Function

        Private Shared Function GetDoubleOrNull(jObject As JObject, key As String) As Double?
            Return If(jObject(key)?.Type = JTokenType.Null, Nothing, CType(jObject(key), Double?))
        End Function

        Private Shared Function GetLongOrNull(jObject As JObject, key As String) As Long?
            Return If(jObject(key)?.Type = JTokenType.Null, Nothing, CType(jObject(key), Long?))
        End Function

        ''' <summary>
        ''' The FetchData function retrieves weather data by making an API request to the specified URL using the weather data API.
        ''' </summary>
        ''' <param name="url"></param>
        ''' <returns></returns>
        Private Function FetchData(url As String) As String
            Dim result As String = Nothing
            Dim request As HttpWebRequest = CType(WebRequest.Create(url), HttpWebRequest)
            request.Method = "GET"
            request.Headers("Authorization") = "Bearer " & _apiKey ' Adjust as per your auth method

            Using response As HttpWebResponse = CType(request.GetResponse(), HttpWebResponse)
                If response.StatusCode <> HttpStatusCode.OK Then
                    Throw New ApplicationException("Error code: " & response.StatusCode)
                End If

                Using reader As New StreamReader(response.GetResponseStream())
                    result = reader.ReadToEnd()
                End Using
            End Using

            Return result
        End Function
        Private Sub ClearWeatherData()
            If _weatherDailyData IsNot Nothing Then
                For Each element In _weatherDailyData
                    element.WeatherHourlyData?.Clear()
                    element.Events?.Clear()
                Next
            End If
            _weatherDailyData?.Clear()
            _stations?.Clear()
        End Sub

        ''' <summary>
        ''' The HandleWeatherData function parses JSON structure from a string.
        ''' </summary>
        ''' <param name="jsonString"></param>
        Private Sub HandleWeatherData(jsonString As String)
            ClearWeatherData()
            Dim obj As JObject = JObject.Parse(jsonString)

            _queryCost = CType(obj("queryCost"), Long?)
            _latitude = CType(obj("latitude"), Double?)
            _longitude = CType(obj("longitude"), Double?)
            _resolvedAddress = CType(obj("resolvedAddress"), String)
            _address = CType(obj("address"), String)
            _timezone = CType(obj("timezone"), String)
            _tzOffset = CType(obj("tzoffset"), Double?)
            _weatherDailyData = New List(Of WeatherDailyData)()
            Dim days As JArray = CType(obj("days"), JArray)
            For Each day As JObject In days
                Dim weatherDayData As WeatherDailyData = CreateWeatherDailyData(day)
                _weatherDailyData.Add(weatherDayData)
            Next

            Dim stationsJson As JObject = CType(obj("stations"), JObject)
            _stations = New Dictionary(Of String, WStation)()
            For Each kvp In stationsJson
                Dim stationObj As JObject = CType(kvp.Value, JObject)

                Dim station As New WStation With {
                    .Distance = CType(stationObj("distance"), Double?),
                    .Latitude = CType(stationObj("latitude"), Double?),
                    .Longitude = CType(stationObj("longitude"), Double?),
                    .UseCount = CType(stationObj("useCount"), Integer?),
                    .Id = CType(stationObj("id"), String),
                    .Name = CType(stationObj("name"), String),
                    .Quality = CType(stationObj("quality"), Integer?),
                    .Contribution = CType(stationObj("contribution"), Double?)
                }

                _stations(kvp.Key) = station
            Next
        End Sub

        ''' <summary>
        ''' The CreateWeatherDailyData function creates an hourly data object from a JSON object.
        ''' The function checks if a key in the JSON object is null and sets the corresponding property to null if it is.
        ''' Otherwise, it assigns the value from the JSON object to the property.
        ''' </summary>
        ''' <param name="day"></param>
        ''' <returns></returns>
        Private Function CreateWeatherDailyData(day As JObject) As WeatherDailyData
            Dim weatherDailyData As New WeatherDailyData()

            ' Access fields within each 'day' object
            weatherDailyData.Datetime = DateTime.Parse(day("datetime").ToString())
            weatherDailyData.DatetimeEpoch = GetLongOrNull(day, "datetimeEpoch")
            weatherDailyData.TempMax = GetDoubleOrNull(day, "tempmax")
            weatherDailyData.TempMin = GetDoubleOrNull(day, "tempmin")
            weatherDailyData.Temp = GetDoubleOrNull(day, "temp")
            weatherDailyData.FeelsLikeMax = GetDoubleOrNull(day, "feelslikemax")
            weatherDailyData.FeelsLikeMin = GetDoubleOrNull(day, "feelslikemin")
            weatherDailyData.FeelsLike = GetDoubleOrNull(day, "feelslike")
            weatherDailyData.Dew = GetDoubleOrNull(day, "dew")
            weatherDailyData.Humidity = GetDoubleOrNull(day, "humidity")
            weatherDailyData.Precip = GetDoubleOrNull(day, "precip")
            weatherDailyData.PrecipProb = GetDoubleOrNull(day, "precipprob")
            weatherDailyData.PrecipCover = GetDoubleOrNull(day, "precipcover")

            If day("preciptype")?.Type = JTokenType.Null OrElse day("preciptype") Is Nothing Then
                weatherDailyData.PrecipType = Nothing
            Else
                Dim precipTypes As JArray = CType(day("preciptype"), JArray)
                Dim typeList As New List(Of String)()
                For Each type In precipTypes
                    typeList.Add(CType(type, String))
                Next
                weatherDailyData.PrecipType = typeList
            End If

            weatherDailyData.Snow = GetDoubleOrNull(day, "snow")
            weatherDailyData.SnowDepth = GetDoubleOrNull(day, "snowdepth")
            weatherDailyData.WindGust = GetDoubleOrNull(day, "windgust")
            weatherDailyData.WindSpeed = GetDoubleOrNull(day, "windspeed")
            weatherDailyData.WindDir = GetDoubleOrNull(day, "winddir")
            weatherDailyData.Pressure = GetDoubleOrNull(day, "pressure")
            weatherDailyData.CloudCover = GetDoubleOrNull(day, "cloudcover")
            weatherDailyData.Visibility = GetDoubleOrNull(day, "visibility")
            weatherDailyData.SolarRadiation = GetDoubleOrNull(day, "solarradiation")
            weatherDailyData.SolarEnergy = GetDoubleOrNull(day, "solarenergy")
            weatherDailyData.UvIndex = GetDoubleOrNull(day, "uvindex")
            weatherDailyData.Sunrise = GetStringOrNull(day, "sunrise")
            weatherDailyData.SunriseEpoch = GetLongOrNull(day, "sunriseEpoch")
            weatherDailyData.Sunset = GetStringOrNull(day, "sunset")
            weatherDailyData.SunsetEpoch = GetLongOrNull(day, "sunsetEpoch")
            weatherDailyData.MoonPhase = GetDoubleOrNull(day, "moonphase")
            weatherDailyData.Conditions = GetStringOrNull(day, "conditions")
            weatherDailyData.Description = GetStringOrNull(day, "description")
            weatherDailyData.Icon = GetStringOrNull(day, "icon")

            If day("stations")?.Type = JTokenType.Null OrElse day("stations") Is Nothing Then
                weatherDailyData.Stations = Nothing
            Else
                Dim stations As JArray = CType(day("stations"), JArray)
                Dim stationList As New List(Of String)()
                For Each station In stations
                    stationList.Add(CType(station, String))
                Next
                weatherDailyData.Stations = stationList
            End If

            If day("events")?.Type = JTokenType.Null OrElse day("events") Is Nothing Then
                weatherDailyData.Events = Nothing
            Else
                Dim events As JArray = CType(day("events"), JArray)
                Dim eventList As New List(Of [WEvent])()
                For Each eventObj As JObject In events
                    Dim eventItem As New [WEvent] With {
                        .Datetime = DateTime.Parse(eventObj("datetime").ToString()),
                        .DatetimeEpoch = GetLongOrNull(eventObj, "datetimeEpoch"),
                        .Type = GetStringOrNull(eventObj, "type"),
                        .Latitude = GetDoubleOrNull(eventObj, "latitude"),
                        .Longitude = GetDoubleOrNull(eventObj, "longitude"),
                        .Distance = GetDoubleOrNull(eventObj, "distance"),
                        .Description = GetStringOrNull(eventObj, "description"),
                        .Size = GetDoubleOrNull(eventObj, "size")
                    }
                    eventList.Add(eventItem)
                Next
                weatherDailyData.Events = eventList
            End If

            If day("hours")?.Type = JTokenType.Null OrElse day("hours") Is Nothing Then
                weatherDailyData.WeatherHourlyData = Nothing
            Else
                Dim hours As JArray = CType(day("hours"), JArray)
                Dim hourlyDataList As New List(Of WeatherHourlyData)()
                For Each hour As JObject In hours
                    Dim hourlyData As WeatherHourlyData = CreateHourlyData(hour)
                    hourlyDataList.Add(hourlyData)
                Next
                weatherDailyData.WeatherHourlyData = hourlyDataList
            End If

            weatherDailyData.Source = GetStringOrNull(day, "source")

            Return weatherDailyData
        End Function

        ''' <summary>
        ''' The CreateHourlyData function creates an hourly data object from a JSON object.
        ''' The function checks if a key in the JSON object is null and sets the corresponding property to null if it is.
        ''' Otherwise, it assigns the value from the JSON object to the property.
        ''' </summary>
        ''' <param name="hour"></param>
        ''' <returns></returns>
        Private Function CreateHourlyData(hour As JObject) As WeatherHourlyData
            Dim weatherHourlyData As New WeatherHourlyData()

            weatherHourlyData.Datetime = TimeSpan.Parse(hour("datetime").ToString())
            weatherHourlyData.DatetimeEpoch = GetLongOrNull(hour, "datetimeEpoch")
            weatherHourlyData.Temp = GetDoubleOrNull(hour, "temp")
            weatherHourlyData.Feelslike = GetDoubleOrNull(hour, "feelslike")
            weatherHourlyData.Humidity = GetDoubleOrNull(hour, "humidity")
            weatherHourlyData.Dew = GetDoubleOrNull(hour, "dew")
            weatherHourlyData.Precip = GetDoubleOrNull(hour, "precip")
            weatherHourlyData.PrecipProb = GetDoubleOrNull(hour, "precipprob")
            weatherHourlyData.Snow = GetDoubleOrNull(hour, "snow")
            weatherHourlyData.SnowDepth = GetDoubleOrNull(hour, "snowdepth")

            If hour("preciptype")?.Type = JTokenType.Null OrElse hour("preciptype") Is Nothing Then
                weatherHourlyData.PrecipType = Nothing
            Else
                Dim precipTypes As JArray = CType(hour("preciptype"), JArray)
                Dim typeList As New List(Of String)()
                For Each type In precipTypes
                    typeList.Add(CType(type, String))
                Next
                weatherHourlyData.PrecipType = typeList
            End If

            weatherHourlyData.WindGust = GetDoubleOrNull(hour, "windgust")
            weatherHourlyData.WindSpeed = GetDoubleOrNull(hour, "windspeed")
            weatherHourlyData.WindDir = GetDoubleOrNull(hour, "winddir")
            weatherHourlyData.Pressure = GetDoubleOrNull(hour, "pressure")
            weatherHourlyData.Visibility = GetDoubleOrNull(hour, "visibility")
            weatherHourlyData.CloudCover = GetDoubleOrNull(hour, "cloudcover")
            weatherHourlyData.SolarRadiation = GetDoubleOrNull(hour, "solarradiation")
            weatherHourlyData.SolarEnergy = GetDoubleOrNull(hour, "solarenergy")
            weatherHourlyData.UvIndex = GetDoubleOrNull(hour, "uvindex")
            weatherHourlyData.Conditions = GetStringOrNull(hour, "conditions")
            weatherHourlyData.Icon = GetStringOrNull(hour, "icon")

            If hour("stations")?.Type = JTokenType.Null OrElse hour("stations") Is Nothing Then
                weatherHourlyData.Stations = Nothing
            Else
                Dim stations As JArray = CType(hour("stations"), JArray)
                Dim stationList As New List(Of String)()
                For Each station In stations
                    stationList.Add(CType(station, String))
                Next
                weatherHourlyData.Stations = stationList
            End If

            weatherHourlyData.Source = GetStringOrNull(hour, "source")

            Return weatherHourlyData
        End Function

        ''' <summary>
        ''' The FetchWeatherData function will fetch weather data from params.
        ''' </summary>
        ''' <param name="location"></param>
        ''' <param name="fromdate"></param>
        ''' <param name="todate"></param>
        ''' <param name="unitGroup"></param>
        ''' <param name="include"></param>
        ''' <param name="elements"></param>
        Public Sub FetchWeatherData(location As String, fromdate As String, todate As String, unitGroup As String, include As String, elements As String)
            Try
                ' Check API
                If String.IsNullOrEmpty(APIKey) Then
                    Throw New InvalidOperationException("API key is not set.")
                End If

                ' Construct the URL by appending the location and API key to the base URL
                Dim urlString As String = $"{BASE_URL}{location}/{fromdate}/{todate}?key={APIKey}&include={include}&elements={elements}&unitGroup={unitGroup}"

                ' Fetch data from the API
                Dim jsonString As String = FetchData(urlString)

                HandleWeatherData(jsonString)
            Catch e As Exception
                Console.WriteLine(e.Message)
            End Try
        End Sub

        ''' <summary>
        ''' The FetchWeatherData function will fetch weather data from first date to second date.
        ''' </summary>
        ''' <param name="location"></param>
        ''' <param name="fromdate"></param>
        ''' <param name="todate"></param>
        Public Sub FetchWeatherData(location As String, fromdate As String, todate As String)
            Try
                ' Check API
                If String.IsNullOrEmpty(APIKey) Then
                    Throw New InvalidOperationException("API key is not set.")
                End If

                ' Construct the URL by appending the location and API key to the base URL
                Dim urlString As String = $"{BASE_URL}{location}/{fromdate}/{todate}?key={APIKey}"

                ' Fetch data from the API
                Dim jsonString As String = FetchData(urlString)

                ' Process the JSON string containing the weather data
                HandleWeatherData(jsonString)
            Catch e As Exception
                Console.WriteLine($"Error fetching weather data: {e.Message}")
            End Try
        End Sub

        ''' <summary>
        ''' The FetchWeatherData function will fetch weather data for a specific datetime.
        ''' </summary>
        ''' <param name="location"></param>
        ''' <param name="datetime"></param>
        Public Sub FetchWeatherData(location As String, datetime As String)
            Try
                ' Check API
                If String.IsNullOrEmpty(APIKey) Then
                    Throw New InvalidOperationException("API key is not set.")
                End If

                ' Construct the URL by appending the location and API key to the base URL
                Dim urlString As String = $"{BASE_URL}{location}/{datetime}?key={APIKey}"

                ' Fetch data from the API
                Dim jsonString As String = FetchData(urlString)

                ' Process the JSON string containing the weather data
                HandleWeatherData(jsonString)
            Catch e As Exception
                Console.WriteLine($"Error fetching weather data: {e.Message}")
            End Try
        End Sub

        ''' <summary>
        ''' The FetchForecastData function will fetch the weather forecast for location for the next 15 days
        ''' starting at midnight at the start of the current day (local time of the requested location).
        ''' </summary>
        ''' <param name="location"></param>
        Public Sub FetchForecastData(location As String)
            Try
                ' Check API
                If String.IsNullOrEmpty(APIKey) Then
                    Throw New InvalidOperationException("API key is not set.")
                End If

                ' Construct the URL by appending the location and API key to the base URL
                Dim urlString As String = $"{BASE_URL}{location}?key={APIKey}"

                ' Fetch data from the API
                Dim jsonString As String = FetchData(urlString)

                ' Process the JSON string containing the weather data
                HandleWeatherData(jsonString)
            Catch e As Exception
                Console.WriteLine($"Error fetching weather data: {e.Message}")
            End Try
        End Sub
    End Class
End Namespace
