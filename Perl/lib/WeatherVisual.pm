package WeatherVisual;
use strict;
use warnings;
use LWP::UserAgent;
use JSON;
use DateTime::Format::Strptime;
use Exporter 'import';
use WeatherVisual::Constants;
use WeatherVisual::Utils qw(extract_subdict_by_keys);

use Data::Dumper;

our @EXPORT_OK = qw(update_dictionary is_valid_dict extract_subdict_by_keys);
our $VERSION = '0.01';

sub new {
    my ($class, %args) = @_;
    my $self = {
        base_url => WeatherVisual::Constants::BASE_URL,
        api_key  => $args{api_key} || die "API key required",
        _weather_data => {}
    };
    bless $self, $class;
    return $self;
}

sub fetch_weather_data {
    my ($self, $location, $from_date, $to_date, $unit_group, $include, $elements) = @_;
    $unit_group ||= 'us';
    $include ||= 'days';
    $from_date ||= '';
    $to_date ||= '';
    $elements ||= '';

    my $ua = LWP::UserAgent->new;
    my $url = "$self->{base_url}/$location/$from_date/$to_date?unitGroup=$unit_group&include=$include&key=$self->{api_key}&elements=$elements";
    my $response = $ua->get($url);

    # print "Request URL: $url\n";
    print "Response Status: " . $response->status_line . "\n";

    if ($response->is_success) {
        $self->{_weather_data} = decode_json($response->decoded_content);
        return $self->{_weather_data};
    } else {
        die "Failed to fetch weather data: " . $response->status_line;
    }
}

sub get_weather_data {
    my ($self, $elements) = @_;
    $elements ||= [];
    if (@$elements) {
        return extract_subdict_by_keys($self->{_weather_data}, $elements);
    } else {
        return $self->{_weather_data};
    }
}

sub set_weather_data {
    my ($self, $data) = @_;
    $self->{_weather_data} = $data;
}

sub get_weather_daily_data {
    my ($self, $elements) = @_;
    $elements ||= [];
    if (exists $self->{_weather_data}->{days}) {
        if (@$elements) {
            return [ map { extract_subdict_by_keys($_, $elements) } @{$self->{_weather_data}->{days}} ];
        } else {
            return $self->{_weather_data}->{days};
        }
    } else {
        warn "No daily weather data available";
        return [];
    }
}

sub set_weather_daily_data {
    my ($self, $daily_data) = @_;
    $self->{_weather_data}->{days} = $daily_data;
}

sub get_weather_hourly_data {
    my ($self, $elements) = @_;
    $elements ||= [];
    if (exists $self->{_weather_data}->{days} && ref $self->{_weather_data}->{days} eq 'ARRAY') {
        my @hourly_data;
        foreach my $day (@{$self->{_weather_data}->{days}}) {
            if (exists $day->{hours} && ref $day->{hours} eq 'ARRAY') {
                push @hourly_data, @{$day->{hours}};
            }
        }
        
        if (@$elements) {
            return [ map { extract_subdict_by_keys($_, $elements) } @hourly_data ];
        } else {
            return \@hourly_data;
        }
    } else {
        warn "No valid daily weather data available";
        return [];
    }
}

sub get_queryCost {
    my ($self) = @_;
    return $self->{_weather_data}->{queryCost};
}

sub set_queryCost {
    my ($self, $value) = @_;
    $self->{_weather_data}->{queryCost} = $value;
}

sub get_latitude {
    my ($self) = @_;
    return $self->{_weather_data}->{latitude};
}

sub set_latitude {
    my ($self, $value) = @_;
    $self->{_weather_data}->{latitude} = $value;
}

sub get_longitude {
    my ($self) = @_;
    return $self->{_weather_data}->{longitude};
}

sub set_longitude {
    my ($self, $value) = @_;
    $self->{_weather_data}->{longitude} = $value;
}

sub get_resolvedAddress {
    my ($self) = @_;
    return $self->{_weather_data}->{resolvedAddress};
}

sub set_resolvedAddress {
    my ($self, $value) = @_;
    $self->{_weather_data}->{resolvedAddress} = $value;
}

sub get_address {
    my ($self) = @_;
    return $self->{_weather_data}->{address};
}

sub set_address {
    my ($self, $value) = @_;
    $self->{_weather_data}->{address} = $value;
}

sub get_timezone {
    my ($self) = @_;
    return $self->{_weather_data}->{timezone};
}

sub set_timezone {
    my ($self, $value) = @_;
    $self->{_weather_data}->{timezone} = $value;
}

sub get_tzoffset {
    my ($self) = @_;
    return $self->{_weather_data}->{tzoffset};
}

sub set_tzoffset {
    my ($self, $value) = @_;
    $self->{_weather_data}->{tzoffset} = $value;
}

sub get_stations {
    my ($self) = @_;
    return $self->{_weather_data}->{stations};
}

sub set_stations {
    my ($self, $value) = @_;
    $self->{_weather_data}->{stations} = $value;
}

sub get_daily_datetimes {
    my ($self) = @_;
    my $strp = DateTime::Format::Strptime->new(pattern => '%Y-%m-%d');
    return [ map { $strp->parse_datetime($_->{datetime}) } @{$self->{_weather_data}->{days}} ];
}

sub get_hourly_datetimes {
    my ($self) = @_;
    my $strp = DateTime::Format::Strptime->new(pattern => '%Y-%m-%d %H:%M:%S');
    return [
        map {
            my $day = $_;
            map { $strp->parse_datetime("$day->{datetime} $_->{datetime}") } @{$day->{hours}}
        } @{$self->{_weather_data}->{days}}
    ];
}

sub get_data_on_day {
    my ($self, $day_info, $elements) = @_;
    $elements ||= [];
    my $day_data;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $day_data = $self->{_weather_data}->{days}->[$day_info];
            } else {
                ($day_data) = grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_data_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing data on this day: $@";
        return;
    }
    if ($day_data) {
        if (@$elements) {
            return extract_subdict_by_keys($day_data, $elements);
        } else {
            return $day_data;
        }
    } else {
        warn "No data available for the specified day";
        return;
    }
}

sub set_data_on_day {
    my ($self, $day_info, $data) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info] = $data;
            } else {
                for my $i (0 .. @{$self->{_weather_data}->{days}} - 1) {
                    if ($self->{_weather_data}->{days}->[$i]->{datetime} eq $day_info) {
                        $self->{_weather_data}->{days}->[$i] = $data;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_data_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die $@;
    }
}

sub get_temp_on_day {
    my ($self, $day_info) = @_;
    my $temp;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $temp = $self->{_weather_data}->{days}->[$day_info]->{temp};
            } else {
                ($temp) = map { $_->{temp} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for day_info: $day_info. Expected a date string or day index.";
        }
    };
    if ($@) {
        warn "Error accessing temperature data: $@";
        return;
    }
    return $temp;
}

sub set_temp_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{temp} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{temp} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input value for day_info: $day_info. Expected a date string or day index.";
        }
    };
    if ($@) {
        die "Error setting temperature data: $@";
    }
}

sub get_tempmax_on_day {
    my ($self, $day_info) = @_;
    my $tempmax;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $tempmax = $self->{_weather_data}->{days}->[$day_info]->{tempmax};
            } else {
                ($tempmax) = map { $_->{tempmax} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_tempmax_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing maximum temperature data: $@";
        return;
    }
    return $tempmax;
}

sub set_tempmax_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{tempmax} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{tempmax} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_tempmax_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting maximum temperature data: $@";
    }
}

