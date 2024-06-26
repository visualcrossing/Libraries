<?php

require 'vendor/autoload.php';

use WeatherVisual\WeatherData;

$apiKey = 'YOUR_API_KEY';
$weather = new WeatherData($apiKey);

try {
    $weather->fetchWeatherData('New York, NY', '2024-01-01', '2024-01-02');

    // Get temperature on a specific day
    echo "Temperature on day: " . $weather->getTempOnDay('2024-01-01') . "\n";

    // Set temperature on a specific day
    $weather->setTempOnDay('2024-01-01', 72.0);
    echo "Updated Temperature on day: " . $weather->getTempOnDay('2024-01-01') . "\n";

    // Get maximum temperature on a specific day
    echo "Maximum Temperature on day: " . $weather->getTempMaxOnDay('2024-01-01') . "\n";

    // Set maximum temperature on a specific day
    $weather->setTempMaxOnDay('2024-01-01', 75.0);
    echo "Updated Maximum Temperature on day: " . $weather->getTempMaxOnDay('2024-01-01') . "\n";

} catch (\Exception $e) {
    echo "An error occurred: " . $e->getMessage();
}

?>
