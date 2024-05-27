package weather

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	// for print
	"reflect"
)

// Define the struct types to match the JSON structure
type WeatherData struct {
	QueryCost       int                `json:"queryCost"`
	Latitude        float64            `json:"latitude"`
	Longitude       float64            `json:"longitude"`
	ResolvedAddress string             `json:"resolvedAddress"`
	Address         string             `json:"address"`
	Timezone        string             `json:"timezone"`
	Tzoffset        float64            `json:"tzoffset"`
	Days            []Day              `json:"days"`
	Stations        map[string]Station `json:"stations"`
}

type Day struct {
	Datetime       string   `json:"datetime"`
	DatetimeEpoch  int64    `json:"datetimeEpoch"`
	Tempmax        float64  `json:"tempmax"`
	Tempmin        float64  `json:"tempmin"`
	Temp           float64  `json:"temp"`
	Feelslikemax   float64  `json:"feelslikemax"`
	Feelslikemin   float64  `json:"feelslikemin"`
	Feelslike      float64  `json:"feelslike"`
	Dew            float64  `json:"dew"`
	Humidity       float64  `json:"humidity"`
	Precip         float64  `json:"precip"`
	Precipprob     float64  `json:"precipprob"`
	Precipcover    float64  `json:"precipcover"`
	Preciptype     []string `json:"preciptype"`
	Snow           float64  `json:"snow"`
	Snowdepth      float64  `json:"snowdepth"`
	Windgust       float64  `json:"windgust"`
	Windspeed      float64  `json:"windspeed"`
	Winddir        float64  `json:"winddir"`
	Pressure       float64  `json:"pressure"`
	Cloudcover     float64  `json:"cloudcover"`
	Visibility     float64  `json:"visibility"`
	Solarradiation float64  `json:"solarradiation"`
	Solarenergy    float64  `json:"solarenergy"`
	Uvindex        float64  `json:"uvindex"`
	Severerisk     float64  `json:"severerisk"`
	Sunrise        string   `json:"sunrise"`
	SunriseEpoch   int64    `json:"sunriseEpoch"`
	Sunset         string   `json:"sunset"`
	SunsetEpoch    int64    `json:"sunsetEpoch"`
	Moonphase      float64  `json:"moonphase"`
	Conditions     string   `json:"conditions"`
	Description    string   `json:"description"`
	Icon           string   `json:"icon"`
	Stations       []string `json:"stations"`
	Source         string   `json:"source"`
	Hours          []Hour   `json:"hours"`
	Events         []Event  `json:"events"`
}

type Hour struct {
	Datetime       string   `json:"datetime"`
	DatetimeEpoch  int64    `json:"datetimeEpoch"`
	Temp           float64  `json:"temp"`
	Feelslike      float64  `json:"feelslike"`
	Humidity       float64  `json:"humidity"`
	Dew            float64  `json:"dew"`
	Precip         float64  `json:"precip"`
	Precipprob     float64  `json:"precipprob"`
	Snow           float64  `json:"snow"`
	Snowdepth      float64  `json:"snowdepth"`
	Preciptype     []string `json:"preciptype"`
	Windgust       float64  `json:"windgust"`
	Windspeed      float64  `json:"windspeed"`
	Winddir        float64  `json:"winddir"`
	Pressure       float64  `json:"pressure"`
	Visibility     float64  `json:"visibility"`
	Cloudcover     float64  `json:"cloudcover"`
	Solarradiation float64  `json:"solarradiation"`
	Solarenergy    float64  `json:"solarenergy"`
	Uvindex        float64  `json:"uvindex"`
	Severerisk     float64  `json:"severerisk"`
	Conditions     string   `json:"conditions"`
	Icon           string   `json:"icon"`
	Stations       []string `json:"stations"`
	Source         string   `json:"source"`
}

type Event struct {
	Datetime      string  `json:"datetime"`
	DatetimeEpoch int64   `json:"datetimeEpoch"`
	Type          string  `json:"type"`
	Latitude      float64 `json:"latitude"`
	Longitude     float64 `json:"longitude"`
	Distance      float64 `json:"distance"`
	Desc          string  `json:"desc"`
	Size          float64 `json:"size"`
}

type Station struct {
	Distance     float64 `json:"distance"`
	Latitude     float64 `json:"latitude"`
	Longitude    float64 `json:"longitude"`
	UseCount     int     `json:"useCount"`
	ID           string  `json:"id"`
	Name         string  `json:"name"`
	Quality      int     `json:"quality"`
	Contribution float64 `json:"contribution"`
}

// Weather struct to hold weather data
type Weather struct {
	BaseURL     string
	APIKey      string
	weatherData WeatherData
}

// NewWeather initializes a new Weather instance
func NewWeather(baseURL, apiKey string, data ...[]byte) (*Weather, error) {
	var weatherData WeatherData
	if len(data) > 0 {
		err := json.Unmarshal(data[0], &weatherData)
		if err != nil {
			return nil, err
		}
	}

	return &Weather{
		BaseURL:     baseURL,
		APIKey:      apiKey,
		weatherData: weatherData,
	}, nil
}

// FetchWeatherData fetches weather data for a specified location and date range.
func (w *Weather) FetchWeatherData(location, fromDate, toDate, unitGroup, include, elements string) (WeatherData, error) {
	params := fmt.Sprintf("?unitGroup=%s&include=%s&key=%s&elements=%s", unitGroup, include, w.APIKey, elements)
	url := fmt.Sprintf("%s/%s/%s/%s%s", w.BaseURL, location, fromDate, toDate, params)
	resp, err := http.Get(url)
	if err != nil {
		return WeatherData{}, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return WeatherData{}, fmt.Errorf("failed to fetch weather data: %s", resp.Status)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return WeatherData{}, err
	}

	err = json.Unmarshal(body, &w.weatherData)
	if err != nil {
		return WeatherData{}, err
	}

	return w.weatherData, nil
}

// GetWeatherData gets the stored weather data.
func (w *Weather) GetWeatherData(elements ...[]string) WeatherData {
	var weatherData WeatherData
	if len(elements) > 0 {
		weatherData = filterWeatherDataByElements(w.weatherData, elements[0])
	} else {
		weatherData = w.weatherData
	}
	return weatherData
}