sub get_tempmin_on_day {
    my ($self, $day_info) = @_;
    my $tempmin;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $tempmin = $self->{_weather_data}->{days}->[$day_info]->{tempmin};
            } else {
                ($tempmin) = map { $_->{tempmin} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_tempmin_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing minimum temperature data: $@";
        return;
    }
    return $tempmin;
}

sub set_tempmin_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{tempmin} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{tempmin} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_tempmin_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting minimum temperature data: $@";
    }
}

sub get_feelslike_on_day {
    my ($self, $day_info) = @_;
    my $feelslike;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $feelslike = $self->{_weather_data}->{days}->[$day_info]->{feelslike};
            } else {
                ($feelslike) = map { $_->{feelslike} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_feelslike_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing 'feels like' temperature data: $@";
        return;
    }
    return $feelslike;
}

sub set_feelslike_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{feelslike} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{feelslike} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_feelslike_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting 'feels like' temperature data: $@";
    }
}

sub get_feelslikemax_on_day {
    my ($self, $day_info) = @_;
    my $feelslikemax;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $feelslikemax = $self->{_weather_data}->{days}->[$day_info]->{feelslikemax};
            } else {
                ($feelslikemax) = map { $_->{feelslikemax} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_feelslikemax_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing 'feels like max' temperature data: $@";
        return;
    }
    return $feelslikemax;
}

sub set_feelslikemax_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{feelslikemax} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{feelslikemax} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_feelslikemax_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting 'feels like max' temperature data: $@";
    }
}

sub get_feelslikemin_on_day {
    my ($self, $day_info) = @_;
    my $feelslikemin;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $feelslikemin = $self->{_weather_data}->{days}->[$day_info]->{feelslikemin};
            } else {
                ($feelslikemin) = map { $_->{feelslikemin} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_feelslikemin_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing 'feels like min' temperature data: $@";
        return;
    }
    return $feelslikemin;
}

sub set_feelslikemin_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{feelslikemin} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{feelslikemin} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_feelslikemin_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting 'feels like min' temperature data: $@";
    }
}

sub get_dew_on_day {
    my ($self, $day_info) = @_;
    my $dew;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $dew = $self->{_weather_data}->{days}->[$day_info]->{dew};
            } else {
                ($dew) = map { $_->{dew} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_dew_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing dew point data: $@";
        return;
    }
    return $dew;
}

sub set_dew_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{dew} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{dew} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_dew_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting dew point data: $@";
    }
}

sub get_humidity_on_day {
    my ($self, $day_info) = @_;
    my $humidity;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $humidity = $self->{_weather_data}->{days}->[$day_info]->{humidity};
            } else {
                ($humidity) = map { $_->{humidity} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_humidity_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing humidity data: $@";
        return;
    }
    return $humidity;
}

sub set_humidity_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{humidity} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{humidity} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_humidity_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting humidity data: $@";
    }
}

sub get_precip_on_day {
    my ($self, $day_info) = @_;
    my $precip;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $precip = $self->{_weather_data}->{days}->[$day_info]->{precip};
            } else {
                ($precip) = map { $_->{precip} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_precip_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing precipitation data: $@";
        return;
    }
    return $precip;
}

sub set_precip_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{precip} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{precip} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_precip_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting precipitation data: $@";
    }
}

sub get_precipprob_on_day {
    my ($self, $day_info) = @_;
    my $precipprob;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $precipprob = $self->{_weather_data}->{days}->[$day_info]->{precipprob};
            } else {
                ($precipprob) = map { $_->{precipprob} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_precipprob_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing precipitation probability data: $@";
        return;
    }
    return $precipprob;
}

sub set_precipprob_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{precipprob} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{precipprob} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_precipprob_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting precipitation probability data: $@";
    }
}

sub get_precipcover_on_day {
    my ($self, $day_info) = @_;
    my $precipcover;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $precipcover = $self->{_weather_data}->{days}->[$day_info]->{precipcover};
            } else {
                ($precipcover) = map { $_->{precipcover} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_precipcover_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing precipitation coverage data: $@";
        return;
    }
    return $precipcover;
}

sub set_precipcover_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{precipcover} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{precipcover} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_precipcover_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting precipitation coverage data: $@";
    }
}

sub get_preciptype_on_day {
    my ($self, $day_info) = @_;
    my $preciptype;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $preciptype = $self->{_weather_data}->{days}->[$day_info]->{preciptype};
            } else {
                ($preciptype) = map { $_->{preciptype} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_preciptype_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing precipitation type data: $@";
        return;
    }
    return $preciptype;
}

sub set_preciptype_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{preciptype} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{preciptype} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_preciptype_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting precipitation type data: $@";
    }
}

sub get_snow_on_day {
    my ($self, $day_info) = @_;
    my $snow;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $snow = $self->{_weather_data}->{days}->[$day_info]->{snow};
            } else {
                ($snow) = map { $_->{snow} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_snow_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing snow data: $@";
        return;
    }
    return $snow;
}

sub set_snow_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{snow} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{snow} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_snow_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting snow data: $@";
    }
}

sub get_snowdepth_on_day {
    my ($self, $day_info) = @_;
    my $snowdepth;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $snowdepth = $self->{_weather_data}->{days}->[$day_info]->{snowdepth};
            } else {
                ($snowdepth) = map { $_->{snowdepth} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_snowdepth_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing snow depth data: $@";
        return;
    }
    return $snowdepth;
}

sub set_snowdepth_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{snowdepth} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{snowdepth} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_snowdepth_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting snow depth data: $@";
    }
}

sub get_windgust_on_day {
    my ($self, $day_info) = @_;
    my $windgust;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $windgust = $self->{_weather_data}->{days}->[$day_info]->{windgust};
            } else {
                ($windgust) = map { $_->{windgust} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_windgust_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing wind gust data: $@";
        return;
    }
    return $windgust;
}

sub set_windgust_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{windgust} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{windgust} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_windgust_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting wind gust data: $@";
    }
}

sub get_windspeed_on_day {
    my ($self, $day_info) = @_;
    my $windspeed;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $windspeed = $self->{_weather_data}->{days}->[$day_info]->{windspeed};
            } else {
                ($windspeed) = map { $_->{windspeed} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_windspeed_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing wind speed data: $@";
        return;
    }
    return $windspeed;
}

sub set_windspeed_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{windspeed} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{windspeed} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_windspeed_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting wind speed data: $@";
    }
}

sub get_winddir_on_day {
    my ($self, $day_info) = @_;
    my $winddir;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $winddir = $self->{_weather_data}->{days}->[$day_info]->{winddir};
            } else {
                ($winddir) = map { $_->{winddir} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_winddir_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing wind direction data: $@";
        return;
    }
    return $winddir;
}

sub set_winddir_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{winddir} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{winddir} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_winddir_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting wind direction data: $@";
    }
}

sub get_pressure_on_day {
    my ($self, $day_info) = @_;
    my $pressure;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $pressure = $self->{_weather_data}->{days}->[$day_info]->{pressure};
            } else {
                ($pressure) = map { $_->{pressure} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_pressure_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing pressure data: $@";
        return;
    }
    return $pressure;
}

sub set_pressure_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{pressure} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{pressure} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_pressure_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting pressure data: $@";
    }
}

