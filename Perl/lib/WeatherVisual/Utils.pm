package WeatherVisual::Utils;
use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = qw(update_dictionary is_valid_dict extract_subdict_by_keys);

sub update_dictionary {
    my ($original, $updates, $exclude_keys) = @_;
    $exclude_keys ||= [];
    my %exclude = map { $_ => 1 } @$exclude_keys;
    for my $key (keys %$updates) {
        next if exists $exclude{$key};
        $original->{$key} = $updates->{$key};
    }
}

sub is_valid_dict {
    my ($variable, $allowed_keys) = @_;
    return 0 unless ref $variable eq 'HASH';
    my %allowed = map { $_ => 1 } @$allowed_keys;
    for my $key (keys %$variable) {
        return 0 unless exists $allowed{$key};
    }
    return 1;
}

sub extract_subdict_by_keys {
    my ($original_dict, $keys_list) = @_;
    my %sub_dict;
    for my $key (@$keys_list) {
        $sub_dict{$key} = $original_dict->{$key} if exists $original_dict->{$key};
    }
    return \%sub_dict;
}

1;

__END__

=head1 NAME

WeatherVisual::Utils - Utility functions for the WeatherVisual module

=head1 SYNOPSIS

  use WeatherVisual::Utils qw(update_dictionary is_valid_dict extract_subdict_by_keys);

=head1 DESCRIPTION

This module provides utility functions for the WeatherVisual module.

=head1 FUNCTIONS

=head2 update_dictionary

Update the original dictionary with values from the updates dictionary, excluding keys specified in exclude_keys.

=head2 is_valid_dict

Check if the variable is a dictionary and if all its keys are in the allowed keys.

=head2 extract_subdict_by_keys

Extract a sub-dictionary from the original dictionary with keys specified in keys_list.

=cut