// SetWeatherData sets the internal weather data.
func (w *Weather) SetWeatherData(data WeatherData) {
	w.weatherData = data
}

// GetWeatherDailyData gets daily weather data, optionally filtered by elements.
func (w *Weather) GetWeatherDailyData(elements ...[]string) []Day {
	var daysData []Day
	for _, day := range w.weatherData.Days {
		if len(elements) > 0 {
			filteredDay := filterDayByElements(day, elements[0])
			daysData = append(daysData, filteredDay)
		} else {
			daysData = append(daysData, day)
		}
	}
	return daysData
}

// SetWeatherDailyData sets the daily weather data.
func (w *Weather) SetWeatherDailyData(dailyData []Day) {
	w.weatherData.Days = dailyData
}

// GetWeatherHourlyData gets hourly weather data for all days, optionally filtered by elements.
func (w *Weather) GetWeatherHourlyData(elements ...[]string) []Hour {
	var hourlyData []Hour
	for _, day := range w.weatherData.Days {
		for _, hour := range day.Hours {
			if len(elements) > 0 {
				filteredHour := filterHourByElements(hour, elements[0])
				hourlyData = append(hourlyData, filteredHour)
			} else {
				hourlyData = append(hourlyData, hour)
			}
		}
	}
	return hourlyData
}

// GetQueryCost retrieves the cost of the query.
func (w *Weather) GetQueryCost() int {
	return w.weatherData.QueryCost
}

// SetQueryCost sets the cost of the query.
func (w *Weather) SetQueryCost(value int) {
	w.weatherData.QueryCost = value
}

// GetLatitude retrieves the latitude.
func (w *Weather) GetLatitude() float64 {
	return w.weatherData.Latitude
}

// SetLatitude sets the latitude.
func (w *Weather) SetLatitude(value float64) {
	w.weatherData.Latitude = value
}

// GetLongitude retrieves the longitude.
func (w *Weather) GetLongitude() float64 {
	return w.weatherData.Longitude
}

// SetLongitude sets the longitude.
func (w *Weather) SetLongitude(value float64) {
	w.weatherData.Longitude = value
}

// GetResolvedAddress retrieves the resolved address.
func (w *Weather) GetResolvedAddress() string {
	return w.weatherData.ResolvedAddress
}

// SetResolvedAddress sets the resolved address.
func (w *Weather) SetResolvedAddress(value string) {
	w.weatherData.ResolvedAddress = value
}

// GetAddress retrieves the address.
func (w *Weather) GetAddress() string {
	return w.weatherData.Address
}

// SetAddress sets the address.
func (w *Weather) SetAddress(value string) {
	w.weatherData.Address = value
}

// GetTimezone retrieves the timezone.
func (w *Weather) GetTimezone() string {
	return w.weatherData.Timezone
}

// SetTimezone sets the timezone.
func (w *Weather) SetTimezone(value string) {
	w.weatherData.Timezone = value
}

// GetTzoffset retrieves the timezone offset.
func (w *Weather) GetTzoffset() float64 {
	return w.weatherData.Tzoffset
}

// SetTzoffset sets the timezone offset.
func (w *Weather) SetTzoffset(value float64) {
	w.weatherData.Tzoffset = value
}

// GetStations retrieves the list of weather stations.
func (w *Weather) GetStations() map[string]Station {
	return w.weatherData.Stations
}

// SetStations sets the list of weather stations.
func (w *Weather) SetStations(value map[string]Station) {
	w.weatherData.Stations = value
}

// GetDailyDatetimes retrieves a list of datetime objects representing each day's date from the weather data.
func (w *Weather) GetDailyDatetimes() []time.Time {
	var datetimes []time.Time
	for _, day := range w.weatherData.Days {
		datetime, _ := time.Parse("2006-01-02", day.Datetime)
		datetimes = append(datetimes, datetime)
	}
	return datetimes
}

// GetHourlyDatetimes retrieves a list of datetime objects representing each hour's datetime from the weather data.
func (w *Weather) GetHourlyDatetimes() []time.Time {
	var datetimes []time.Time
	for _, day := range w.weatherData.Days {
		for _, hour := range day.Hours {
			datetime, _ := time.Parse("2006-01-02 15:04:05", fmt.Sprintf("%s %s", day.Datetime, hour.Datetime))
			datetimes = append(datetimes, datetime)
		}
	}
	return datetimes
}

// GetDataOnDay retrieves weather data for a specific day based on a date string or index.
func (w *Weather) GetDataOnDay(dayInfo interface{}, elements []string) (Day, error) {
	var dayData Day
	var err error

	switch v := dayInfo.(type) {
	case string:
		for _, day := range w.weatherData.Days {
			if day.Datetime == v {
				dayData = day
				break
			}
		}
	case int:
		if v >= 0 && v < len(w.weatherData.Days) {
			dayData = w.weatherData.Days[v]
		} else {
			err = fmt.Errorf("index out of range")
		}
	default:
		err = fmt.Errorf("invalid input value for GetDataOnDay with str or int: %v", dayInfo)
	}

	if err != nil {
		return Day{}, err
	}

	if len(elements) > 0 {
		filteredData := Day{}
		filteredData = filterDayByElements(dayData, elements)
		filteredData.Datetime = dayData.Datetime // Keeping datetime as it is the identifier
		return filteredData, nil
	}

	return dayData, nil
}

// SetDataOnDay updates weather data for a specific day based on a date string or index.
func (w *Weather) SetDataOnDay(dayInfo interface{}, data Day) error {
	switch v := dayInfo.(type) {
	case string:
		for i, day := range w.weatherData.Days {
			if day.Datetime == v {
				w.weatherData.Days[i] = data
				return nil
			}
		}
	case int:
		if v >= 0 && v < len(w.weatherData.Days) {
			w.weatherData.Days[v] = data
			return nil
		}
	default:
		return fmt.Errorf("invalid input value for SetDataOnDay with str or int: %v", dayInfo)
	}
	return fmt.Errorf("day not found")
}

