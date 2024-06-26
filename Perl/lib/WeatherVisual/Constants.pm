package WeatherVisual::Constants;
use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = qw(
    BASE_URL QUERY_COST LATITUDE LONGITUDE RESOLVED_ADDRESS ADDRESS TIMEZONE TZOFFSET
    DAYS HOURS DATETIME DATETIME_EPOCH TEMPMAX TEMPMIN TEMP FEELSLIKEMAX FEELSLIKEMIN
    FEELSLIKE DEW HUMIDITY PRECIP PRECIPPROB PRECIPCOVER PRECIPTYPE SNOW SNOWDEPTH
    WINDGUST WINDSPEED WINDDIR PRESSURE CLOUDCOVER VISIBILITY SOLARRADIATION
    SOLARENERGY UVINDEX SEVERERISK SUNRISE SUNRISE_EPOCH SUNSET SUNSET_EPOCH MOONPHASE
    CONDITIONS DESCRIPTION ICON STATIONS SOURCE DAYS_KEYS HOURS_KEYS
);

use constant BASE_URL => "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline";

use constant QUERY_COST => 'queryCost';
use constant LATITUDE => 'latitude';
use constant LONGITUDE => 'longitude';
use constant RESOLVED_ADDRESS => 'resolvedAddress';
use constant ADDRESS => 'address';
use constant TIMEZONE => 'timezone';
use constant TZOFFSET => 'tzoffset';

use constant DAYS => 'days';
use constant HOURS => 'hours';

use constant DATETIME => 'datetime';
use constant DATETIME_EPOCH => 'datetimeEpoch';
use constant TEMPMAX => 'tempmax';
use constant TEMPMIN => 'tempmin';
use constant TEMP => 'temp';
use constant FEELSLIKEMAX => 'feelslikemax';
use constant FEELSLIKEMIN => 'feelslikemin';
use constant FEELSLIKE => 'feelslike';
use constant DEW => 'dew';
use constant HUMIDITY => 'humidity';
use constant PRECIP => 'precip';
use constant PRECIPPROB => 'precipprob';
use constant PRECIPCOVER => 'precipcover';
use constant PRECIPTYPE => 'preciptype';
use constant SNOW => 'snow';
use constant SNOWDEPTH => 'snowdepth';
use constant WINDGUST => 'windgust';
use constant WINDSPEED => 'windspeed';
use constant WINDDIR => 'winddir';
use constant PRESSURE => 'pressure';
use constant CLOUDCOVER => 'cloudcover';
use constant VISIBILITY => 'visibility';
use constant SOLARRADIATION => 'solarradiation';
use constant SOLARENERGY => 'solarenergy';
use constant UVINDEX => 'uvindex';
use constant SEVERERISK => 'severerisk';
use constant SUNRISE => 'sunrise';
use constant SUNRISE_EPOCH => 'sunriseEpoch';
use constant SUNSET => 'sunset';
use constant SUNSET_EPOCH => 'sunsetEpoch';
use constant MOONPHASE => 'moonphase';
use constant CONDITIONS => 'conditions';
use constant DESCRIPTION => 'description';
use constant ICON => 'icon';
use constant STATIONS => 'stations';
use constant SOURCE => 'source';

our @DAYS_KEYS = (
    DATETIME, DATETIME_EPOCH, TEMPMAX, TEMPMIN, TEMP, FEELSLIKEMAX, FEELSLIKEMIN, FEELSLIKE, DEW,
    HUMIDITY, PRECIP, PRECIPPROB, PRECIPCOVER, PRECIPTYPE, SNOW, SNOWDEPTH, WINDGUST, WINDSPEED, 
    WINDDIR, PRESSURE, CLOUDCOVER, VISIBILITY, SOLARRADIATION, SOLARENERGY, UVINDEX, SEVERERISK,
    SUNRISE, SUNRISE_EPOCH, SUNSET, SUNSET_EPOCH, MOONPHASE, CONDITIONS, DESCRIPTION, ICON, 
    STATIONS, SOURCE, HOURS
);

