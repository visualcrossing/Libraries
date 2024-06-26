<?php

namespace WeatherVisual;

use GuzzleHttp\Client;
use GuzzleHttp\Exception\RequestException;

class WeatherData
{
    const BASE_URL = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline';
    const DATETIME = 'datetime';

    private $apiKey;
    private $weatherData;
    private $client;

    public function __construct($apiKey)
    {
        $this->apiKey = $apiKey;
        $this->weatherData = [];
        $this->client = new Client(['base_uri' => self::BASE_URL]);
    }

    public function fetchWeatherData($location, $fromDate, $toDate, $unitGroup = 'us', $include = 'days', $elements = [])
    {
        $locationEncoded = urlencode($location);
        $url = sprintf(
            '%s/%s/%s/%s?unitGroup=%s&include=%s&key=%s&elements=%s',
            self::BASE_URL,
            $locationEncoded,
            $fromDate,
            $toDate,
            $unitGroup,
            $include,
            $this->apiKey,
            implode(',', $elements)
        );
        
        try {
            $response = $this->client->get($url);
            if ($response->getStatusCode() === 200) {
                $this->weatherData = json_decode($response->getBody(), true);
            } else {
                throw new \Exception('Failed to fetch weather data: ' . $response->getReasonPhrase());
            }
        } catch (RequestException $e) {
            throw new \Exception('Failed to fetch weather data: ' . $e->getMessage());
        }

        return $this->weatherData;
    }

    public function getWeatherData($elements = [])
    {
        return empty($elements) ? $this->weatherData : $this->extractSubdictByKeys($this->weatherData, $elements);
    }

    public function setWeatherData($data)
    {
        $this->weatherData = $data;
    }

    public function getWeatherDailyData($elements = [])
    {
        if (empty($elements)) {
            return $this->weatherData['days'];
        }
        return array_map(function ($day) use ($elements) {
            return $this->extractSubdictByKeys($day, $elements);
        }, $this->weatherData['days']);
    }

    public function setWeatherDailyData($dailyData)
    {
        $this->weatherData['days'] = $dailyData;
    }

    public function getWeatherHourlyData($elements = [])
    {
        $hourlyData = array_merge(...array_map(function ($day) {
            return $day['hours'] ?? [];
        }, $this->weatherData['days']));

        if (empty($elements)) {
            return $hourlyData;
        }

        return array_map(function ($hour) use ($elements) {
            return $this->extractSubdictByKeys($hour, $elements);
        }, $hourlyData);
    }

    private function extractSubdictByKeys($data, $keys)
    {
        return array_filter($data, function ($key) use ($keys) {
            return in_array($key, $keys);
        }, ARRAY_FILTER_USE_KEY);
    }

    public function getDailyDatetimes()
    {
        try {
            return array_map(function ($day) {
                return new \DateTime($day['datetime']);
            }, $this->weatherData['days']);
        } catch (\Exception $e) {
            error_log("An error occurred in get_daily_datetimes: " . $e->getMessage());
            return [];
        }
    }

    public function getHourlyDatetimes()
    {
        try {
            return array_merge(...array_map(function ($day) {
                return array_map(function ($hour) use ($day) {
                    return new \DateTime($day['datetime'] . ' ' . $hour['datetime']);
                }, $day['hours'] ?? []);
            }, $this->weatherData['days']));
        } catch (\Exception $e) {
            error_log("An error occurred in get_hourly_datetimes: " . $e->getMessage());
            return [];
        }
    }