// GetFieldValueOnDay retrieves the value of the specified field in the Day struct based on dayInfo.
func (w *Weather) GetFieldValueOnDay(dayInfo interface{}, fieldName string) (interface{}, error) {
	var day Day
	switch v := dayInfo.(type) {
	case string:
		for _, d := range w.weatherData.Days {
			if d.Datetime == v {
				day = d
				break
			}
		}
	case int:
		if v >= 0 && v < len(w.weatherData.Days) {
			day = w.weatherData.Days[v]
		} else {
			return nil, fmt.Errorf("index out of range: %d", v)
		}
	default:
		return nil, fmt.Errorf("invalid dayInfo type: %T", v)
	}

	val := reflect.ValueOf(day)
	fieldVal := val.FieldByName(fieldName)
	if !fieldVal.IsValid() {
		return nil, fmt.Errorf("invalid field name: %s", fieldName)
	}
	return fieldVal.Interface(), nil
}

// SetFieldValueOnDay sets the value of the specified field in the Day struct based on dayInfo.
func (w *Weather) SetFieldValueOnDay(dayInfo interface{}, fieldName string, value interface{}) error {
	var dayIndex int
	switch v := dayInfo.(type) {
	case string:
		for i, d := range w.weatherData.Days {
			if d.Datetime == v {
				dayIndex = i
				break
			}
		}
	case int:
		if v >= 0 && v < len(w.weatherData.Days) {
			dayIndex = v
		} else {
			return fmt.Errorf("index out of range: %d", v)
		}
	default:
		return fmt.Errorf("invalid dayInfo type: %T", v)
	}

	day := &w.weatherData.Days[dayIndex]
	val := reflect.ValueOf(day).Elem()
	fieldVal := val.FieldByName(fieldName)
	if !fieldVal.IsValid() {
		return fmt.Errorf("invalid field name: %s", fieldName)
	}

	newVal := reflect.ValueOf(value)
	if !newVal.Type().AssignableTo(fieldVal.Type()) {
		return fmt.Errorf("cannot assign value of type %T to field %s of type %s", value, fieldName, fieldVal.Type())
	}
	fieldVal.Set(newVal)
	return nil
}

// GetDatetimeEpochOnDay retrieves the datetimeEpoch for a specific day identified by date or index.
func (w *Weather) GetDatetimeEpochOnDay(dayInfo interface{}) (int64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.DatetimeEpoch, nil
}

// SetDatetimeEpochOnDay sets the datetimeEpoch for a specific day identified by date or index.
func (w *Weather) SetDatetimeEpochOnDay(dayInfo interface{}, value int64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.DatetimeEpoch = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetTempOnDay retrieves the temperature for a specific day identified by date or index.
func (w *Weather) GetTempOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Temp, nil
}

// SetTempOnDay sets the temperature for a specific day identified by date or index.
func (w *Weather) SetTempOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Temp = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetTempmaxOnDay retrieves the maximum temperature for a specific day identified by date or index.
func (w *Weather) GetTempmaxOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Tempmax, nil
}

// SetTempmaxOnDay sets the maximum temperature for a specific day identified by date or index.
func (w *Weather) SetTempmaxOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Tempmax = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetTempminOnDay retrieves the minimum temperature for a specific day identified by date or index.
func (w *Weather) GetTempminOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Tempmin, nil
}

// SetTempminOnDay sets the minimum temperature for a specific day identified by date or index.
func (w *Weather) SetTempminOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Tempmin = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetFeelslikeOnDay retrieves the 'feels like' temperature for a specific day identified by date or index.
func (w *Weather) GetFeelslikeOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Feelslike, nil
}

// SetFeelslikeOnDay sets the 'feels like' temperature for a specific day identified by date or index.
func (w *Weather) SetFeelslikeOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Feelslike = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetFeelslikemaxOnDay retrieves the maximum 'feels like' temperature for a specific day identified by date or index.
func (w *Weather) GetFeelslikemaxOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Feelslikemax, nil
}

// SetFeelslikemaxOnDay sets the maximum 'feels like' temperature for a specific day identified by date or index.
func (w *Weather) SetFeelslikemaxOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Feelslikemax = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetFeelslikeminOnDay retrieves the minimum 'feels like' temperature for a specific day identified by date or index.
func (w *Weather) GetFeelslikeminOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Feelslikemin, nil
}

// SetFeelslikeminOnDay sets the minimum 'feels like' temperature for a specific day identified by date or index.
func (w *Weather) SetFeelslikeminOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Feelslikemin = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetDewOnDay retrieves the dew point for a specific day identified by date or index.
func (w *Weather) GetDewOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Dew, nil
}

// SetDewOnDay sets the dew point for a specific day identified by date or index.
func (w *Weather) SetDewOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Dew = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetHumidityOnDay retrieves the humidity percentage for a specific day identified by date or index.
func (w *Weather) GetHumidityOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Humidity, nil
}

// SetHumidityOnDay sets the humidity percentage for a specific day identified by date or index.
func (w *Weather) SetHumidityOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Humidity = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetPrecipOnDay retrieves the precipitation amount for a specific day identified by date or index.
func (w *Weather) GetPrecipOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Precip, nil
}

// SetPrecipOnDay sets the precipitation amount for a specific day identified by date or index.
func (w *Weather) SetPrecipOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Precip = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetPrecipprobOnDay retrieves the probability of precipitation for a specific day identified by date or index.
func (w *Weather) GetPrecipprobOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Precipprob, nil
}

// SetPrecipprobOnDay sets the probability of precipitation for a specific day identified by date or index.
func (w *Weather) SetPrecipprobOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Precipprob = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetPrecipcoverOnDay retrieves the precipitation coverage for a specific day identified by date or index.
func (w *Weather) GetPrecipcoverOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Precipcover, nil
}

// SetPrecipcoverOnDay sets the precipitation coverage for a specific day identified by date or index.
func (w *Weather) SetPrecipcoverOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Precipcover = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetPreciptypeOnDay retrieves the type of precipitation for a specific day identified by date or index.
func (w *Weather) GetPreciptypeOnDay(dayInfo interface{}) ([]string, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return nil, err
	}
	return dayData.Preciptype, nil
}