sub get_cloudcover_on_day {
    my ($self, $day_info) = @_;
    my $cloudcover;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $cloudcover = $self->{_weather_data}->{days}->[$day_info]->{cloudcover};
            } else {
                ($cloudcover) = map { $_->{cloudcover} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_cloudcover_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing cloud cover data: $@";
        return;
    }
    return $cloudcover;
}

sub set_cloudcover_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{cloudcover} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{cloudcover} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_cloudcover_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting cloud cover data: $@";
    }
}

sub get_visibility_on_day {
    my ($self, $day_info) = @_;
    my $visibility;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $visibility = $self->{_weather_data}->{days}->[$day_info]->{visibility};
            } else {
                ($visibility) = map { $_->{visibility} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_visibility_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing visibility data: $@";
        return;
    }
    return $visibility;
}

sub set_visibility_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{visibility} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{visibility} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_visibility_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting visibility data: $@";
    }
}

sub get_solarradiation_on_day {
    my ($self, $day_info) = @_;
    my $solarradiation;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $solarradiation = $self->{_weather_data}->{days}->[$day_info]->{solarradiation};
            } else {
                ($solarradiation) = map { $_->{solarradiation} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_solarradiation_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing solar radiation data: $@";
        return;
    }
    return $solarradiation;
}

sub set_solarradiation_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{solarradiation} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{solarradiation} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_solarradiation_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting solar radiation data: $@";
    }
}

sub get_solarenergy_on_day {
    my ($self, $day_info) = @_;
    my $solarenergy;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $solarenergy = $self->{_weather_data}->{days}->[$day_info]->{solarenergy};
            } else {
                ($solarenergy) = map { $_->{solarenergy} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_solarenergy_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing solar energy data: $@";
        return;
    }
    return $solarenergy;
}

sub set_solarenergy_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{solarenergy} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{solarenergy} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_solarenergy_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting solar energy data: $@";
    }
}

sub get_uvindex_on_day {
    my ($self, $day_info) = @_;
    my $uvindex;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $uvindex = $self->{_weather_data}->{days}->[$day_info]->{uvindex};
            } else {
                ($uvindex) = map { $_->{uvindex} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_uvindex_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing UV index data: $@";
        return;
    }
    return $uvindex;
}

sub set_uvindex_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{uvindex} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{uvindex} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_uvindex_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting UV index data: $@";
    }
}

sub get_severerisk_on_day {
    my ($self, $day_info) = @_;
    my $severerisk;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $severerisk = $self->{_weather_data}->{days}->[$day_info]->{severerisk};
            } else {
                ($severerisk) = map { $_->{severerisk} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_severerisk_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing severe risk data: $@";
        return;
    }
    return $severerisk;
}

sub set_severerisk_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{severerisk} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{severerisk} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_severerisk_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting severe risk data: $@";
    }
}

sub get_sunrise_on_day {
    my ($self, $day_info) = @_;
    my $sunrise;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $sunrise = $self->{_weather_data}->{days}->[$day_info]->{sunrise};
            } else {
                ($sunrise) = map { $_->{sunrise} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_sunrise_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing sunrise data: $@";
        return;
    }
    return $sunrise;
}

sub set_sunrise_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{sunrise} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{sunrise} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_sunrise_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting sunrise data: $@";
    }
}

sub get_sunriseEpoch_on_day {
    my ($self, $day_info) = @_;
    my $sunriseEpoch;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $sunriseEpoch = $self->{_weather_data}->{days}->[$day_info]->{sunriseEpoch};
            } else {
                ($sunriseEpoch) = map { $_->{sunriseEpoch} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_sunriseEpoch_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing sunrise epoch data: $@";
        return;
    }
    return $sunriseEpoch;
}

sub set_sunriseEpoch_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{sunriseEpoch} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{sunriseEpoch} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_sunriseEpoch_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting sunrise epoch data: $@";
    }
}

sub get_sunset_on_day {
    my ($self, $day_info) = @_;
    my $sunset;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $sunset = $self->{_weather_data}->{days}->[$day_info]->{sunset};
            } else {
                ($sunset) = map { $_->{sunset} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_sunset_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing sunset data: $@";
        return;
    }
    return $sunset;
}

sub set_sunset_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{sunset} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{sunset} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_sunset_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting sunset data: $@";
    }
}

sub get_sunsetEpoch_on_day {
    my ($self, $day_info) = @_;
    my $sunsetEpoch;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $sunsetEpoch = $self->{_weather_data}->{days}->[$day_info]->{sunsetEpoch};
            } else {
                ($sunsetEpoch) = map { $_->{sunsetEpoch} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_sunsetEpoch_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing sunset epoch data: $@";
        return;
    }
    return $sunsetEpoch;
}

sub set_sunsetEpoch_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{sunsetEpoch} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{sunsetEpoch} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_sunsetEpoch_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting sunset epoch data: $@";
    }
}

sub get_moonphase_on_day {
    my ($self, $day_info) = @_;
    my $moonphase;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $moonphase = $self->{_weather_data}->{days}->[$day_info]->{moonphase};
            } else {
                ($moonphase) = map { $_->{moonphase} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_moonphase_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing moon phase data: $@";
        return;
    }
    return $moonphase;
}

sub set_moonphase_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{moonphase} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{moonphase} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_moonphase_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting moon phase data: $@";
    }
}

sub get_conditions_on_day {
    my ($self, $day_info) = @_;
    my $conditions;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $conditions = $self->{_weather_data}->{days}->[$day_info]->{conditions};
            } else {
                ($conditions) = map { $_->{conditions} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_conditions_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing conditions data: $@";
        return;
    }
    return $conditions;
}

sub set_conditions_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{conditions} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{conditions} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_conditions_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting conditions data: $@";
    }
}

sub get_description_on_day {
    my ($self, $day_info) = @_;
    my $description;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $description = $self->{_weather_data}->{days}->[$day_info]->{description};
            } else {
                ($description) = map { $_->{description} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_description_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing description data: $@";
        return;
    }
    return $description;
}

sub set_description_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{description} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{description} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_description_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting description data: $@";
    }
}

sub get_icon_on_day {
    my ($self, $day_info) = @_;
    my $icon;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $icon = $self->{_weather_data}->{days}->[$day_info]->{icon};
            } else {
                ($icon) = map { $_->{icon} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_icon_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing icon data: $@";
        return;
    }
    return $icon;
}

sub set_icon_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{icon} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{icon} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_icon_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting icon data: $@";
    }
}

sub get_stations_on_day {
    my ($self, $day_info) = @_;
    my $stations;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $stations = $self->{_weather_data}->{days}->[$day_info]->{stations};
            } else {
                ($stations) = map { $_->{stations} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_stations_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        warn "Error accessing stations data: $@";
        return;
    }
    return $stations;
}

sub set_stations_on_day {
    my ($self, $day_info, $value) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{stations} = $value;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{stations} = $value;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_stations_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting stations data: $@";
    }
}

sub get_hourlyData_on_day {
    my ($self, $day_info, $elements) = @_;
    my $hourly_data;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $hourly_data = $self->{_weather_data}->{days}->[$day_info]->{hours};
            } else {
                ($hourly_data) = map { $_->{hours} } grep { $_->{datetime} eq $day_info } @{$self->{_weather_data}->{days}};
            }
        } else {
            die "Invalid input value for get_hourlyData_on_day with str or int: $day_info";
        }

        if ($elements && ref $elements eq 'ARRAY') {
            return [ map { my %h; @h{@$elements} = @$_{@$elements}; \%h } @$hourly_data ];
        }
    };
    if ($@) {
        warn "Error retrieving hourly data: $@";
        return;
    }
    return $hourly_data;
}

