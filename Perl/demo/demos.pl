use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use WeatherVisual;
use Data::Dumper;

# Initialize the WeatherVisual object with your API key
my $weather = WeatherVisual->new(api_key => 'YOUR_API_KEY_HERE');

# Fetch weather data for a specific location and date range
my $location = 'New York, NY';
my $from_date = '2023-01-01';
my $to_date = '2023-01-07';

print "Fetching weather data for $location from $from_date to $to_date...\n";
my $data = eval {
    $weather->fetch_weather_data($location, $from_date, $to_date, 'us', 'days,hours', ['temp', 'humidity'])
};
if ($@) {
    die "Failed to fetch weather data: $@";
}
print "Fetched weather data successfully.\n";

# Set the fetched weather data
$weather->set_weather_data($data);

# Retrieve and display daily weather data
my $daily_data = $weather->get_weather_daily_data();
print "Daily Weather Data:\n";
print Dumper($daily_data);

# Retrieve and display hourly weather data
my $hourly_data = $weather->get_weather_hourly_data();
print "Hourly Weather Data:\n";
print Dumper($hourly_data);

# Get and set specific weather parameters for a specific day and time
my $day_index = 0;   # First day in the data
my $hour_index = 0;  # First hour in the data

# Retrieve temperature at a specific datetime
my $temp = eval { $weather->get_temp_at_datetime($day_index, $hour_index) };
if ($@) {
    warn "Failed to get temperature at datetime: $@";
} else {
    print "Temperature at datetime: $temp\n";
}

# Set new temperature at a specific datetime
eval { $weather->set_temp_at_datetime($day_index, $hour_index, 25) };
if ($@) {
    warn "Failed to set temperature at datetime: $@";
} else {
    print "Set new temperature at datetime successfully.\n";
}

# Retrieve and display updated temperature at a specific datetime
$temp = eval { $weather->get_temp_at_datetime($day_index, $hour_index) };
if ($@) {
    warn "Failed to get updated temperature at datetime: $@";
} else {
    print "Updated Temperature at datetime: $temp\n";
}

# Clear weather data
$weather->clear_weather_data();
print "Cleared weather data.\n";

# Verify weather data is cleared
my $cleared_data = $weather->get_weather_data();
print "Cleared Weather Data:\n";
print Dumper($cleared_data);

print "Demo script completed successfully.\n";
