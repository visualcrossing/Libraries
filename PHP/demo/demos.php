<?php
require_once '../vendor/autoload.php';
require_once '../src/WeatherVisual.php';

use WeatherVisual\WeatherData;

// Replace with your actual API key
$apiKey = '3KAJKHWT3UEMRQWF2ABKVVVZE';

// Create a new instance of WeatherData
$weather = new WeatherData($apiKey);

// Fetch weather data for a specific location and date range
try {
    $location = 'New York, NY';
    $fromDate = '2024-01-01';
    $toDate = '2024-01-07';
    $unitGroup = 'us';
    $include = 'hours';
    $weather->fetchWeatherData($location, $fromDate, $toDate, $unitGroup, $include);
} catch (Exception $e) {
    echo "Failed to fetch weather data: " . $e->getMessage() . PHP_EOL;
}

// Get weather data for a specific day
$dayInfo = '2024-01-02';
$timeInfo = '12:00:00';

// Get temperature at specific datetime
try {
    $temperature = $weather->getTempAtDatetime($dayInfo, $timeInfo);
    echo "Temperature at $dayInfo $timeInfo: $temperature" . PHP_EOL;
} catch (Exception $e) {
    echo "Error getting temperature: " . $e->getMessage() . PHP_EOL;
}

// Set temperature at specific datetime
try {
    $newTemperature = 72.0;
    $weather->setTempAtDatetime($dayInfo, $timeInfo, $newTemperature);
    echo "Updated Temperature at $dayInfo $timeInfo: " . $weather->getTempAtDatetime($dayInfo, $timeInfo) . PHP_EOL;
} catch (Exception $e) {
    echo "Error setting temperature: " . $e->getMessage() . PHP_EOL;
}

// Get conditions at specific datetime
try {
    $conditions = $weather->getConditionsAtDatetime($dayInfo, $timeInfo);
    echo "Conditions at $dayInfo $timeInfo: $conditions" . PHP_EOL;
} catch (Exception $e) {
    echo "Error getting conditions: " . $e->getMessage() . PHP_EOL;
}

// Set conditions at specific datetime
try {
    $newConditions = 'Sunny';
    $weather->setConditionsAtDatetime($dayInfo, $timeInfo, $newConditions);
    echo "Updated Conditions at $dayInfo $timeInfo: " . $weather->getConditionsAtDatetime($dayInfo, $timeInfo) . PHP_EOL;
} catch (Exception $e) {
    echo "Error setting conditions: " . $e->getMessage() . PHP_EOL;
}

// Get weather icon at specific datetime
try {
    $icon = $weather->getIconAtDatetime($dayInfo, $timeInfo);
    echo "Weather Icon at $dayInfo $timeInfo: $icon" . PHP_EOL;
} catch (Exception $e) {
    echo "Error getting icon: " . $e->getMessage() . PHP_EOL;
}

// Set weather icon at specific datetime
try {
    $newIcon = 'clear-day';
    $weather->setIconAtDatetime($dayInfo, $timeInfo, $newIcon);
    echo "Updated Icon at $dayInfo $timeInfo: " . $weather->getIconAtDatetime($dayInfo, $timeInfo) . PHP_EOL;
} catch (Exception $e) {
    echo "Error setting icon: " . $e->getMessage() . PHP_EOL;
}

// Clear weather data
$weather->clearWeatherData();
echo "Weather data cleared." . PHP_EOL;

?>