our @HOURS_KEYS = (
    DATETIME, DATETIME_EPOCH, TEMP, FEELSLIKE, DEW, HUMIDITY, PRECIP, PRECIPPROB, PRECIPTYPE, SNOW,
    SNOWDEPTH, WINDGUST, WINDSPEED, WINDDIR, PRESSURE, CLOUDCOVER, VISIBILITY, SOLARRADIATION,
    SOLARENERGY, UVINDEX, SEVERERISK, CONDITIONS, ICON, STATIONS, SOURCE
);

1;

__END__

=head1 NAME

WeatherVisual::Constants - Constants for the WeatherVisual module

=head1 SYNOPSIS

  use WeatherVisual::Constants qw(BASE_URL TEMPMAX TEMPMIN TEMP);

=head1 DESCRIPTION

This module provides constants used in the WeatherVisual module.

=head1 CONSTANTS

=head2 BASE_URL

The base URL for the Visual Crossing Weather API.

=head2 QUERY_COST

The cost of the query.

=head2 LATITUDE

The latitude of the location.

=head2 LONGITUDE

The longitude of the location.

=head2 RESOLVED_ADDRESS

The resolved address of the location.

=head2 ADDRESS

The address of the location.

=head2 TIMEZONE

The timezone of the location.

=head2 TZOFFSET

The timezone offset of the location.

=head2 DAYS

Key for accessing daily data.

=head2 HOURS

Key for accessing hourly data.

=head2 DATETIME

Key for accessing the datetime.

=head2 DATETIME_EPOCH

Key for accessing the datetime in epoch format.

=head2 TEMPMAX

Key for accessing the maximum temperature.

=head2 TEMPMIN

Key for accessing the minimum temperature.

=head2 TEMP

Key for accessing the temperature.

=head2 FEELSLIKEMAX

Key for accessing the maximum feels-like temperature.

=head2 FEELSLIKEMIN

Key for accessing the minimum feels-like temperature.

=head2 FEELSLIKE

Key for accessing the feels-like temperature.

=head2 DEW

Key for accessing the dew point.

=head2 HUMIDITY

Key for accessing the humidity.

=head2 PRECIP

Key for accessing the precipitation.

=head2 PRECIPPROB

Key for accessing the probability of precipitation.

=head2 PRECIPCOVER

Key for accessing the precipitation cover.

=head2 PRECIPTYPE

Key for accessing the precipitation type.

=head2 SNOW

Key for accessing the snowfall.

=head2 SNOWDEPTH

Key for accessing the snow depth.

=head2 WINDGUST

Key for accessing the wind gust.

=head2 WINDSPEED

Key for accessing the wind speed.

=head2 WINDDIR

Key for accessing the wind direction.

=head2 PRESSURE

Key for accessing the atmospheric pressure.

=head2 CLOUDCOVER

Key for accessing the cloud cover.

=head2 VISIBILITY

Key for accessing the visibility.

=head2 SOLARRADIATION

Key for accessing the solar radiation.

=head2 SOLARENERGY

Key for accessing the solar energy.

=head2 UVINDEX

Key for accessing the UV index.

=head2 SEVERERISK

Key for accessing the severe weather risk.

=head2 SUNRISE

Key for accessing the sunrise time.

=head2 SUNRISE_EPOCH

Key for accessing the sunrise time in epoch format.

=head2 SUNSET

Key for accessing the sunset time.

=head2 SUNSET_EPOCH

Key for accessing the sunset time in epoch format.

=head2 MOONPHASE

Key for accessing the moon phase.

=head2 CONDITIONS

Key for accessing the weather conditions.

=head2 DESCRIPTION

Key for accessing the weather description.

=head2 ICON

Key for accessing the weather icon.

=head2 STATIONS

Key for accessing the weather stations.

=head2 SOURCE

Key for accessing the data source.

=head2 DAYS_KEYS

Array of keys for accessing daily data.

=head2 HOURS_KEYS

Array of keys for accessing hourly data.

=cut
