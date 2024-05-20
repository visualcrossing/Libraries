const { Weather } = require('../Library/weather');

const basic_usage = async () => {
    const weather = new Weather('3KAJKHWT3UEMRQWF2ABKVVVZE');
    // fetch from the Visual Crossing API
    await weather.fetchWeatherData("38.95,-95.664", "2023-01-01", '2023-01-02', '', 'hours');

    // using the method [getWeatherData] of the class to get the weather data
    console.log(">>Result: ", weather.getWeatherData(['timezone']));

    // using the method [getTzoffset] of the class to get the `tzoffset`
    console.log(">>tzoffset: ", weather.getTzoffset());

    // using the method [setTzoffset] of the class to set the `tzoffset`
    // weather.setTzoffset(-3.0);
    // console.log(">>changed tzoffset: ", weather.getTzoffset());

    // using the method [getWeatherDailyData] of the class to get the daily data
    // console.log(">>Daily Data:", weather.getWeatherDailyData());
    // console.log(">>Daily Data with some elements:", weather.getWeatherDailyData(['temp', 'precip']));

    // using the method [getWeatherHourlyData] of the class to get the hourly data
    // console.log(">>Hourly Data:", weather.getWeatherHourlyData());
    // console.log(">>Hourly Data with some elements:", weather.getWeatherHourlyData(['temp', 'precip']));

    // using the method [getDailyDatetimes] of the class to get datetimes of the daily data
    // console.log(">>Daily datetimes: ", weather.getDailyDatetimes());

    // using the method [getHourlyDatetimes] of the class to get datetimes of the daily data
    // console.log(">>Hourly datetimes: ", weather.getHourlyDatetimes());

    // using the method [getDataOnDay] of the class to get data of the specific day within `days` key
    console.log(">>Weather data on a day: ", weather.getDataOnDay('2023-01-02', ['temp', 'humidity', 'dew']));

    // using the method [getHourlyDataOnDay] of the class to get hourly data of the specific day within `days` key
    // console.log(">>Hourly data with some elements on a day: ", weather.getHourlyDataOnDay('2023-01-02', ['temp', 'humidity']));

    // using the method [getTempmaxOnDay] of the class to get tempmax of the specific day within `days` key
    // console.log(">>tempmax on a day: ", weather.getTempmaxOnDay(1));
    // console.log(">>tempmax on a day: ", weather.getTempmaxOnDay('2023-01-02'));

    // using the method [setTempmaxOnDay] of the class to set tempmax of the specific day within `days` key
    // weather.setTempmaxOnDay('2023-01-02', 18);
    // console.log(">>changed tempmax on a day: ", weather.getTempmaxOnDay(1));

    // using the method [getSnowdepthOnDay] and [setSnowdepthOnDay] of the class to get and set snowdepth of the specific day within `days` key for daily data
    // console.log(">>snowdepth on a day: ", weather.getSnowdepthOnDay(1));
    // weather.setSnowdepthOnDay('2023-01-02', 1);
    // console.log(">>changed snowdepth on a day: ", weather.getSnowdepthOnDay(1));

    // using the method [getDataAtDatetime] and [setDataAtDatetime] of the class to get and set data of the specific date and time within `hours` key for hourly data
    console.log(">>Weather data at a datetime: ", weather.getDataAtDatetime(1, 1, ['temp', 'precip', 'humidity']));
    weather.setDataAtDatetime('2023-01-02', '01:00:00', {'temp': 25.0});
    console.log(">>Changed weather data at a datetime: ", weather.getDataAtDatetime('2023-01-02', '01:00:00'));

    // using the method [getDatetimeEpochAtDatetime] and [setDatetimeEpochAtDatetime] of the class to get and set datetimeEpoch of the specific date and time within `hours` key for hourly data
    console.log(">>datetimeEpoch at a datetime: ", weather.getDatetimeEpochAtDatetime(1, 1));
    weather.setDatetimeEpochAtDatetime('2023-01-02', 1, 1111111111);
    console.log(">>changed datetimeEpoch at a datetime: ", weather.getDatetimeEpochAtDatetime('2023-01-02', '01:00:00'));

    // using the method [getStationsAtDatetime] of the class to get and set stations of the specific date and time within `hours` key for hourly data
    // console.log(">>stations at a datetime: ", weather.getStationsAtDatetime(1, 1));

    // clear weather data
    weather.clearWeatherData();
    console.log('After cleaning: ', weather.getWeatherData());
}


// Run the demos
basic_usage()