// SetPreciptypeOnDay sets the type of precipitation for a specific day identified by date or index.
func (w *Weather) SetPreciptypeOnDay(dayInfo interface{}, value []string) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Preciptype = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetSnowOnDay retrieves the snowfall amount for a specific day identified by date or index.
func (w *Weather) GetSnowOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Snow, nil
}

// SetSnowOnDay sets the snowfall amount for a specific day identified by date or index.
func (w *Weather) SetSnowOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Snow = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetSnowdepthOnDay retrieves the snow depth for a specific day identified by date or index.
func (w *Weather) GetSnowdepthOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Snowdepth, nil
}

// SetSnowdepthOnDay sets the snow depth for a specific day identified by date or index.
func (w *Weather) SetSnowdepthOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Snowdepth = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetWindgustOnDay retrieves the wind gust speed for a specific day identified by date or index.
func (w *Weather) GetWindgustOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Windgust, nil
}

// SetWindgustOnDay sets the wind gust speed for a specific day identified by date or index.
func (w *Weather) SetWindgustOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Windgust = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetWindspeedOnDay retrieves the wind speed for a specific day identified by date or index.
func (w *Weather) GetWindspeedOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Windspeed, nil
}

// SetWindspeedOnDay sets the wind speed for a specific day identified by date or index.
func (w *Weather) SetWindspeedOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Windspeed = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetWinddirOnDay retrieves the wind direction for a specific day identified by date or index.
func (w *Weather) GetWinddirOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Winddir, nil
}

// SetWinddirOnDay sets the wind direction for a specific day identified by date or index.
func (w *Weather) SetWinddirOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Winddir = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetPressureOnDay retrieves the atmospheric pressure for a specific day identified by date or index.
func (w *Weather) GetPressureOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Pressure, nil
}

// SetPressureOnDay sets the atmospheric pressure for a specific day identified by date or index.
func (w *Weather) SetPressureOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Pressure = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetCloudcoverOnDay retrieves the cloud cover percentage for a specific day identified by date or index.
func (w *Weather) GetCloudcoverOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Cloudcover, nil
}

// SetCloudcoverOnDay sets the cloud cover percentage for a specific day identified by date or index.
func (w *Weather) SetCloudcoverOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Cloudcover = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetVisibilityOnDay retrieves the visibility for a specific day identified by date or index.
func (w *Weather) GetVisibilityOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Visibility, nil
}

// SetVisibilityOnDay sets the visibility for a specific day identified by date or index.
func (w *Weather) SetVisibilityOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Visibility = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetSolarradiationOnDay retrieves the solar radiation for a specific day identified by date or index.
func (w *Weather) GetSolarradiationOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Solarradiation, nil
}

// SetSolarradiationOnDay sets the solar radiation for a specific day identified by date or index.
func (w *Weather) SetSolarradiationOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Solarradiation = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetSolarenergyOnDay retrieves the solar energy for a specific day identified by date or index.
func (w *Weather) GetSolarenergyOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Solarenergy, nil
}

// SetSolarenergyOnDay sets the solar energy for a specific day identified by date or index.
func (w *Weather) SetSolarenergyOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Solarenergy = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetUVIndexOnDay retrieves the UV index for a specific day identified by date or index.
func (w *Weather) GetUVIndexOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Uvindex, nil
}

// SetUVIndexOnDay sets the UV index for a specific day identified by date or index.
func (w *Weather) SetUVIndexOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Uvindex = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetSevereriskOnDay retrieves the severe weather risk level for a specific day identified by date or index.
func (w *Weather) GetSevereriskOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Severerisk, nil
}

// SetSevereriskOnDay sets the severe weather risk level for a specific day identified by date or index.
func (w *Weather) SetSevereriskOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Severerisk = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetSunriseOnDay retrieves the sunrise time for a specific day identified by date or index.
func (w *Weather) GetSunriseOnDay(dayInfo interface{}) (string, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return "", err
	}
	return dayData.Sunrise, nil
}

// SetSunriseOnDay sets the sunrise time for a specific day identified by date or index.
func (w *Weather) SetSunriseOnDay(dayInfo interface{}, value string) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Sunrise = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetSunriseEpochOnDay retrieves the Unix timestamp for the sunrise time for a specific day.
func (w *Weather) GetSunriseEpochOnDay(dayInfo interface{}) (int64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.SunriseEpoch, nil
}

// SetSunriseEpochOnDay sets the Unix timestamp for the sunrise time for a specific day.
func (w *Weather) SetSunriseEpochOnDay(dayInfo interface{}, value int64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.SunriseEpoch = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetSunsetOnDay retrieves the sunset time for a specific day identified by date or index.
func (w *Weather) GetSunsetOnDay(dayInfo interface{}) (string, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return "", err
	}
	return dayData.Sunset, nil
}

// SetSunsetOnDay sets the sunset time for a specific day identified by date or index.
func (w *Weather) SetSunsetOnDay(dayInfo interface{}, value string) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Sunset = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetSunsetEpochOnDay retrieves the Unix timestamp for the sunset time for a specific day.
func (w *Weather) GetSunsetEpochOnDay(dayInfo interface{}) (int64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.SunsetEpoch, nil
}

// SetSunsetEpochOnDay sets the Unix timestamp for the sunset time for a specific day.
func (w *Weather) SetSunsetEpochOnDay(dayInfo interface{}, value int64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.SunsetEpoch = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetMoonphaseOnDay retrieves the moon phase for a specific day identified by date or index.
func (w *Weather) GetMoonphaseOnDay(dayInfo interface{}) (float64, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return 0, err
	}
	return dayData.Moonphase, nil
}

// SetMoonphaseOnDay sets the moon phase for a specific day identified by date or index.
func (w *Weather) SetMoonphaseOnDay(dayInfo interface{}, value float64) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Moonphase = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetConditionsOnDay retrieves the weather conditions for a specific day identified by date or index.
func (w *Weather) GetConditionsOnDay(dayInfo interface{}) (string, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return "", err
	}
	return dayData.Conditions, nil
}