sub set_hourlyData_on_day {
    my ($self, $day_info, $data) = @_;
    eval {
        if (!ref $day_info) {
            if ($day_info =~ /^\d+$/) {
                $self->{_weather_data}->{days}->[$day_info]->{hours} = $data;
            } else {
                for my $day (@{$self->{_weather_data}->{days}}) {
                    if ($day->{datetime} eq $day_info) {
                        $day->{hours} = $data;
                        last;
                    }
                }
            }
        } else {
            die "Invalid input day value for set_hourlyData_on_day with str or int: $day_info";
        }
    };
    if ($@) {
        die "Error setting hourly data: $@";
    }
}

sub filter_item_by_datetimeVal {
    my ($src, $datetimeVal) = @_;
    if (!ref $datetimeVal) {
        # If datetimeVal is a number, treat it as an index
        if ($datetimeVal =~ /^\d+$/) {
            return $src->[$datetimeVal] if defined $src->[$datetimeVal];
        } else {
            # If datetimeVal is a string, search for a matching datetime value
            for my $item (@$src) {
                if ($item->{datetime} eq $datetimeVal) {
                    return $item;
                }
            }
        }
    } else {
        die "Invalid input datetime value for filter_item_by_datetimeVal with str or int: $datetimeVal";
    }
    return; # Return undefined if no matching item is found
}

sub set_item_by_datetimeVal {
    my ($src, $datetimeVal, $data) = @_;
    if (ref $data ne 'HASH') {
        die "Invalid input data value for set_item_by_datetimeVal with dict: $data";
    }
    if (!ref $datetimeVal) {
        if ($datetimeVal =~ /^\d+$/) {
            $data->{datetime} = $src->[$datetimeVal]->{datetime};  # Ensure datetime is not changed
            $src->[$datetimeVal] = $data;
        } else {
            for my $item (@$src) {
                if ($item->{datetime} eq $datetimeVal) {
                    $data->{datetime} = $datetimeVal;  # Ensure datetime is not changed
                    %$item = %$data;
                    last;
                }
            }
        }
    } else {
        die "Invalid input datetime value for set_item_by_datetimeVal with str or int: $datetimeVal";
    }
}

sub update_item_by_datetimeVal {
    my ($src, $datetimeVal, $data) = @_;
    if (ref $data ne 'HASH') {
        die "Invalid input data value for set_item_by_datetimeVal with dict: $data";
    }
    if (!ref $datetimeVal) {
        if ($datetimeVal =~ /^\d+$/) {
            $data->{datetime} = $src->[$datetimeVal]->{datetime};  # Ensure datetime is not changed
            %{$src->[$datetimeVal]} = (%{$src->[$datetimeVal]}, %$data);
        } else {
            for my $item (@$src) {
                if ($item->{datetime} eq $datetimeVal) {
                    %$item = (%$item, %$data);
                    $item->{datetime} = $datetimeVal;  # Ensure datetime is not changed
                    last;
                }
            }
        }
    } else {
        die "Invalid input datetime value for set_item_by_datetimeVal with str or int: $datetimeVal";
    }
}

sub get_data_at_datetime {
    my ($self, $day_info, $time_info, $elements) = @_;
    my $data;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        if ($day_item && exists $day_item->{hours}) {
            $data = filter_item_by_datetimeVal($day_item->{hours}, $time_info);
            if ($data && $elements && ref $elements eq 'ARRAY') {
                my %filtered_data;
                @filtered_data{@$elements} = @$data{@$elements};
                return \%filtered_data;
            }
        } else {
            die "Day item or hours field not found for day_info: $day_info";
        }
    };
    if ($@) {
        warn "Error retrieving data at datetime: $@";
        return;
    }
    return $data;
}

sub set_data_at_datetime {
    my ($self, $day_info, $time_info, $data) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        set_item_by_datetimeVal($day_item->{hours}, $time_info, $data);
    };
    if ($@) {
        die "Error setting data at datetime: $@";
    }
}

sub update_data_at_datetime {
    my ($self, $day_info, $time_info, $data) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        update_item_by_datetimeVal($day_item->{hours}, $time_info, $data);
    };
    if ($@) {
        die "Error updating data at datetime: $@";
    }
}

sub get_datetimeEpoch_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $datetimeEpoch;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        die "Day item not found" unless $day_item;
        die "Hours field not found in day item" unless exists $day_item->{hours};

        my $hour_item = filter_item_by_datetimeVal($day_item->{hours}, $time_info);
        die "Hour item not found" unless $hour_item;

        $datetimeEpoch = $hour_item->{datetimeEpoch};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $datetimeEpoch;
}

sub set_datetimeEpoch_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        die "Day item not found" unless $day_item;
        die "Hours field not found in day item" unless exists $day_item->{hours};

        my $hour_item = filter_item_by_datetimeVal($day_item->{hours}, $time_info);
        die "Hour item not found" unless $hour_item;

        $hour_item->{datetimeEpoch} = $value;
    };
    if ($@) {
        die "Error setting datetimeEpoch: $@";
    }
}

sub get_temp_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $temp;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        die "Day item not found" unless $day_item;
        die "Hours field not found in day item" unless exists $day_item->{hours};

        my $hour_item = filter_item_by_datetimeVal($day_item->{hours}, $time_info);
        die "Hour item not found" unless $hour_item;

        $temp = $hour_item->{temp};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $temp;
}

sub set_temp_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        die "Day item not found" unless $day_item;
        die "Hours field not found in day item" unless exists $day_item->{hours};

        my $hour_item = filter_item_by_datetimeVal($day_item->{hours}, $time_info);
        die "Hour item not found" unless $hour_item;

        $hour_item->{temp} = $value;
    };
    if ($@) {
        die "Error setting temp: $@";
    }
}

sub get_feelslike_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $feelslike;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $feelslike = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{feelslike};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $feelslike;
}

sub set_feelslike_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{feelslike} = $value;
    };
    if ($@) {
        die "Error setting feelslike: $@";
    }
}

sub get_humidity_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $humidity;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $humidity = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{humidity};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $humidity;
}

sub set_humidity_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{humidity} = $value;
    };
    if ($@) {
        die "Error setting humidity: $@";
    }
}

sub get_dew_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $dew;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $dew = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{dew};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $dew;
}

sub set_dew_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{dew} = $value;
    };
    if ($@) {
        die "Error setting dew: $@";
    }
}

sub get_precip_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $precip;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $precip = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{precip};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $precip;
}

sub set_precip_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{precip} = $value;
    };
    if ($@) {
        die "Error setting precip: $@";
    }
}

sub get_precipprob_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $precipprob;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $precipprob = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{precipprob};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $precipprob;
}

sub set_precipprob_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{precipprob} = $value;
    };
    if ($@) {
        die "Error setting precipprob: $@";
    }
}

sub get_snow_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $snow;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $snow = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{snow};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $snow;
}

sub set_snow_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{snow} = $value;
    };
    if ($@) {
        die "Error setting snow: $@";
    }
}

sub get_snowdepth_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $snowdepth;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $snowdepth = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{snowdepth};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $snowdepth;
}

sub set_snowdepth_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{snowdepth} = $value;
    };
    if ($@) {
        die "Error setting snowdepth: $@";
    }
}

sub get_preciptype_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $preciptype;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $preciptype = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{preciptype};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $preciptype;
}

