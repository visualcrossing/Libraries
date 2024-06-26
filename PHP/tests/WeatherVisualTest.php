<?php

use PHPUnit\Framework\TestCase;
use WeatherVisual\WeatherVisual;

class WeatherVisualTest extends TestCase
{
    private $weatherData;

    protected function setUp(): void
    {
        // $this->weatherData = [
        //     'days' => [
        //         [
        //             'datetime' => '2024-01-02',
        //             'hours' => [
        //                 ['datetime' => '00:00:00', 'temp' => 70.0, 'humidity' => 50],
        //                 ['datetime' => '01:00:00', 'temp' => 68.0, 'humidity' => 55],
        //             ]
        //         ]
        //     ]
        // ];
        $this->weatherData = new WeatherData('your_api_key');
    }

    public function testGetSetWeatherData()
    {
        $this->weatherData->setWeatherData(['key' => 'value']);
        $this->assertEquals(['key' => 'value'], $this->weatherData->getWeatherData());
    }

    public function testFetchWeatherData()
    {
        $data = $this->weatherData->fetchWeatherData('New York', '2023-01-01', '2023-01-02');
        $this->assertIsArray($data);
    }

    public function testGetTempAtDatetime()
    {
        $weather = new WeatherVisual($this->weatherData);
        $temp = $weather->getTempAtDatetime('2024-01-02', '00:00:00');
        $this->assertEquals(70.0, $temp);
    }

    public function testSetTempAtDatetime()
    {
        $weather = new WeatherVisual($this->weatherData);
        $weather->setTempAtDatetime('2024-01-02', '00:00:00', 72.0);
        $temp = $weather->getTempAtDatetime('2024-01-02', '00:00:00');
        $this->assertEquals(72.0, $temp);
    }

    public function testGetHumidityAtDatetime()
    {
        $weather = new WeatherVisual($this->weatherData);
        $humidity = $weather->getHumidityAtDatetime('2024-01-02', '00:00:00');
        $this->assertEquals(50, $humidity);
    }

    public function testSetHumidityAtDatetime()
    {
        $weather = new WeatherVisual($this->weatherData);
        $weather->setHumidityAtDatetime('2024-01-02', '00:00:00', 60);
        $humidity = $weather->getHumidityAtDatetime('2024-01-02', '00:00:00');
        $this->assertEquals(60, $humidity);
    }

    // Additional tests for other methods can be added here
}

?>