// SetConditionsOnDay sets the weather conditions for a specific day identified by date or index.
func (w *Weather) SetConditionsOnDay(dayInfo interface{}, value string) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Conditions = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetDescriptionOnDay retrieves the weather description for a specific day identified by date or index.
func (w *Weather) GetDescriptionOnDay(dayInfo interface{}) (string, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return "", err
	}
	return dayData.Description, nil
}

// SetDescriptionOnDay sets the weather description for a specific day identified by date or index.
func (w *Weather) SetDescriptionOnDay(dayInfo interface{}, value string) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Description = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetIconOnDay retrieves the weather icon for a specific day identified by date or index.
func (w *Weather) GetIconOnDay(dayInfo interface{}) (string, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return "", err
	}
	return dayData.Icon, nil
}

// SetIconOnDay sets the weather icon for a specific day identified by date or index.
func (w *Weather) SetIconOnDay(dayInfo interface{}, value string) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Icon = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetStationsOnDay retrieves the weather stations data for a specific day identified by date or index.
func (w *Weather) GetStationsOnDay(dayInfo interface{}) ([]string, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return nil, err
	}
	return dayData.Stations, nil
}

// SetStationsOnDay sets the weather stations data for a specific day identified by date or index.
func (w *Weather) SetStationsOnDay(dayInfo interface{}, value []string) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Stations = value
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetHourlyDataOnDay retrieves hourly weather data for a specific day identified by date or index.
// Optionally filters the data to include only specified elements.
func (w *Weather) GetHourlyDataOnDay(dayInfo interface{}, elements []string) ([]Hour, error) {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return nil, err
	}

	hourlyData := dayData.Hours
	if len(elements) == 0 {
		return hourlyData, nil
	}

	filteredData := make([]Hour, len(hourlyData))
	for i, hour := range hourlyData {
		filteredHour := Hour{}
		hourValue := reflect.ValueOf(hour)
		filteredHourValue := reflect.ValueOf(&filteredHour).Elem()
		for _, key := range elements {
			fieldValue := hourValue.FieldByName(key)
			if fieldValue.IsValid() {
				filteredHourValue.FieldByName(key).Set(fieldValue)
			}
		}
		filteredData[i] = filteredHour
	}

	return filteredData, nil
}

// SetHourlyDataOnDay sets the hourly weather data for a specific day identified by date or index.
func (w *Weather) SetHourlyDataOnDay(dayInfo interface{}, data []Hour) error {
	dayData, err := w.GetDataOnDay(dayInfo, nil)
	if err != nil {
		return err
	}
	dayData.Hours = data
	return w.SetDataOnDay(dayInfo, dayData)
}

// GetDataAtDatetime retrieves weather data for a specific date and time from the weather data collection.
func (w *Weather) GetDataAtDatetime(dayInfo, timeInfo interface{}) (Hour, error) {
	day, err := filterDayByDatetimeVal(w.weatherData.Days, dayInfo)
	if err != nil {
		return Hour{}, err
	}

	hour, err := filterHourByDatetimeVal(day.Hours, timeInfo)
	if err != nil {
		return Hour{}, err
	}

	return hour, nil
}

// SetDataAtDatetime sets weather data for a specific date and time in the weather data collection.
func (w *Weather) SetDataAtDatetime(dayInfo, timeInfo interface{}, data Hour) error {
	day, err := filterDayByDatetimeVal(w.weatherData.Days, dayInfo)
	if err != nil {
		return err
	}

	err = setHourByDatetimeVal(day.Hours, timeInfo, data)
	if err != nil {
		return err
	}

	return nil
}

// GetDatetimeEpochAtDatetime retrieves the epoch time for a specific datetime within the weather data.
func (w *Weather) GetDatetimeEpochAtDatetime(dayInfo, timeInfo interface{}) (int64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.DatetimeEpoch, nil
}

// SetDatetimeEpochAtDatetime sets the epoch time for a specific datetime within the weather data.
func (w *Weather) SetDatetimeEpochAtDatetime(dayInfo, timeInfo interface{}, value int64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.DatetimeEpoch = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetTempAtDatetime retrieves the temperature for a specific datetime within the weather data.
func (w *Weather) GetTempAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Temp, nil
}

// SetTempAtDatetime sets the temperature for a specific datetime within the weather data.
func (w *Weather) SetTempAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Temp = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetFeelslikeAtDatetime retrieves the 'feels like' temperature for a specific datetime within the weather data.
func (w *Weather) GetFeelslikeAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Feelslike, nil
}

// SetFeelslikeAtDatetime sets the 'feels like' temperature for a specific datetime within the weather data.
func (w *Weather) SetFeelslikeAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Feelslike = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetHumidityAtDatetime retrieves the humidity for a specific datetime within the weather data.
func (w *Weather) GetHumidityAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Humidity, nil
}

// SetHumidityAtDatetime sets the humidity for a specific datetime within the weather data.
func (w *Weather) SetHumidityAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Humidity = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetDewAtDatetime retrieves the dew point temperature for a specific datetime within the weather data.
func (w *Weather) GetDewAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Dew, nil
}

// SetDewAtDatetime sets the dew point temperature for a specific datetime within the weather data.
func (w *Weather) SetDewAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Dew = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetPrecipAtDatetime retrieves the precipitation amount for a specific datetime within the weather data.
func (w *Weather) GetPrecipAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Precip, nil
}

// SetPrecipAtDatetime sets the precipitation amount for a specific datetime within the weather data.
func (w *Weather) SetPrecipAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Precip = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetPrecipprobAtDatetime retrieves the probability of precipitation for a specific datetime within the weather data.
func (w *Weather) GetPrecipprobAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Precipprob, nil
}

// SetPrecipprobAtDatetime sets the probability of precipitation for a specific datetime within the weather data.
func (w *Weather) SetPrecipprobAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Precipprob = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetSnowAtDatetime retrieves the snow amount for a specific datetime within the weather data.
func (w *Weather) GetSnowAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Snow, nil
}