sub set_preciptype_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{preciptype} = $value;
    };
    if ($@) {
        die "Error setting preciptype: $@";
    }
}

sub get_windgust_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $windgust;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $windgust = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{windgust};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $windgust;
}

sub set_windgust_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{windgust} = $value;
    };
    if ($@) {
        die "Error setting windgust: $@";
    }
}

sub get_windspeed_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $windspeed;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $windspeed = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{windspeed};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $windspeed;
}

sub set_windspeed_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{windspeed} = $value;
    };
    if ($@) {
        die "Error setting windspeed: $@";
    }
}

sub get_winddir_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $winddir;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $winddir = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{winddir};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $winddir;
}

sub set_winddir_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{winddir} = $value;
    };
    if ($@) {
        die "Error setting winddir: $@";
    }
}

sub get_pressure_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $pressure;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $pressure = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{pressure};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $pressure;
}

sub set_pressure_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{pressure} = $value;
    };
    if ($@) {
        die "Error setting pressure: $@";
    }
}

sub get_cloudcover_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $cloudcover;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $cloudcover = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{cloudcover};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $cloudcover;
}

sub set_cloudcover_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{cloudcover} = $value;
    };
    if ($@) {
        die "Error setting cloudcover: $@";
    }
}

sub get_visibility_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $visibility;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $visibility = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{visibility};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $visibility;
}

sub set_visibility_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{visibility} = $value;
    };
    if ($@) {
        die "Error setting visibility: $@";
    }
}

sub get_solarradiation_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $solarradiation;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $solarradiation = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{solarradiation};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $solarradiation;
}

sub set_solarradiation_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{solarradiation} = $value;
    };
    if ($@) {
        die "Error setting solarradiation: $@";
    }
}

sub get_solarenergy_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $solarenergy;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $solarenergy = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{solarenergy};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $solarenergy;
}

sub set_solarenergy_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{solarenergy} = $value;
    };
    if ($@) {
        die "Error setting solarenergy: $@";
    }
}

sub get_uvindex_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $uvindex;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $uvindex = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{uvindex};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $uvindex;
}

sub set_uvindex_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{uvindex} = $value;
    };
    if ($@) {
        die "Error setting uvindex: $@";
    }
}

sub get_severerisk_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $severerisk;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $severerisk = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{severerisk};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $severerisk;
}

sub set_severerisk_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{severerisk} = $value;
    };
    if ($@) {
        die "Error setting severerisk: $@";
    }
}

sub get_conditions_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $conditions;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $conditions = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{conditions};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $conditions;
}

sub set_conditions_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{conditions} = $value;
    };
    if ($@) {
        die "Error setting conditions: $@";
    }
}

sub get_description_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $description;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $description = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{description};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $description;
}

sub set_description_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{description} = $value;
    };
    if ($@) {
        die "Error setting description: $@";
    }
}

sub get_icon_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $icon;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $icon = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{icon};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $icon;
}

sub set_icon_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{icon} = $value;
    };
    if ($@) {
        die "Error setting icon: $@";
    }
}

sub get_stations_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    my $stations;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        $stations = filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{stations};
    };
    if ($@) {
        warn "An exception occurred: $@";
        return;
    }
    return $stations;
}

sub set_stations_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{stations} = $value;
    };
    if ($@) {
        die "Error setting stations: $@";
    }
}

sub get_source_at_datetime {
    my ($self, $day_info, $time_info) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        return filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{source};
    };
    warn "An exception occurred: $@" if $@;
    return;
}

sub set_source_at_datetime {
    my ($self, $day_info, $time_info, $value) = @_;
    eval {
        my $day_item = filter_item_by_datetimeVal($self->{_weather_data}->{days}, $day_info);
        filter_item_by_datetimeVal($day_item->{hours}, $time_info)->{source} = $value;
    };
    die "Error setting source: $@" if $@;
}

sub clear_weather_data {
    my $self = shift;
    $self->{_weather_data} = {};
}

1; # End of WeatherVisual.pm

__END__

=head1 NAME

WeatherVisual - A module for fetching and manipulating weather data

=head1 SYNOPSIS

    use WeatherVisual;

    my $weather = WeatherVisual->new(api_key => 'YOUR_API_KEY');

    # Fetch weather data
    my $data = $weather->fetch_weather_data('New York', '2022-01-01', '2022-01-07');

    # Get specific weather data
    my $temp = $weather->get_temp_on_day('2022-01-01');

    # Set specific weather data
    $weather->set_temp_on_day('2022-01-01', 75.0);

=head1 DESCRIPTION

WeatherVisual provides methods to fetch, retrieve, and manipulate weather data from a weather API. The data can be accessed and modified for specific days and times.

=head1 METHODS

=head2 new

    my $weather = WeatherVisual->new(api_key => 'YOUR_API_KEY');

Creates a new WeatherVisual object. Requires an API key.

=head2 fetch_weather_data

    my $data = $weather->fetch_weather_data($location, $from_date, $to_date, $unit_group, $include, $elements);

Fetches weather data for a specified location and date range. Optional parameters include unit group, data to include, and specific elements.

=head2 get_weather_data

    my $data = $weather->get_weather_data(\@elements);

Retrieves the full weather data or specific elements if provided.

=head2 set_weather_data

    $weather->set_weather_data($data);

Sets the full weather data.

=head2 get_weather_daily_data

    my $daily_data = $weather->get_weather_daily_data(\@elements);

Retrieves daily weather data or specific elements if provided.

=head2 set_weather_daily_data

    $weather->set_weather_daily_data($daily_data);

Sets the daily weather data.

=head2 get_weather_hourly_data

    my $hourly_data = $weather->get_weather_hourly_data(\@elements);

Retrieves hourly weather data or specific elements if provided.

=head2 set_weather_hourly_data

    $weather->set_weather_hourly_data($hourly_data);

Sets the hourly weather data.

=head2 get_queryCost

    my $cost = $weather->get_queryCost();

Retrieves the query cost from the weather data.

=head2 set_queryCost

    $weather->set_queryCost($value);

Sets the query cost in the weather data.

=head2 get_latitude

    my $latitude = $weather->get_latitude();

Retrieves the latitude from the weather data.

=head2 set_latitude

    $weather->set_latitude($value);

Sets the latitude in the weather data.

=head2 get_longitude

    my $longitude = $weather->get_longitude();

Retrieves the longitude from the weather data.

=head2 set_longitude

    $weather->set_longitude($value);

Sets the longitude in the weather data.

=head2 get_resolvedAddress

    my $address = $weather->get_resolvedAddress();

Retrieves the resolved address from the weather data.

=head2 set_resolvedAddress

    $weather->set_resolvedAddress($value);

Sets the resolved address in the weather data.

=head2 get_address

    my $address = $weather->get_address();

Retrieves the address from the weather data.

=head2 set_address

    $weather->set_address($value);

Sets the address in the weather data.

=head2 get_timezone

    my $timezone = $weather->get_timezone();

Retrieves the timezone from the weather data.

=head2 set_timezone

    $weather->set_timezone($value);

Sets the timezone in the weather data.

=head2 get_tzoffset

    my $tzoffset = $weather->get_tzoffset();

Retrieves the timezone offset from the weather data.

=head2 set_tzoffset

    $weather->set_tzoffset($value);

Sets the timezone offset in the weather data.

=head2 get_stations

    my $stations = $weather->get_stations();

Retrieves the stations from the weather data.

=head2 set_stations

    $weather->set_stations($value);