    public function getQueryCost()
    {
        try {
            return $this->weatherData['queryCost'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in get_query_cost: " . $e->getMessage());
            return null;
        }
    }

    public function setQueryCost($value)
    {
        try {
            $this->weatherData['queryCost'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in set_query_cost: " . $e->getMessage());
        }
    }

    public function getLatitude()
    {
        try {
            return $this->weatherData['latitude'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in get_latitude: " . $e->getMessage());
            return null;
        }
    }

    public function setLatitude($value)
    {
        try {
            $this->weatherData['latitude'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in set_latitude: " . $e->getMessage());
        }
    }

    public function getLongitude()
    {
        try {
            return $this->weatherData['longitude'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in get_longitude: " . $e->getMessage());
            return null;
        }
    }

    public function setLongitude($value)
    {
        try {
            $this->weatherData['longitude'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in set_longitude: " . $e->getMessage());
        }
    }

    public function getResolvedAddress()
    {
        try {
            return $this->weatherData['resolvedAddress'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in get_resolved_address: " . $e->getMessage());
            return null;
        }
    }

    public function setResolvedAddress($value)
    {
        try {
            $this->weatherData['resolvedAddress'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in set_resolved_address: " . $e->getMessage());
        }
    }

    public function getAddress()
    {
        try {
            return $this->weatherData['address'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in get_address: " . $e->getMessage());
            return null;
        }
    }

    public function setAddress($value)
    {
        try {
            $this->weatherData['address'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in set_address: " . $e->getMessage());
        }
    }

    public function getTimezone()
    {
        try {
            return $this->weatherData['timezone'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in get_timezone: " . $e->getMessage());
            return null;
        }
    }

    public function setTimezone($value)
    {
        try {
            $this->weatherData['timezone'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in set_timezone: " . $e->getMessage());
        }
    }

    public function getTzoffset()
    {
        try {
            return $this->weatherData['tzoffset'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in get_tzoffset: " . $e->getMessage());
            return null;
        }
    }

    public function setTzoffset($value)
    {
        try {
            $this->weatherData['tzoffset'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in set_tzoffset: " . $e->getMessage());
        }
    }

    public function getStations()
    {
        try {
            return $this->weatherData['stations'] ?? [];
        } catch (\Exception $e) {
            error_log("An error occurred in get_stations: " . $e->getMessage());
            return [];
        }
    }

    public function setStations($value)
    {
        try {
            $this->weatherData['stations'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in set_stations: " . $e->getMessage());
        }
    }

    // --- retrieve or set element on a specific day ---

    public function getDataOnDay($dayInfo, $elements = [])
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $elements ? $this->extractSubdictByKeys($dayData, $elements) : $dayData;
        } catch (\Exception $e) {
            error_log("Error accessing data on this day: " . $e->getMessage());
            return null;
        }
    }

    public function setDataOnDay($dayInfo, $data)
    {
        try {
            $this->setItemByDatetimeVal($this->weatherData['days'], $dayInfo, $data);
        } catch (\Exception $e) {
            throw new \Exception("Error setting data on this day: " . $e->getMessage());
        }
    }

    public function getTempOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['temp'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing temperature data: " . $e->getMessage());
            return null;
        }
    }

    public function setTempOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['temp' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting temperature data: " . $e->getMessage());
        }
    }

    public function getTempMaxOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['tempmax'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing maximum temperature data: " . $e->getMessage());
            return null;
        }
    }

    public function setTempMaxOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['tempmax' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting maximum temperature data: " . $e->getMessage());
        }
    }

    public function getTempMinOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['tempmin'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing minimum temperature data: " . $e->getMessage());
            return null;
        }
    }

    public function setTempMinOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['tempmin' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting minimum temperature data: " . $e->getMessage());
        }
    }

    public function getFeelsLikeOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['feelslike'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing 'feels like' temperature data: " . $e->getMessage());
            return null;
        }
    }

    public function setFeelsLikeOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['feelslike' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting 'feels like' temperature data: " . $e->getMessage());
        }
    }

    public function getFeelsLikeMaxOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['feelslikemax'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing 'feels like max' temperature data: " . $e->getMessage());
            return null;
        }
    }

    public function setFeelsLikeMaxOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['feelslikemax' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting 'feels like max' temperature data: " . $e->getMessage());
        }
    }

    public function getFeelsLikeMinOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['feelslikemin'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing 'feels like min' temperature data: " . $e->getMessage());
            return null;
        }
    }

    public function setFeelsLikeMinOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['feelslikemin' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting 'feels like min' temperature data: " . $e->getMessage());
        }
    }

    public function getDewOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['dew'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing dew point data: " . $e->getMessage());
            return null;
        }
    }