// SetSnowAtDatetime sets the snow amount for a specific datetime within the weather data.
func (w *Weather) SetSnowAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Snow = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetSnowdepthAtDatetime retrieves the snow depth for a specific datetime within the weather data.
func (w *Weather) GetSnowdepthAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Snowdepth, nil
}

// SetSnowdepthAtDatetime sets the snow depth for a specific datetime within the weather data.
func (w *Weather) SetSnowdepthAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Snowdepth = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetPreciptypeAtDatetime retrieves the type of precipitation for a specific datetime within the weather data.
func (w *Weather) GetPreciptypeAtDatetime(dayInfo, timeInfo interface{}) ([]string, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return []string{}, err
	}
	return hour.Preciptype, nil
}

// SetPreciptypeAtDatetime sets the type of precipitation for a specific datetime within the weather data.
func (w *Weather) SetPreciptypeAtDatetime(dayInfo, timeInfo interface{}, value []string) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Preciptype = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetWindgustAtDatetime retrieves the wind gust speed for a specific datetime within the weather data.
func (w *Weather) GetWindgustAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Windgust, nil
}

// SetWindgustAtDatetime sets the wind gust speed for a specific datetime within the weather data.
func (w *Weather) SetWindgustAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Windgust = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetWindspeedAtDatetime retrieves the wind speed for a specific datetime within the weather data.
func (w *Weather) GetWindspeedAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Windspeed, nil
}

// SetWindspeedAtDatetime sets the wind speed for a specific datetime within the weather data.
func (w *Weather) SetWindspeedAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Windspeed = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetWinddirAtDatetime retrieves the wind direction for a specific datetime within the weather data.
func (w *Weather) GetWinddirAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Winddir, nil
}

// SetWinddirAtDatetime sets the wind direction for a specific datetime within the weather data.
func (w *Weather) SetWinddirAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Winddir = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetPressureAtDatetime retrieves the atmospheric pressure for a specific datetime within the weather data.
func (w *Weather) GetPressureAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Pressure, nil
}

// SetPressureAtDatetime sets the atmospheric pressure for a specific datetime within the weather data.
func (w *Weather) SetPressureAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Pressure = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetVisibilityAtDatetime retrieves the visibility for a specific datetime within the weather data.
func (w *Weather) GetVisibilityAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Visibility, nil
}

// SetVisibilityAtDatetime sets the visibility for a specific datetime within the weather data.
func (w *Weather) SetVisibilityAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Visibility = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetCloudcoverAtDatetime retrieves the cloud cover for a specific datetime within the weather data.
func (w *Weather) GetCloudcoverAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Cloudcover, nil
}

// SetCloudcoverAtDatetime sets the cloud cover for a specific datetime within the weather data.
func (w *Weather) SetCloudcoverAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Cloudcover = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetSolarradiationAtDatetime retrieves the solar radiation for a specific datetime within the weather data.
func (w *Weather) GetSolarradiationAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Solarradiation, nil
}

// SetSolarradiationAtDatetime sets the solar radiation for a specific datetime within the weather data.
func (w *Weather) SetSolarradiationAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Solarradiation = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetSolarenergyAtDatetime retrieves the solar energy for a specific datetime within the weather data.
func (w *Weather) GetSolarenergyAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Solarenergy, nil
}

// SetSolarenergyAtDatetime sets the solar energy for a specific datetime within the weather data.
func (w *Weather) SetSolarenergyAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Solarenergy = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetUvindexAtDatetime retrieves the UV index for a specific datetime within the weather data.
func (w *Weather) GetUvindexAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Uvindex, nil
}

// SetUvindexAtDatetime sets the UV index for a specific datetime within the weather data.
func (w *Weather) SetUvindexAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Uvindex = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetSevereriskAtDatetime retrieves the severe risk for a specific datetime within the weather data.
func (w *Weather) GetSevereriskAtDatetime(dayInfo, timeInfo interface{}) (float64, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return 0, err
	}
	return hour.Severerisk, nil
}

// SetSevereriskAtDatetime sets the severe risk for a specific datetime within the weather data.
func (w *Weather) SetSevereriskAtDatetime(dayInfo, timeInfo interface{}, value float64) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Severerisk = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetConditionsAtDatetime retrieves the conditions for a specific datetime within the weather data.
func (w *Weather) GetConditionsAtDatetime(dayInfo, timeInfo interface{}) (string, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return "", err
	}
	return hour.Conditions, nil
}

// SetConditionsAtDatetime sets the conditions for a specific datetime within the weather data.
func (w *Weather) SetConditionsAtDatetime(dayInfo, timeInfo interface{}, value string) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Conditions = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetIconAtDatetime retrieves the weather icon for a specific datetime within the weather data.
func (w *Weather) GetIconAtDatetime(dayInfo, timeInfo interface{}) (string, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return "", err
	}
	return hour.Icon, nil
}

// SetIconAtDatetime sets the weather icon for a specific datetime within the weather data.
func (w *Weather) SetIconAtDatetime(dayInfo, timeInfo interface{}, value string) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Icon = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetStationsAtDatetime retrieves the weather stations that were used for creating the observation for a specific datetime within the weather data.
func (w *Weather) GetStationsAtDatetime(dayInfo, timeInfo interface{}) ([]string, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return nil, err
	}
	return hour.Stations, nil
}

// SetStationsAtDatetime sets the weather stations that were used for creating the observation for a specific datetime within the weather data.
func (w *Weather) SetStationsAtDatetime(dayInfo, timeInfo interface{}, value []string) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Stations = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// GetSourceAtDatetime retrieves the type of weather data used for this weather object for a specific datetime within the weather data.
func (w *Weather) GetSourceAtDatetime(dayInfo, timeInfo interface{}) (string, error) {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return "", err
	}
	return hour.Source, nil
}

// SetSourceAtDatetime sets the type of weather data used for this weather object for a specific datetime within the weather data.
func (w *Weather) SetSourceAtDatetime(dayInfo, timeInfo interface{}, value string) error {
	hour, err := w.GetDataAtDatetime(dayInfo, timeInfo)
	if err != nil {
		return err
	}
	hour.Source = value
	return w.SetDataAtDatetime(dayInfo, timeInfo, hour)
}