Sets the stations in the weather data.

=head2 get_daily_datetimes

    my $datetimes = $weather->get_daily_datetimes();

Retrieves daily datetimes from the weather data.

=head2 get_hourly_datetimes

    my $datetimes = $weather->get_hourly_datetimes();

Retrieves hourly datetimes from the weather data.

=head2 get_data_on_day

    my $data = $weather->get_data_on_day($day_info, \@elements);

Retrieves data for a specific day identified by date or index, with optional elements.

=head2 set_data_on_day

    $weather->set_data_on_day($day_info, $data);

Sets data for a specific day identified by date or index.

=head2 get_temp_on_day

    my $temp = $weather->get_temp_on_day($day_info);

Retrieves the temperature for a specific day identified by date or index.

=head2 set_temp_on_day

    $weather->set_temp_on_day($day_info, $value);

Sets the temperature for a specific day identified by date or index.

=head2 get_tempmax_on_day

    my $tempmax = $weather->get_tempmax_on_day($day_info);

Retrieves the maximum temperature for a specific day identified by date or index.

=head2 set_tempmax_on_day

    $weather->set_tempmax_on_day($day_info, $value);

Sets the maximum temperature for a specific day identified by date or index.

=head2 get_tempmin_on_day

    my $tempmin = $weather->get_tempmin_on_day($day_info);

Retrieves the minimum temperature for a specific day identified by date or index.

=head2 set_tempmin_on_day

    $weather->set_tempmin_on_day($day_info, $value);

Sets the minimum temperature for a specific day identified by date or index.

=head2 get_feelslike_on_day

    my $feelslike = $weather->get_feelslike_on_day($day_info);

Retrieves the "feels like" temperature for a specific day identified by date or index.

=head2 set_feelslike_on_day

    $weather->set_feelslike_on_day($day_info, $value);

Sets the "feels like" temperature for a specific day identified by date or index.

=head2 get_feelslikemax_on_day

    my $feelslikemax = $weather->get_feelslikemax_on_day($day_info);

Retrieves the maximum "feels like" temperature for a specific day identified by date or index.

=head2 set_feelslikemax_on_day

    $weather->set_feelslikemax_on_day($day_info, $value);

Sets the maximum "feels like" temperature for a specific day identified by date or index.

=head2 get_feelslikemin_on_day

    my $feelslikemin = $weather->get_feelslikemin_on_day($day_info);

Retrieves the minimum "feels like" temperature for a specific day identified by date or index.

=head2 set_feelslikemin_on_day

    $weather->set_feelslikemin_on_day($day_info, $value);

Sets the minimum "feels like" temperature for a specific day identified by date or index.

=head2 get_dew_on_day

    my $dew = $weather->get_dew_on_day($day_info);

Retrieves the dew point temperature for a specific day identified by date or index.

=head2 set_dew_on_day

    $weather->set_dew_on_day($day_info, $value);

Sets the dew point temperature for a specific day identified by date or index.

=head2 get_humidity_on_day

    my $humidity = $weather->get_humidity_on_day($day_info);

Retrieves the humidity for a specific day identified by date or index.

=head2 set_humidity_on_day

    $weather->set_humidity_on_day($day_info, $value);

Sets the humidity for a specific day identified by date or index.

=head2 get_precip_on_day

    my $precip = $weather->get_precip_on_day($day_info);

Retrieves the precipitation amount for a specific day identified by date or index.

=head2 set_precip_on_day

    $weather->set_precip_on_day($day_info, $value);

Sets the precipitation amount for a specific day identified by date or index.

=head2 get_precipprob_on_day

    my $precipprob = $weather->get_precipprob_on_day($day_info);

Retrieves the probability of precipitation for a specific day identified by date or index.

=head2 set_precipprob_on_day

    $weather->set_precipprob_on_day($day_info, $value);

Sets the probability of precipitation for a specific day identified by date or index.

=head2 get_precipcover_on_day

    my $precipcover = $weather->get_precipcover_on_day($day_info);

Retrieves the precipitation coverage for a specific day identified by date or index.

=head2 set_precipcover_on_day

    $weather->set_precipcover_on_day($day_info, $value);

Sets the precipitation coverage for a specific day identified by date or index.

=head2 get_preciptype_on_day

    my $preciptype = $weather->get_preciptype_on_day($day_info);

Retrieves the type of precipitation for a specific day identified by date or index.

=head2 set_preciptype_on_day

    $weather->set_preciptype_on_day($day_info, $value);

Sets the type of precipitation for a specific day identified by date or index.

=head2 get_snow_on_day

    my $snow = $weather->get_snow_on_day($day_info);

Retrieves the snow amount for a specific day identified by date or index.

=head2 set_snow_on_day

    $weather->set_snow_on_day($day_info, $value);

Sets the snow amount for a specific day identified by date or index.

=head2 get_snowdepth_on_day

    my $snowdepth = $weather->get_snowdepth_on_day($day_info);

Retrieves the snow depth for a specific day identified by date or index.

=head2 set_snowdepth_on_day

    $weather->set_snowdepth_on_day($day_info, $value);

Sets the snow depth for a specific day identified by date or index.

=head2 get_windgust_on_day

    my $windgust = $weather->get_windgust_on_day($day_info);

Retrieves the wind gust speed for a specific day identified by date or index.

=head2 set_windgust_on_day

    $weather->set_windgust_on_day($day_info, $value);

Sets the wind gust speed for a specific day identified by date or index.

=head2 get_windspeed_on_day

    my $windspeed = $weather->get_windspeed_on_day($day_info);

Retrieves the wind speed for a specific day identified by date or index.

=head2 set_windspeed_on_day

    $weather->set_windspeed_on_day($day_info, $value);

Sets the wind speed for a specific day identified by date or index.

=head2 get_winddir_on_day

    my $winddir = $weather->get_winddir_on_day($day_info);

Retrieves the wind direction for a specific day identified by date or index.

=head2 set_winddir_on_day

    $weather->set_winddir_on_day($day_info, $value);

Sets the wind direction for a specific day identified by date or index.

=head2 get_pressure_on_day

    my $pressure = $weather->get_pressure_on_day($day_info);

Retrieves the pressure for a specific day identified by date or index.

=head2 set_pressure_on_day

    $weather->set_pressure_on_day($day_info, $value);

Sets the pressure for a specific day identified by date or index.

=head2 get_cloudcover_on_day

    my $cloudcover = $weather->get_cloudcover_on_day($day_info);

Retrieves the cloud cover for a specific day identified by date or index.

=head2 set_cloudcover_on_day

    $weather->set_cloudcover_on_day($day_info, $value);

Sets the cloud cover for a specific day identified by date or index.

=head2 get_visibility_on_day

    my $visibility = $weather->get_visibility_on_day($day_info);

Retrieves the visibility for a specific day identified by date or index.

=head2 set_visibility_on_day

    $weather->set_visibility_on_day($day_info, $value);

Sets the visibility for a specific day identified by date or index.

=head2 get_solarradiation_on_day

    my $solarradiation = $weather->get_solarradiation_on_day($day_info);

Retrieves the solar radiation for a specific day identified by date or index.

=head2 set_solarradiation_on_day

    $weather->set_solarradiation_on_day($day_info, $value);

Sets the solar radiation for a specific day identified by date or index.

=head2 get_solarenergy_on_day

    my $solarenergy = $weather->get_solarenergy_on_day($day_info);

Retrieves the solar energy for a specific day identified by date or index.

