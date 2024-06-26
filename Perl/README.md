# WeatherVisual Perl Module

## Description

The `WeatherVisual` module provides a way to fetch and manipulate weather data from the Visual Crossing Weather API.

## Installation

1. Ensure you have Perl installed on your system.
2. Install the necessary dependencies:
   ```sh
   cpan install LWP::UserAgent JSON DateTime::Format::Strptime
   ```
Use `Makefile.PL` to install the module
    ```sh
    perl Makefile.PL
    make
    make test
    make install
    ```