// ClearWeatherData clears the weather data.
func (w *Weather) ClearWeatherData() {
	w.weatherData = WeatherData{} // Reset the struct to its zero value
}

//! ----------------- Helper functions -----------------

// Helper function to filter WeatherData struct by elements
func filterWeatherDataByElements(weatherData WeatherData, elements []string) WeatherData {
	filteredWeatherData := WeatherData{}
	for _, element := range elements {
		switch element {
		case "queryCost":
			filteredWeatherData.QueryCost = weatherData.QueryCost
		case "latitude":
			filteredWeatherData.Latitude = weatherData.Latitude
		case "longitude":
			filteredWeatherData.Longitude = weatherData.Longitude
		case "resolvedAddress":
			filteredWeatherData.ResolvedAddress = weatherData.ResolvedAddress
		case "address":
			filteredWeatherData.Address = weatherData.Address
		case "timezone":
			filteredWeatherData.Timezone = weatherData.Timezone
		case "tzoffset":
			filteredWeatherData.Tzoffset = weatherData.Tzoffset
		case "days":
			filteredWeatherData.Days = weatherData.Days
		case "stations":
			filteredWeatherData.Stations = weatherData.Stations
		}
	}
	return filteredWeatherData
}

// Helper function to filter Day struct by elements
func filterDayByElements(day Day, elements []string) Day {
	filteredDay := Day{}
	for _, element := range elements {
		switch element {
		case "datetime":
			filteredDay.Datetime = day.Datetime
		case "datetimeEpoch":
			filteredDay.DatetimeEpoch = day.DatetimeEpoch
		case "tempmax":
			filteredDay.Tempmax = day.Tempmax
		case "tempmin":
			filteredDay.Tempmin = day.Tempmin
		case "temp":
			filteredDay.Temp = day.Temp
		case "feelslikemax":
			filteredDay.Feelslikemax = day.Feelslikemax
		case "feelslikemin":
			filteredDay.Feelslikemin = day.Feelslikemin
		case "feelslike":
			filteredDay.Feelslike = day.Feelslike
		case "dew":
			filteredDay.Dew = day.Dew
		case "humidity":
			filteredDay.Humidity = day.Humidity
		case "precip":
			filteredDay.Precip = day.Precip
		case "precipprob":
			filteredDay.Precipprob = day.Precipprob
		case "precipcover":
			filteredDay.Precipcover = day.Precipcover
		case "preciptype":
			filteredDay.Preciptype = day.Preciptype
		case "snow":
			filteredDay.Snow = day.Snow
		case "snowdepth":
			filteredDay.Snowdepth = day.Snowdepth
		case "windgust":
			filteredDay.Windgust = day.Windgust
		case "windspeed":
			filteredDay.Windspeed = day.Windspeed
		case "winddir":
			filteredDay.Winddir = day.Winddir
		case "pressure":
			filteredDay.Pressure = day.Pressure
		case "cloudcover":
			filteredDay.Cloudcover = day.Cloudcover
		case "visibility":
			filteredDay.Visibility = day.Visibility
		case "solarradiation":
			filteredDay.Solarradiation = day.Solarradiation
		case "solarenergy":
			filteredDay.Solarenergy = day.Solarenergy
		case "uvindex":
			filteredDay.Uvindex = day.Uvindex
		case "severerisk":
			filteredDay.Severerisk = day.Severerisk
		case "sunrise":
			filteredDay.Sunrise = day.Sunrise
		case "sunriseEpoch":
			filteredDay.SunriseEpoch = day.SunriseEpoch
		case "sunset":
			filteredDay.Sunset = day.Sunset
		case "sunsetEpoch":
			filteredDay.SunsetEpoch = day.SunsetEpoch
		case "moonphase":
			filteredDay.Moonphase = day.Moonphase
		case "conditions":
			filteredDay.Conditions = day.Conditions
		case "description":
			filteredDay.Description = day.Description
		case "icon":
			filteredDay.Icon = day.Icon
		case "stations":
			filteredDay.Stations = day.Stations
		case "source":
			filteredDay.Source = day.Source
		case "hours":
			filteredDay.Hours = day.Hours
		}
	}
	return filteredDay
}

// Helper function to filter Hour struct by elements
func filterHourByElements(hour Hour, elements []string) Hour {
	filteredHour := Hour{}
	for _, element := range elements {
		switch element {
		case "datetime":
			filteredHour.Datetime = hour.Datetime
		case "datetimeEpoch":
			filteredHour.DatetimeEpoch = hour.DatetimeEpoch
		case "temp":
			filteredHour.Temp = hour.Temp
		case "feelslike":
			filteredHour.Feelslike = hour.Feelslike
		case "humidity":
			filteredHour.Humidity = hour.Humidity
		case "dew":
			filteredHour.Dew = hour.Dew
		case "precip":
			filteredHour.Precip = hour.Precip
		case "precipprob":
			filteredHour.Precipprob = hour.Precipprob
		case "snow":
			filteredHour.Snow = hour.Snow
		case "snowdepth":
			filteredHour.Snowdepth = hour.Snowdepth
		case "preciptype":
			filteredHour.Preciptype = hour.Preciptype
		case "windgust":
			filteredHour.Windgust = hour.Windgust
		case "windspeed":
			filteredHour.Windspeed = hour.Windspeed
		case "winddir":
			filteredHour.Winddir = hour.Winddir
		case "pressure":
			filteredHour.Pressure = hour.Pressure
		case "visibility":
			filteredHour.Visibility = hour.Visibility
		case "cloudcover":
			filteredHour.Cloudcover = hour.Cloudcover
		case "solarradiation":
			filteredHour.Solarradiation = hour.Solarradiation
		case "solarenergy":
			filteredHour.Solarenergy = hour.Solarenergy
		case "uvindex":
			filteredHour.Uvindex = hour.Uvindex
		case "severerisk":
			filteredHour.Severerisk = hour.Severerisk
		case "conditions":
			filteredHour.Conditions = hour.Conditions
		case "icon":
			filteredHour.Icon = hour.Icon
		case "stations":
			filteredHour.Stations = hour.Stations
		case "source":
			filteredHour.Source = hour.Source
		}
	}
	return filteredHour
}