=head2 set_solarenergy_on_day

    $weather->set_solarenergy_on_day($day_info, $value);

Sets the solar energy for a specific day identified by date or index.

=head2 get_uvindex_on_day

    my $uvindex = $weather->get_uvindex_on_day($day_info);

Retrieves the UV index for a specific day identified by date or index.

=head2 set_uvindex_on_day

    $weather->set_uvindex_on_day($day_info, $value);

Sets the UV index for a specific day identified by date or index.

=head2 get_severerisk_on_day

    my $severerisk = $weather->get_severerisk_on_day($day_info);

Retrieves the severe risk for a specific day identified by date or index.

=head2 set_severerisk_on_day

    $weather->set_severerisk_on_day($day_info, $value);

Sets the severe risk for a specific day identified by date or index.

=head2 get_sunrise_on_day

    my $sunrise = $weather->get_sunrise_on_day($day_info);

Retrieves the sunrise time for a specific day identified by date or index.

=head2 set_sunrise_on_day

    $weather->set_sunrise_on_day($day_info, $value);

Sets the sunrise time for a specific day identified by date or index.

=head2 get_sunriseEpoch_on_day

    my $sunriseEpoch = $weather->get_sunriseEpoch_on_day($day_info);

Retrieves the sunrise epoch time for a specific day identified by date or index.

=head2 set_sunriseEpoch_on_day

    $weather->set_sunriseEpoch_on_day($day_info, $value);

Sets the sunrise epoch time for a specific day identified by date or index.

=head2 get_sunset_on_day

    my $sunset = $weather->get_sunset_on_day($day_info);

Retrieves the sunset time for a specific day identified by date or index.

=head2 set_sunset_on_day

    $weather->set_sunset_on_day($day_info, $value);

Sets the sunset time for a specific day identified by date or index.

=head2 get_sunsetEpoch_on_day

    my $sunsetEpoch = $weather->get_sunsetEpoch_on_day($day_info);

Retrieves the sunset epoch time for a specific day identified by date or index.

=head2 set_sunsetEpoch_on_day

    $weather->set_sunsetEpoch_on_day($day_info, $value);

Sets the sunset epoch time for a specific day identified by date or index.

=head2 get_moonphase_on_day

    my $moonphase = $weather->get_moonphase_on_day($day_info);

Retrieves the moon phase for a specific day identified by date or index.

=head2 set_moonphase_on_day

    $weather->set_moonphase_on_day($day_info, $value);

Sets the moon phase for a specific day identified by date or index.

=head2 get_conditions_on_day

    my $conditions = $weather->get_conditions_on_day($day_info);

Retrieves the weather conditions for a specific day identified by date or index.

=head2 set_conditions_on_day

    $weather->set_conditions_on_day($day_info, $value);

Sets the weather conditions for a specific day identified by date or index.

=head2 get_description_on_day

    my $description = $weather->get_description_on_day($day_info);

Retrieves the description for a specific day identified by date or index.

=head2 set_description_on_day

    $weather->set_description_on_day($day_info, $value);

Sets the description for a specific day identified by date or index.

=head2 get_icon_on_day

    my $icon = $weather->get_icon_on_day($day_info);

Retrieves the icon for a specific day identified by date or index.

=head2 set_icon_on_day

    $weather->set_icon_on_day($day_info, $value);

Sets the icon for a specific day identified by date or index.

=head2 get_stations_on_day

    my $stations = $weather->get_stations_on_day($day_info);

Retrieves the stations for a specific day identified by date or index.

=head2 set_stations_on_day

    $weather->set_stations_on_day($day_info, $value);

Sets the stations for a specific day identified by date or index.

=head2 get_hourlyData_on_day

    my $hourly_data = $weather->get_hourlyData_on_day($day_info, \@elements);

Retrieves the hourly data for a specific day identified by date or index, with optional elements.

=head2 set_hourlyData_on_day

    $weather->set_hourlyData_on_day($day_info, $data);

Sets the hourly data for a specific day identified by date or index.

=head2 filter_item_by_datetimeVal

    my $item = filter_item_by_datetimeVal($src, $datetimeVal);

Filters an item by date or index from a source array.

=head2 set_item_by_datetimeVal

    set_item_by_datetimeVal($src, $datetimeVal, $data);

Sets an item by date or index in a source array.

=head2 update_item_by_datetimeVal

    update_item_by_datetimeVal($src, $datetimeVal, $data);

Updates an item by date or index in a source array.

=head2 get_data_at_datetime

    my $data = $weather->get_data_at_datetime($day_info, $time_info, \@elements);

Retrieves data at a specific date and time identified by date and time strings or indexes, with optional elements.

=head2 set_data_at_datetime

    $weather->set_data_at_datetime($day_info, $time_info, $data);

Sets data at a specific date and time identified by date and time strings or indexes.

=head2 update_data_at_datetime

    $weather->update_data_at_datetime($day_info, $time_info, $data);

Updates data at a specific date and time identified by date and time strings or indexes.

=head2 get_datetimeEpoch_at_datetime

    my $datetimeEpoch = $weather->get_datetimeEpoch_at_datetime($day_info, $time_info);

Retrieves the epoch time at a specific date and time identified by date and time strings or indexes.

=head2 set_datetimeEpoch_at_datetime

    $weather->set_datetimeEpoch_at_datetime($day_info, $time_info, $value);

Sets the epoch time at a specific date and time identified by date and time strings or indexes.

=head2 get_temp_at_datetime

    my $temp = $weather->get_temp_at_datetime($day_info, $time_info);

Retrieves the temperature at a specific date and time identified by date and time strings or indexes.

=head2 set_temp_at_datetime

    $weather->set_temp_at_datetime($day_info, $time_info, $value);

Sets the temperature at a specific date and time identified by date and time strings or indexes.

=head2 get_feelslike_at_datetime

    my $feelslike = $weather->get_feelslike_at_datetime($day_info, $time_info);

Retrieves the "feels like" temperature at a specific date and time identified by date and time strings or indexes.

=head2 set_feelslike_at_datetime

    $weather->set_feelslike_at_datetime($day_info, $time_info, $value);

Sets the "feels like" temperature at a specific date and time identified by date and time strings or indexes.

=head2 get_humidity_at_datetime

    my $humidity = $weather->get_humidity_at_datetime($day_info, $time_info);

Retrieves the humidity at a specific date and time identified by date and time strings or indexes.

=head2 set_humidity_at_datetime

    $weather->set_humidity_at_datetime($day_info, $time_info, $value);

Sets the humidity at a specific date and time identified by date and time strings or indexes.

=head2 get_dew_at_datetime

    my $dew = $weather->get_dew_at_datetime($day_info, $time_info);

Retrieves the dew point temperature at a specific date and time identified by date and time strings or indexes.

=head2 set_dew_at_datetime

    $weather->set_dew_at_datetime($day_info, $time_info, $value);

Sets the dew point temperature at a specific date and time identified by date and time strings or indexes.

=head2 get_precip_at_datetime

    my $precip = $weather->get_precip_at_datetime($day_info, $time_info);

Retrieves the precipitation amount at a specific date and time identified by date and time strings or indexes.

=head2 set_precip_at_datetime

    $weather->set_precip_at_datetime($day_info, $time_info, $value);

Sets the precipitation amount at a specific date and time identified by date and time strings or indexes.

=head2 get_precipprob_at_datetime

    my $precipprob = $weather->get_precipprob_at_datetime($day_info, $time_info);

