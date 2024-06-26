# WeatherVisual

WeatherVisual is a PHP package for fetching weather data from VisualCrossing Weather API and handling the data.

## Run the Demo and Tests

1. **Install Composer Dependencies**:
   - Run Composer to install the required dependencies.
   ```bash
   composer install
   ```

2. **Start XAMPP**:
   - Open the XAMPP Control Panel and start Apache and MySQL.

3. **Run the Demo**:
   - Place the `WeatherVisualProject` directory in the `htdocs` directory of XAMPP.
   - Open your web browser and navigate to `http://localhost/WeatherVisualProject/demo/demos.php`.

4. **Run the Tests**:
   - Open Command Prompt or Terminal.
   - Navigate to your project directory (`C:\xampp\htdocs\WeatherVisualProject`).
   - Run the PHPUnit tests.
   ```bash
   vendor/bin/phpunit tests/WeatherVisualTest.php

## Distribute the module
1. **Register at Packagist**:
   - Create an account at [Packagist](https://packagist.org/).
   - Submit your package by providing the GitHub repository URL.

2. **Publish Your Package**:
   - Follow the instructions on Packagist to publish your package.
   - Once published, others can install your module using Composer:
     ```bash
     composer require yourname/weathervisual
     ```

## Installation

To install WeatherVisual, use Composer:

```bash
composer require visualcrossing/weathervisual
```

## Usage

### Initialization
```php
use WeatherVisual\WeatherData;

$data = [
    'days' => [
        [
            'datetime' => '2024-01-02',
            'hours' => [
                ['datetime' => '00:00:00', 'temp' => 70.0, 'humidity' => 50],
                ['datetime' => '01:00:00', 'temp' => 68.0, 'humidity' => 55],
            ]
        ]
    ]
];

$weather = new WeatherVisual($data);
```
or
```php
<?php
require 'vendor/autoload.php';

use WeatherVisual\WeatherData;

$apiKey = 'YOUR_API_KEY';
$weather = new WeatherData($apiKey);

try {
    $data = $weather->fetchWeatherData('Los Angeles, CA', '2024-01-01', '2024-01-07');
    print_r($data);
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
?>
```

### Get and Set Temperature
```php
// Get temperature at a specific datetime
echo "Temperature at datetime: " . $weather->getTempAtDatetime('2024-01-02', '00:00:00') . "\n";

// Set temperature at a specific datetime
$weather->setTempAtDatetime('2024-01-02', '00:00:00', 72.0);
echo "Updated Temperature at datetime: " . $weather->getTempAtDatetime('2024-01-02', '00:00:00') . "\n";
```

### Get and Set Humidity
```php
// Get humidity at a specific datetime
echo "Humidity at datetime: " . $weather->getHumidityAtDatetime('2024-01-02', '00:00:00') . "\n";

// Set humidity at a specific datetime
$weather->setHumidityAtDatetime('2024-01-02', '00:00:00', 60);
echo "Updated Humidity at datetime: " . $weather->getHumidityAtDatetime('2024-01-02', '00:00:00') . "\n";
```

## Running Tests
To run the tests, use PHPUnit:

```bash
vendor/bin/phpunit
```

or

```bash
php test_weather_data.php
```