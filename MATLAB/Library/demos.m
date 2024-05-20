clear; clc
% Create an instance of the Weather class
w = Weather('Your API Key');

% Set daily weather data manually
daily_data = {struct('temp', 70, 'humidity', 50, 'hours', {struct('temp', 60, 'humidity', 40), struct('temp', 65, 'humidity', 45)}), struct('temp', 72, 'humidity', 55, 'hours', {struct('temp', 66, 'humidity', 43), struct('temp', 68, 'humidity', 48)})};
% w.set_weather_daily_data(daily_data);

% Fetch weather data for a specific location
data = w.fetch_weather_data('New York', '2024-05-01', '2024-05-15', 'us', 'hours');
fprintf('Fetched data: \n');
disp(data)

% Get stored weather data
stored_data = w.get_weather_data();
fprintf('Stored data: \n');
disp(stored_data)

% Get daily weather data, filtered by specific elements
daily_data_filtered = w.get_weather_daily_data({'temp'});
fprintf('Filtered daily data: \n');
dispCellArrayOfStructs(daily_data_filtered)

% Get hourly weather data, filtered by specific elements
hourly_data_filtered = w.get_weather_hourly_data({'temp', 'humidity'});
fprintf('Filtered hourly data: \n');
dispCellArrayOfStructs(hourly_data_filtered);

% Set and get query cost manually
w.set_queryCost(5.0);
query_cost = w.get_queryCost();
disp(['Query cost: ', num2str(query_cost)]);

% Set and get latitude
w.set_latitude(40.7128);
latitude = w.get_latitude();
disp(['Latitude: ', num2str(latitude)]);

% Set and get longitude
w.set_longitude(-74.0060);
longitude = w.get_longitude();
disp(['Longitude: ', num2str(longitude)]);

% Set and get resolved address
w.set_address('New York, NY, USA');
resolved_address = w.get_resolvedAddress();
disp(['Resolved address: ', resolved_address]);

% Set and get timezone
w.set_timezone('EST');
timezone = w.get_timezone();
disp(['Timezone: ', timezone]);

% Set and get timezone offset
w.set_tzoffset(-5.0);
tzoffset = w.get_tzoffset();
disp(['Timezone Offset: ', num2str(tzoffset)]);

% Set and get weather stations
w.set_stations({'Station1', 'Station2', 'Station3'});
stations = w.get_stations();
disp('Weather Stations:');
disp(stations);

% Get daily datetimes
daily_datetimes = w.get_daily_datetimes();
disp('Daily Datetimes:');
disp_array_summary(daily_datetimes);

% Get hourly datetimes
hourly_datetimes = w.get_hourly_datetimes();
disp('Hourly Datetimes:');
disp_array_summary(hourly_datetimes);

% Get and set snow depth on a specific day
snowdepth = w.get_snowdepth_on_day('2024-05-05');
disp(['Snow Depth: ', num2str(snowdepth)]);
w.set_snowdepth_on_day('2024-05-05', 12.5);
disp(['Changed snow Depth: ', num2str(w.get_snowdepth_on_day('2024-05-05'))]);

% Get and set wind gust
windgust = w.get_windgust_on_day('2024-05-05');
disp(['Wind Gust: ', num2str(windgust)]);
w.set_windgust_on_day('2024-05-05', 25.0);

% Get and set wind speed on a specific day
windspeed = w.get_windspeed_on_day('2024-05-05');
disp(['Wind Speed: ', num2str(windspeed)]);
w.set_windspeed_on_day('2024-05-05', 15.0);

% Get and set wind direction on a specific day
winddir = w.get_winddir_on_day('2024-05-05');
disp(['Wind Direction: ', num2str(winddir)]);
w.set_winddir_on_day('2024-05-05', 180);

% Get and set pressure on a specific day
pressure = w.get_pressure_on_day('2024-05-05');
disp(['Pressure: ', num2str(pressure)]);
w.set_pressure_on_day('2024-05-05', 1015);

% Get and set cloud cover on a specific day
cloudcover = w.get_cloudcover_on_day('2024-05-05');
disp(['Cloud Cover: ', num2str(cloudcover)]);
w.set_cloudcover_on_day('2024-05-05', 80);

% Get and set visibility on a specific day
visibility = w.get_visibility_on_day('2024-05-05');
disp(['Visibility: ', num2str(visibility)]);
w.set_visibility_on_day('2024-05-05', 10);

% Get and set solar radiation on a specific day
solarradiation = w.get_solarradiation_on_day('2024-05-05');
disp(['Solar Radiation: ', num2str(solarradiation)]);
w.set_solarradiation_on_day('2024-05-05', 900);

% Get and set data at a specific datetime
dt_data = w.get_data_at_datetime('2024-05-01', '00:00:00', {'datetime', 'temp', 'dew'});
fprintf('Data at a specific datetime: \n');
disp(dt_data)
w.set_data_at_datetime('2024-05-01', '00:00:00', struct('temp', 24, 'humidity', 50));
fprintf('Changed data at a specific datetime: \n');
disp(w.get_data_at_datetime('2024-05-01', '00:00:00'))

% Get and set datetimeEpoch at a specific datetime
disp(['Datetime Epoch at as specific datetime: ',num2str(w.get_datetimeEpoch_at_datetime('2024-05-01', '01:00:00'))])

% Get and set datetimeEpoch at a specific datetime
w.set_windspeed_at_datetime('2024-05-01', 2, 5.1)
disp(['Wind speed at as specific datetime: ',num2str(w.get_windspeed_at_datetime('2024-05-01', '01:00:00'))])