Retrieves the probability of precipitation at a specific date and time identified by date and time strings or indexes.

=head2 set_precipprob_at_datetime

    $weather->set_precipprob_at_datetime($day_info, $time_info, $value);

Sets the probability of precipitation at a specific date and time identified by date and time strings or indexes.

=head2 get_snow_at_datetime

    my $snow = $weather->get_snow_at_datetime($day_info, $time_info);

Retrieves the snow amount at a specific date and time identified by date and time strings or indexes.

=head2 set_snow_at_datetime

    $weather->set_snow_at_datetime($day_info, $time_info, $value);

Sets the snow amount at a specific date and time identified by date and time strings or indexes.

=head2 get_snowdepth_at_datetime

    my $snowdepth = $weather->get_snowdepth_at_datetime($day_info, $time_info);

Retrieves the snow depth at a specific date and time identified by date and time strings or indexes.

=head2 set_snowdepth_at_datetime

    $weather->set_snowdepth_at_datetime($day_info, $time_info, $value);

Sets the snow depth at a specific date and time identified by date and time strings or indexes.

=head2 get_preciptype_at_datetime

    my $preciptype = $weather->get_preciptype_at_datetime($day_info, $time_info);

Retrieves the precipitation type at a specific date and time identified by date and time strings or indexes.

=head2 set_preciptype_at_datetime

    $weather->set_preciptype_at_datetime($day_info, $time_info, $value);

Sets the precipitation type at a specific date and time identified by date and time strings or indexes.

=head2 get_windgust_at_datetime

    my $windgust = $weather->get_windgust_at_datetime($day_info, $time_info);

Retrieves the wind gust speed at a specific date and time identified by date and time strings or indexes.

=head2 set_windgust_at_datetime

    $weather->set_windgust_at_datetime($day_info, $time_info, $value);

Sets the wind gust speed at a specific date and time identified by date and time strings or indexes.

=head2 get_windspeed_at_datetime

    my $windspeed = $weather->get_windspeed_at_datetime($day_info, $time_info);

Retrieves the wind speed at a specific date and time identified by date and time strings or indexes.

=head2 set_windspeed_at_datetime

    $weather->set_windspeed_at_datetime($day_info, $time_info, $value);

Sets the wind speed at a specific date and time identified by date and time strings or indexes.

=head2 get_winddir_at_datetime

    my $winddir = $weather->get_winddir_at_datetime($day_info, $time_info);

Retrieves the wind direction at a specific date and time identified by date and time strings or indexes.

=head2 set_winddir_at_datetime

    $weather->set_winddir_at_datetime($day_info, $time_info, $value);

Sets the wind direction at a specific date and time identified by date and time strings or indexes.

=head2 get_pressure_at_datetime

    my $pressure = $weather->get_pressure_at_datetime($day_info, $time_info);

Retrieves the pressure at a specific date and time identified by date and time strings or indexes.

=head2 set_pressure_at_datetime

    $weather->set_pressure_at_datetime($day_info, $time_info, $value);

Sets the pressure at a specific date and time identified by date and time strings or indexes.

=head2 get_cloudcover_at_datetime

    my $cloudcover = $weather->get_cloudcover_at_datetime($day_info, $time_info);

Retrieves the cloud cover at a specific date and time identified by date and time strings or indexes.

=head2 set_cloudcover_at_datetime

    $weather->set_cloudcover_at_datetime($day_info, $time_info, $value);

Sets the cloud cover at a specific date and time identified by date and time strings or indexes.

=head2 get_visibility_at_datetime

    my $visibility = $weather->get_visibility_at_datetime($day_info, $time_info);

Retrieves the visibility at a specific date and time identified by date and time strings or indexes.

=head2 set_visibility_at_datetime

    $weather->set_visibility_at_datetime($day_info, $time_info, $value);

Sets the visibility at a specific date and time identified by date and time strings or indexes.

=head2 get_solarradiation_at_datetime

    my $solarradiation = $weather->get_solarradiation_at_datetime($day_info, $time_info);

Retrieves the solar radiation at a specific date and time identified by date and time strings or indexes.

=head2 set_solarradiation_at_datetime

    $weather->set_solarradiation_at_datetime($day_info, $time_info, $value);

Sets the solar radiation at a specific date and time identified by date and time strings or indexes.

=head2 get_solarenergy_at_datetime

    my $solarenergy = $weather->get_solarenergy_at_datetime($day_info, $time_info);

Retrieves the solar energy at a specific date and time identified by date and time strings or indexes.

=head2 set_solarenergy_at_datetime

    $weather->set_solarenergy_at_datetime($day_info, $time_info, $value);

Sets the solar energy at a specific date and time identified by date and time strings or indexes.

=head2 get_uvindex_at_datetime

    my $uvindex = $weather->get_uvindex_at_datetime($day_info, $time_info);

Retrieves the UV index at a specific date and time identified by date and time strings or indexes.

=head2 set_uvindex_at_datetime

    $weather->set_uvindex_at_datetime($day_info, $time_info, $value);

Sets the UV index at a specific date and time identified by date and time strings or indexes.

=head2 get_severerisk_at_datetime

    my $severerisk = $weather->get_severerisk_at_datetime($day_info, $time_info);

Retrieves the severe risk at a specific date and time identified by date and time strings or indexes.

=head2 set_severerisk_at_datetime

    $weather->set_severerisk_at_datetime($day_info, $time_info, $value);

Sets the severe risk at a specific date and time identified by date and time strings or indexes.

=head2 get_conditions_at_datetime

    my $conditions = $weather->get_conditions_at_datetime($day_info, $time_info);

Retrieves the weather conditions at a specific date and time identified by date and time strings or indexes.

=head2 set_conditions_at_datetime

    $weather->set_conditions_at_datetime($day_info, $time_info, $value);

Sets the weather conditions at a specific date and time identified by date and time strings or indexes.

=head2 get_description_at_datetime

    my $description = $weather->get_description_at_datetime($day_info, $time_info);

Retrieves the description at a specific date and time identified by date and time strings or indexes.

=head2 set_description_at_datetime

    $weather->set_description_at_datetime($day_info, $time_info, $value);

Sets the description at a specific date and time identified by date and time strings or indexes.

=head2 get_icon_at_datetime

    my $icon = $weather->get_icon_at_datetime($day_info, $time_info);

Retrieves the icon at a specific date and time identified by date and time strings or indexes.

=head2 set_icon_at_datetime

    $weather->set_icon_at_datetime($day_info, $time_info, $value);

Sets the icon at a specific date and time identified by date and time strings or indexes.

=head2 get_stations_at_datetime

    my $stations = $weather->get_stations_at_datetime($day_info, $time_info);

Retrieves the stations at a specific date and time identified by date and time strings or indexes.

=head2 set_stations_at_datetime

    $weather->set_stations_at_datetime($day_info, $time_info, $value);

Sets the stations at a specific date and time identified by date and time strings or indexes.

=head2 get_source_at_datetime

    my $source = $weather->get_source_at_datetime($day_info, $time_info);

Retrieves the source type of the weather data at a specific date and time identified by date and time strings or indexes.

=head2 set_source_at_datetime

    $weather->set_source_at_datetime($day_info, $time_info, $value);

Sets the source type of the weather data at a specific date and time identified by date and time strings or indexes.

=head2 clear_weather_data

    $weather->clear_weather_data();

Clears all weather data stored in the object.

=head1 AUTHOR

VisualCrossing, E<lt>https://www.visualcrossing.com/E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2024 VisualCrossing

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
