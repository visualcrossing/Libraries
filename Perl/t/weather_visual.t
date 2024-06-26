use strict;
use warnings;

use lib 'E:\weatherAPI_visualization\1making_libs\Perl\perl_packaging\lib';
use Test::More tests => 29;
use WeatherVisual;
use Data::Dumper;

# Create a new instance of WeatherVisual
my $weather = WeatherVisual->new(api_key => 'YOUR_API_KEY');

# Test fetching weather data
my $data = eval { $weather->fetch_weather_data('New York, NY', '2023-01-01', '2023-01-07', 'us', 'hours') };
ok($data, 'Fetched weather data successfully');

# Test setting and getting weather data
$weather->set_weather_data($data);
my $retrieved_data = $weather->get_weather_data();
is_deeply($retrieved_data, $data, 'Weather data set and retrieved successfully');

# Test daily weather data retrieval
my $daily_data = $weather->get_weather_daily_data();
ok(@$daily_data > 0, 'Retrieved daily weather data');

# Test setting daily weather data
$weather->set_weather_daily_data($daily_data);
my $retrieved_daily_data = $weather->get_weather_daily_data();
is_deeply($retrieved_daily_data, $daily_data, 'Daily weather data set and retrieved successfully');

# Test hourly weather data retrieval
my $hourly_data = $weather->get_weather_hourly_data();
ok(@$hourly_data > 0, 'Retrieved hourly weather data');

# Test setting and getting specific attributes on day level
$weather->set_temp_on_day(0, 25);
is($weather->get_temp_on_day(0), 25, 'Temperature set and retrieved successfully');

$weather->set_humidity_on_day(0, 60);
is($weather->get_humidity_on_day(0), 60, 'Humidity set and retrieved successfully');

# Test clearing weather data
$weather->clear_weather_data();
is_deeply($weather->get_weather_data(), {}, 'Weather data cleared successfully');

# New tests for datetime-based functions
$weather->set_weather_data($data);

# Test get_data_at_datetime
my $day_info = 0; # First day
my $time_info = 0; # First hour
my $data_at_datetime = eval { $weather->get_data_at_datetime($day_info, $time_info) };
# diag("Data at datetime: " . Dumper($data_at_datetime));
ok($data_at_datetime, 'Retrieved data at datetime');

# Test set_data_at_datetime
my $new_data = { temp => 25, feelslike => 23, humidity => 60 };
eval { $weather->set_data_at_datetime($day_info, $time_info, $new_data) };
my $updated_data = eval { $weather->get_data_at_datetime($day_info, $time_info) };
is_deeply($updated_data, $new_data, 'Set and retrieved data at datetime successfully');

# Test update_data_at_datetime
my $update_data = { temp => 26 };
eval { $weather->update_data_at_datetime($day_info, $time_info, $update_data) };
my $updated_data_after_update = eval { $weather->get_data_at_datetime($day_info, $time_info) };
is($updated_data_after_update->{temp}, 26, 'Updated temp at datetime successfully');

# Test get and set datetimeEpoch
my $datetimeEpoch = eval { $weather->get_datetimeEpoch_at_datetime($day_info, $time_info) };
ok($datetimeEpoch, 'Retrieved datetimeEpoch at datetime');

my $new_datetimeEpoch = 1672531200;
eval { $weather->set_datetimeEpoch_at_datetime($day_info, $time_info, $new_datetimeEpoch) };
my $updated_datetimeEpoch = eval { $weather->get_datetimeEpoch_at_datetime($day_info, $time_info) };
is($updated_datetimeEpoch, $new_datetimeEpoch, 'Set and retrieved datetimeEpoch at datetime successfully');

# Test get and set temp
my $temp = eval { $weather->get_temp_at_datetime($day_info, $time_info) };
ok($temp, 'Retrieved temp at datetime');

my $new_temp = 30;
eval { $weather->set_temp_at_datetime($day_info, $time_info, $new_temp) };
my $updated_temp = eval { $weather->get_temp_at_datetime($day_info, $time_info) };
is($updated_temp, $new_temp, 'Set and retrieved temp at datetime successfully');

# Test get and set feelslike
my $feelslike = eval { $weather->get_feelslike_at_datetime($day_info, $time_info) };
ok($feelslike, 'Retrieved feelslike at datetime');

my $new_feelslike = 28;
eval { $weather->set_feelslike_at_datetime($day_info, $time_info, $new_feelslike) };
my $updated_feelslike = eval { $weather->get_feelslike_at_datetime($day_info, $time_info) };
is($updated_feelslike, $new_feelslike, 'Set and retrieved feelslike at datetime successfully');

# Test get and set humidity
my $humidity = eval { $weather->get_humidity_at_datetime($day_info, $time_info) };
ok($humidity, 'Retrieved humidity at datetime');

my $new_humidity = 65;
eval { $weather->set_humidity_at_datetime($day_info, $time_info, $new_humidity) };
my $updated_humidity = eval { $weather->get_humidity_at_datetime($day_info, $time_info) };
is($updated_humidity, $new_humidity, 'Set and retrieved humidity at datetime successfully');

# Test get and set dew
my $dew = eval { $weather->get_dew_at_datetime($day_info, $time_info) };
ok($dew, 'Retrieved dew at datetime');

my $new_dew = 10;
eval { $weather->set_dew_at_datetime($day_info, $time_info, $new_dew) };
my $updated_dew = eval { $weather->get_dew_at_datetime($day_info, $time_info) };
is($updated_dew, $new_dew, 'Set and retrieved dew at datetime successfully');

# Test get and set precip
my $precip = eval { $weather->get_precip_at_datetime($day_info, $time_info) };
ok($precip, 'Retrieved precip at datetime');

my $new_precip = 1.5;
eval { $weather->set_precip_at_datetime($day_info, $time_info, $new_precip) };
my $updated_precip = eval { $weather->get_precip_at_datetime($day_info, $time_info) };
is($updated_precip, $new_precip, 'Set and retrieved precip at datetime successfully');

# Test get and set precipprob
my $precipprob = eval { $weather->get_precipprob_at_datetime($day_info, $time_info) };
ok($precipprob, 'Retrieved precipprob at datetime');

my $new_precipprob = 80;
eval { $weather->set_precipprob_at_datetime($day_info, $time_info, $new_precipprob) };
my $updated_precipprob = eval { $weather->get_precipprob_at_datetime($day_info, $time_info) };
is($updated_precipprob, $new_precipprob, 'Set and retrieved precipprob at datetime successfully');

# Test get and set snow
my $snow = eval { $weather->get_snow_at_datetime($day_info, $time_info) };
ok($snow, 'Retrieved snow at datetime');

my $new_snow = 5;
eval { $weather->set_snow_at_datetime($day_info, $time_info, $new_snow) };
my $updated_snow = eval { $weather->get_snow_at_datetime($day_info, $time_info) };
is($updated_snow, $new_snow, 'Set and retrieved snow at datetime successfully');

# Test get and set snowdepth
my $snowdepth = eval { $weather->get_snowdepth_at_datetime($day_info, $time_info) };
ok($snowdepth, 'Retrieved snowdepth at datetime');

my $new_snowdepth = 15;
eval { $weather->set_snowdepth_at_datetime($day_info, $time_info, $new_snowdepth) };
my $updated_snowdepth = eval { $weather->get_snowdepth_at_datetime($day_info, $time_info) };
is($updated_snowdepth, $new_snowdepth, 'Set and retrieved snowdepth at datetime successfully');

done_testing();