// PrintStruct prints the struct in key-value format
func PrintStruct(v interface{}, indent string) {
	val := reflect.ValueOf(v)
	typ := reflect.TypeOf(v)

	// If the value is a pointer, get the element it points to
	if val.Kind() == reflect.Ptr {
		val = val.Elem()
		typ = typ.Elem()
	}

	for i := 0; i < val.NumField(); i++ {
		field := val.Field(i)
		fieldType := typ.Field(i)
		fieldName := fieldType.Name

		if field.Kind() == reflect.Struct {
			fmt.Printf("%s%s:\n", indent, fieldName)
			PrintStruct(field.Interface(), indent+"  ")
		} else if field.Kind() == reflect.Slice {
			fmt.Printf("%s%s: [", indent, fieldName)
			for j := 0; j < field.Len(); j++ {
				elem := field.Index(j)
				if elem.Kind() == reflect.Struct {
					fmt.Printf("\n%s  ", indent)
					PrintStruct(elem.Interface(), indent+"  ")
				} else {
					if j > 0 {
						fmt.Printf(", ")
					}
					fmt.Printf("%v", elem.Interface())
				}
			}
			fmt.Println("]")
		} else if field.Kind() == reflect.Map {
			fmt.Printf("%s%s:\n", indent, fieldName)
			for _, key := range field.MapKeys() {
				mapValue := field.MapIndex(key)
				fmt.Printf("%s  %s: %v\n", indent, key, mapValue.Interface())
			}
		} else {
			fmt.Printf("%s%s: %v\n", indent, fieldName, field.Interface())
		}
	}
}

// Filters an item by its datetime value from a array of struct, each containing a 'datetime' key.
func filterDayByDatetimeVal(items []Day, datetimeVal interface{}) (Day, error) {
	switch v := datetimeVal.(type) {
	case string:
		for _, item := range items {
			if item.Datetime == v {
				return item, nil
			}
		}
	case int:
		if v >= 0 && v < len(items) {
			return items[v], nil
		}
	default:
		return Day{}, fmt.Errorf("invalid input datetime value: %v", datetimeVal)
	}
	return Day{}, fmt.Errorf("item not found")
}

func filterHourByDatetimeVal(items []Hour, datetimeVal interface{}) (Hour, error) {
	switch v := datetimeVal.(type) {
	case string:
		for _, item := range items {
			if item.Datetime == v {
				return item, nil
			}
		}
	case int:
		if v >= 0 && v < len(items) {
			return items[v], nil
		}
	default:
		return Hour{}, fmt.Errorf("invalid input datetime value: %v", datetimeVal)
	}
	return Hour{}, fmt.Errorf("item not found")
}

func setHourByDatetimeVal(items []Hour, datetimeVal interface{}, data Hour) error {
	switch v := datetimeVal.(type) {
	case string:
		for i, item := range items {
			if item.Datetime == v {
				data.Datetime = v
				items[i] = data
				return nil
			}
		}
	case int:
		if v >= 0 && v < len(items) {
			data.Datetime = items[v].Datetime
			items[v] = data
			return nil
		}
	default:
		return fmt.Errorf("invalid input datetime value for setItemByDatetimeVal with str or int: %v", datetimeVal)
	}
	return fmt.Errorf("item not found")
}

// func updateHourByDatetimeVal(items []Hour, datetimeVal interface{}, data Hour) error {
//     switch v := datetimeVal.(type) {
//     case string:
//         for i, item := range items {
//             if item.Datetime == v {
//                 for k, val := range data {
//                     itemMap := item.toMap()
//                     itemMap[k] = val
//                 }
//                 item.Datetime = v
//                 items[i] = mapToHour(data)
//                 return nil
//             }
//         }
//     case int:
//         if v >= 0 && v < len(items) {
//             for k, val := range data {
//                 itemMap := items[v].toMap()
//                 itemMap[k] = val
//             }
//             items[v] = mapToHour(data)
//             return nil
//         }
//     default:
//         return fmt.Errorf("invalid input datetime value for updateItemByDatetimeVal with str or int: %v", datetimeVal)
//     }
//     return fmt.Errorf("item not found")
// }

// --- utility functions for struct

// UpdateStruct updates the fields of the original struct with values from the updates struct,
// excluding fields specified in excludeFields.
func UpdateStruct(original, updates interface{}, excludeFields []string) {
	excludeMap := make(map[string]bool)
	for _, field := range excludeFields {
		excludeMap[field] = true
	}

	origValue := reflect.ValueOf(original).Elem()
	updValue := reflect.ValueOf(updates).Elem()

	for i := 0; i < updValue.NumField(); i++ {
		field := updValue.Type().Field(i).Name
		if !excludeMap[field] {
			origField := origValue.FieldByName(field)
			if origField.IsValid() && origField.CanSet() {
				origField.Set(updValue.Field(i))
			}
		}
	}
}

// IsValidStruct checks if the struct contains only the allowed fields.
func IsValidStruct(variable interface{}, allowedFields []string) bool {
	allowedMap := make(map[string]bool)
	for _, field := range allowedFields {
		allowedMap[field] = true
	}

	varValue := reflect.ValueOf(variable).Elem()
	for i := 0; i < varValue.NumField(); i++ {
		field := varValue.Type().Field(i).Name
		if !allowedMap[field] {
			return false
		}
	}
	return true
}

// ExtractSubstructByFields extracts a sub-struct from the original struct with fields specified in fieldsList.
func ExtractSubstructByFields(original interface{}, fieldsList []string, subStruct interface{}) {
	origValue := reflect.ValueOf(original).Elem()
	subValue := reflect.ValueOf(subStruct).Elem()

	for _, field := range fieldsList {
		origField := origValue.FieldByName(field)
		if origField.IsValid() {
			subField := subValue.FieldByName(field)
			if subField.IsValid() && subField.CanSet() {
				subField.Set(origField)
			}
		}
	}
}