    public function setDewOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['dew' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting dew point data: " . $e->getMessage());
        }
    }

    public function getHumidityOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['humidity'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing humidity data: " . $e->getMessage());
            return null;
        }
    }

    public function setHumidityOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['humidity' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting humidity data: " . $e->getMessage());
        }
    }

    public function getPrecipOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['precip'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing precipitation data: " . $e->getMessage());
            return null;
        }
    }

    public function setPrecipOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['precip' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting precipitation data: " . $e->getMessage());
        }
    }

    public function getPrecipProbOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['precipprob'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing precipitation probability data: " . $e->getMessage());
            return null;
        }
    }

    public function setPrecipProbOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['precipprob' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting precipitation probability data: " . $e->getMessage());
        }
    }

    public function getPrecipCoverOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['precipcover'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing precipitation coverage data: " . $e->getMessage());
            return null;
        }
    }

    public function setPrecipCoverOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['precipcover' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting precipitation coverage data: " . $e->getMessage());
        }
    }

    public function getPrecipTypeOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['preciptype'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing precipitation type data: " . $e->getMessage());
            return null;
        }
    }

    public function setPrecipTypeOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['preciptype' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting precipitation type data: " . $e->getMessage());
        }
    }

    public function getSnowOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['snow'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing snow data: " . $e->getMessage());
            return null;
        }
    }

    public function setSnowOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['snow' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting snow data: " . $e->getMessage());
        }
    }

    public function getSnowDepthOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['snowdepth'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing snow depth data: " . $e->getMessage());
            return null;
        }
    }

    public function setSnowDepthOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['snowdepth' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting snow depth data: " . $e->getMessage());
        }
    }

    public function getWindGustOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['windgust'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing wind gust data: " . $e->getMessage());
            return null;
        }
    }

    public function setWindGustOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['windgust' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting wind gust data: " . $e->getMessage());
        }
    }

    public function getWindSpeedOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['windspeed'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing wind speed data: " . $e->getMessage());
            return null;
        }
    }

    public function setWindSpeedOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['windspeed' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting wind speed data: " . $e->getMessage());
        }
    }

    public function getWindDirOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['winddir'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing wind direction data: " . $e->getMessage());
            return null;
        }
    }

    public function setWindDirOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['winddir' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting wind direction data: " . $e->getMessage());
        }
    }

    public function getPressureOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['pressure'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing pressure data: " . $e->getMessage());
            return null;
        }
    }

    public function setPressureOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['pressure' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting pressure data: " . $e->getMessage());
        }
    }

    public function getCloudCoverOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['cloudcover'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing cloud cover data: " . $e->getMessage());
            return null;
        }
    }

    public function setCloudCoverOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['cloudcover' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting cloud cover data: " . $e->getMessage());
        }
    }

    public function getVisibilityOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['visibility'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing visibility data: " . $e->getMessage());
            return null;
        }
    }

    public function setVisibilityOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['visibility' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting visibility data: " . $e->getMessage());
        }
    }

    public function getSolarRadiationOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['solarradiation'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing solar radiation data: " . $e->getMessage());
            return null;
        }
    }

    public function setSolarRadiationOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['solarradiation' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting solar radiation data: " . $e->getMessage());
        }
    }

    public function getSolarEnergyOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['solarenergy'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing solar energy data: " . $e->getMessage());
            return null;
        }
    }

    public function setSolarEnergyOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['solarenergy' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting solar energy data: " . $e->getMessage());
        }
    }

    public function getUvIndexOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['uvindex'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing UV index data: " . $e->getMessage());
            return null;
        }
    }

    public function setUvIndexOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['uvindex' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting UV index data: " . $e->getMessage());
        }
    }

    public function getSevereRiskOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['severerisk'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing severe risk data: " . $e->getMessage());
            return null;
        }
    }

    public function setSevereRiskOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['severerisk' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting severe risk data: " . $e->getMessage());
        }
    }

    public function getSunriseOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['sunrise'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing sunrise data: " . $e->getMessage());
            return null;
        }
    }

    public function setSunriseOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['sunrise' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting sunrise data: " . $e->getMessage());
        }
    }

    public function getSunriseEpochOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['sunriseEpoch'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing sunrise epoch data: " . $e->getMessage());
            return null;
        }
    }

    public function setSunriseEpochOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['sunriseEpoch' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting sunrise epoch data: " . $e->getMessage());
        }
    }

    public function getSunsetOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['sunset'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing sunset data: " . $e->getMessage());
            return null;
        }
    }

    public function setSunsetOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['sunset' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting sunset data: " . $e->getMessage());
        }
    }

    public function getSunsetEpochOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['sunsetEpoch'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing sunset epoch data: " . $e->getMessage());
            return null;
        }
    }

    public function setSunsetEpochOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['sunsetEpoch' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting sunset epoch data: " . $e->getMessage());
        }
    }

    public function getMoonPhaseOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['moonphase'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing moon phase data: " . $e->getMessage());
            return null;
        }
    }

    public function setMoonPhaseOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['moonphase' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting moon phase data: " . $e->getMessage());
        }
    }

    public function getConditionsOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['conditions'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing conditions data: " . $e->getMessage());
            return null;
        }
    }

    public function setConditionsOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['conditions' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting conditions data: " . $e->getMessage());
        }
    }

    public function getDescriptionOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['description'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing description data: " . $e->getMessage());
            return null;
        }
    }

    public function setDescriptionOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['description' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting description data: " . $e->getMessage());
        }
    }

    public function getIconOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['icon'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing icon data: " . $e->getMessage());
            return null;
        }
    }

    public function setIconOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['icon' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting icon data: " . $e->getMessage());
        }
    }

    public function getStationsOnDay($dayInfo)
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            return $dayData['stations'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing stations data: " . $e->getMessage());
            return null;
        }
    }

    public function setStationsOnDay($dayInfo, $value)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['stations' => $value]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting stations data: " . $e->getMessage());
        }
    }

    public function getHourlyDataOnDay($dayInfo, $elements = [])
    {
        try {
            $dayData = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourlyData = $dayData['hours'] ?? [];

            if ($elements) {
                return array_map(function ($hour) use ($elements) {
                    return array_intersect_key($hour, array_flip($elements));
                }, $hourlyData);
            }

            return $hourlyData;
        } catch (\Exception $e) {
            throw new \Exception("Error retrieving hourly data: " . $e->getMessage());
        }
    }

    public function setHourlyDataOnDay($dayInfo, $data)
    {
        try {
            $this->updateItemByDatetimeVal($this->weatherData['days'], $dayInfo, ['hours' => $data]);
        } catch (\Exception $e) {
            throw new \Exception("Error setting hourly data: " . $e->getMessage());
        }
    }

    // --- retrieve or set element on a specific date and time ---
    // Retrieves weather data for a specific datetime
    public function getDataAtDatetime($dayInfo, $timeInfo, $elements = [])
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $data = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return empty($elements) ? $data : array_intersect_key($data, array_flip($elements));
        } catch (\Exception $e) {
            error_log("Error accessing data at this datetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets weather data for a specific datetime
    public function setDataAtDatetime($dayInfo, $timeInfo, $data)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $this->setItemByDatetimeVal($dayItem['hours'], $timeInfo, $data);
        } catch (\Exception $e) {
            throw new \Exception("Error setting data at this datetime: " . $e->getMessage());
        }
    }

    // Updates weather data for a specific datetime
    public function updateDataAtDatetime($dayInfo, $timeInfo, $data)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $this->updateItemByDatetimeVal($dayItem['hours'], $timeInfo, $data);
        } catch (\Exception $e) {
            throw new \Exception("Error updating data at this datetime: " . $e->getMessage());
        }
    }

    // Retrieves epoch time for a specific datetime
    public function getDatetimeEpochAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['datetimeEpoch'] ?? null;
        } catch (\Exception $e) {
            error_log("Error accessing epoch time at this datetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets epoch time for a specific datetime
    public function setDatetimeEpochAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['datetimeEpoch'] = $value;
        } catch (\Exception $e) {
            throw new \Exception("Error setting epoch time at this datetime: " . $e->getMessage());
        }
    }

    // Retrieves temperature at specific datetime
    public function getTempAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['temp'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getTempAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets temperature at specific datetime
    public function setTempAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['temp'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setTempAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves 'feels like' temperature at specific datetime
    public function getFeelsLikeAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['feelslike'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getFeelsLikeAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets 'feels like' temperature at specific datetime
    public function setFeelsLikeAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['feelslike'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setFeelsLikeAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves humidity at specific datetime
    public function getHumidityAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['humidity'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getHumidityAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets humidity at specific datetime
    public function setHumidityAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['humidity'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setHumidityAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves dew point at specific datetime
    public function getDewAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['dew'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getDewAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets dew point at specific datetime
    public function setDewAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['dew'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setDewAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves precipitation at specific datetime
    public function getPrecipAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['precip'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getPrecipAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets precipitation at specific datetime
    public function setPrecipAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['precip'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setPrecipAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves probability of precipitation at specific datetime
    public function getPrecipProbAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['precipprob'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getPrecipProbAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets probability of precipitation at specific datetime
    public function setPrecipProbAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['precipprob'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setPrecipProbAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves snow amount at specific datetime
    public function getSnowAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['snow'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getSnowAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets snow amount at specific datetime
    public function setSnowAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['snow'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setSnowAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves snow depth at specific datetime
    public function getSnowDepthAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['snowdepth'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getSnowDepthAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets snow depth at specific datetime
    public function setSnowDepthAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['snowdepth'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setSnowDepthAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves precipitation type at specific datetime
    public function getPrecipTypeAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['preciptype'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getPrecipTypeAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets precipitation type at specific datetime
    public function setPrecipTypeAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['preciptype'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setPrecipTypeAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves wind gust speed at specific datetime
    public function getWindGustAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['windgust'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getWindGustAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets wind gust speed at specific datetime
    public function setWindGustAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['windgust'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setWindGustAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves wind speed at specific datetime
    public function getWindSpeedAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['windspeed'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getWindSpeedAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets wind speed at specific datetime
    public function setWindSpeedAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['windspeed'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setWindSpeedAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves wind direction at specific datetime
    public function getWindDirAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['winddir'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getWindDirAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets wind direction at specific datetime
    public function setWindDirAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['winddir'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setWindDirAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves atmospheric pressure at specific datetime
    public function getPressureAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['pressure'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getPressureAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets atmospheric pressure at specific datetime
    public function setPressureAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['pressure'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setPressureAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves visibility at specific datetime
    public function getVisibilityAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['visibility'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getVisibilityAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets visibility at specific datetime
    public function setVisibilityAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['visibility'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setVisibilityAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves cloud cover at specific datetime
    public function getCloudCoverAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['cloudcover'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getCloudCoverAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets cloud cover at specific datetime
    public function setCloudCoverAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['cloudcover'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setCloudCoverAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves solar radiation at specific datetime
    public function getSolarRadiationAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['solarradiation'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getSolarRadiationAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets solar radiation at specific datetime
    public function setSolarRadiationAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['solarradiation'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setSolarRadiationAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves solar energy at specific datetime
    public function getSolarEnergyAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['solarenergy'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getSolarEnergyAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets solar energy at specific datetime
    public function setSolarEnergyAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['solarenergy'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setSolarEnergyAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves UV index at specific datetime
    public function getUvIndexAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['uvindex'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getUvIndexAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets UV index at specific datetime
    public function setUvIndexAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['uvindex'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setUvIndexAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves severe risk at specific datetime
    public function getSevereRiskAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['severerisk'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getSevereRiskAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets severe risk at specific datetime
    public function setSevereRiskAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['severerisk'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setSevereRiskAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves conditions at specific datetime
    public function getConditionsAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['conditions'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getConditionsAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets conditions at specific datetime
    public function setConditionsAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['conditions'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setConditionsAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves weather icon at specific datetime
    public function getIconAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['icon'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getIconAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets weather icon at specific datetime
    public function setIconAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['icon'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setIconAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves weather stations at specific datetime
    public function getStationsAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['stations'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getStationsAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets weather stations at specific datetime
    public function setStationsAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['stations'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setStationsAtDatetime: " . $e->getMessage());
        }
    }

    // Retrieves data source at specific datetime
    public function getSourceAtDatetime($dayInfo, $timeInfo)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            return $hourItem['source'] ?? null;
        } catch (\Exception $e) {
            error_log("An error occurred in getSourceAtDatetime: " . $e->getMessage());
            return null;
        }
    }

    // Sets data source at specific datetime
    public function setSourceAtDatetime($dayInfo, $timeInfo, $value)
    {
        try {
            $dayItem = $this->filterItemByDatetimeVal($this->weatherData['days'], $dayInfo);
            $hourItem = $this->filterItemByDatetimeVal($dayItem['hours'], $timeInfo);
            $hourItem['source'] = $value;
        } catch (\Exception $e) {
            error_log("An error occurred in setSourceAtDatetime: " . $e->getMessage());
        }
    }

    // --- Clears the weather data
    public function clearWeatherData()
    {
        $this->weatherData = [];
    }


    // --- private methods for internal use
    private function filterItemByDatetimeVal($src, $datetimeVal)
    {
        if ($src === null) {
            throw new \Exception('Source is nil');
        }

        try {
            if (is_string($datetimeVal)) {
                foreach ($src as $item) {
                    if ($item[self::DATETIME] === $datetimeVal) {
                        return $item;
                    }
                }
            } elseif (is_int($datetimeVal)) {
                if (array_key_exists($datetimeVal, $src)) {
                    return $src[$datetimeVal];
                }
            } else {
                throw new \InvalidArgumentException("Invalid input datetime value for filterItemByDatetimeVal with str or int: {$datetimeVal}");
            }
        } catch (\Exception $e) {
            error_log("An error occurred in filterItemByDatetimeVal: " . $e->getMessage());
            return null;
        }
    }

    private function setItemByDatetimeVal($src, $datetimeVal, $data)
    {
        if ($src === null) {
            throw new \Exception('Source is nil');
        }

        if (!is_array($data)) {
            throw new \InvalidArgumentException("Invalid input data value for setItemByDatetimeVal with hash: " . json_encode($data));
        }

        try {
            if (is_string($datetimeVal)) {
                foreach ($src as &$item) {
                    if ($item[self::DATETIME] === $datetimeVal) {
                        $data[self::DATETIME] = $datetimeVal; // Ensure datetime is not changed
                        $item = $data;
                        break;
                    }
                }
            } elseif (is_int($datetimeVal)) {
                if (array_key_exists($datetimeVal, $src)) {
                    $data[self::DATETIME] = $src[$datetimeVal][self::DATETIME]; // Ensure datetime is not changed
                    $src[$datetimeVal] = $data;
                }
            } else {
                throw new \InvalidArgumentException("Invalid input datetime value for setItemByDatetimeVal with str or int: {$datetimeVal}");
            }
        } catch (\Exception $e) {
            error_log("An error occurred in setItemByDatetimeVal: " . $e->getMessage());
        }
    }

    private function updateItemByDatetimeVal($src, $datetimeVal, $data)
    {
        if ($src === null) {
            throw new \Exception('Source is nil');
        }

        if (!is_array($data)) {
            throw new \InvalidArgumentException("Invalid input data value for updateItemByDatetimeVal with hash: " . json_encode($data));
        }

        try {
            if (is_string($datetimeVal)) {
                foreach ($src as &$item) {
                    if ($item[self::DATETIME] === $datetimeVal) {
                        $item = array_merge($item, $data);
                        $item[self::DATETIME] = $datetimeVal; // Ensure datetime is not changed
                        break;
                    }
                }
            } elseif (is_int($datetimeVal)) {
                if (array_key_exists($datetimeVal, $src)) {
                    $data[self::DATETIME] = $src[$datetimeVal][self::DATETIME]; // Ensure datetime is not changed
                    $src[$datetimeVal] = array_merge($src[$datetimeVal], $data);
                }
            } else {
                throw new \InvalidArgumentException("Invalid input datetime value for updateItemByDatetimeVal with str or int: {$datetimeVal}");
            }
        } catch (\Exception $e) {
            error_log("An error occurred in updateItemByDatetimeVal: " . $e->getMessage());
        }
    }
}

?>
