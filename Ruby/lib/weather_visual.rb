# frozen_string_literal: true

require 'httparty'
require 'json'
require 'date'
require 'uri'

# WeatherVisual module for fetching and processing weather data
module WeatherVisual
  BASE_URL = 'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline'
  DATETIME = 'datetime'

  # WeatherData class for interacting with the Weather Visual API
  class WeatherData
    attr_accessor :api_key, :weather_data

    # Initializes the WeatherData object with the given API key
    #
    # @param api_key [String] The API key for accessing the Weather Visual API
    def initialize(api_key)
      @api_key = api_key
      @weather_data = {}
    end

    # Fetches weather data for a specific location and date range
    #
    # @param location [String] The location to fetch weather data for
    # @param from_date [String] The start date for the weather data (format: YYYY-MM-DD)
    # @param to_date [String] The end date for the weather data (format: YYYY-MM-DD)
    # @param unit_group [String] The unit group (default: 'us')
    # @param include [String] Additional data to include (e.g., 'days,hours')
    # @param elements [Array<String>] Specific elements to fetch (e.g., ['temp', 'humidity'])
    # @return [Hash] The fetched weather data
    def fetch_weather_data(location, from_date, to_date, unit_group = 'us', include = 'days', elements = [])
      location_encoded = URI.encode_www_form_component(location)
      url = "#{BASE_URL}/#{location_encoded}/#{from_date}/#{to_date}?unitGroup=#{unit_group}&include=#{include}&key=#{@api_key}&elements=#{elements.join(',')}"
      response = HTTParty.get(url)

      if response.code == 200
        @weather_data = JSON.parse(response.body)
      else
        raise "Failed to fetch weather data: #{response.message}"
      end

      @weather_data
    end

    # Retrieves specific weather data elements
    #
    # @param elements [Array<String>] The elements to retrieve
    # @return [Hash] The retrieved weather data elements
    def get_weather_data(elements = [])
      return @weather_data if elements.empty?

      extract_subdict_by_keys(@weather_data, elements)
    end

    # Sets the weather data
    #
    # @param data [Hash] The weather data to set
    def set_weather_data(data)
      @weather_data = data
    end

    # Retrieves daily weather data
    #
    # @param elements [Array<String>] The elements to retrieve
    # @return [Array<Hash>] The retrieved daily weather data
    def get_weather_daily_data(elements = [])
      return @weather_data['days'] if elements.empty?

      @weather_data['days'].map { |day| extract_subdict_by_keys(day, elements) }
    end

    # Sets the daily weather data
    #
    # @param daily_data [Array<Hash>] The daily weather data to set
    def set_weather_daily_data(daily_data)
      @weather_data['days'] = daily_data
    end

    # Retrieves hourly weather data
    #
    # @param elements [Array<String>] The elements to retrieve
    # @return [Array<Hash>] The retrieved hourly weather data
    def get_weather_hourly_data(elements = [])
      hourly_data = @weather_data['days'].flat_map { |day| day['hours'] || [] }
      return hourly_data if elements.empty?

      hourly_data.map { |hour| extract_subdict_by_keys(hour, elements) }
    end

    # Extracts a sub-dictionary by specified keys
    #
    # @param data [Hash] The original data
    # @param keys [Array<String>] The keys to extract
    # @return [Hash] The extracted sub-dictionary
    def extract_subdict_by_keys(data, keys)
      data.select { |key, _value| keys.include?(key) }
    end

    # Retrieves a list of Date objects representing each day's date from the weather data
    #
    # @return [Array<Date>] A list of Date objects parsed from the 'datetime' key of each day in the weather data
    def get_daily_datetimes
      @weather_data['days'].map { |day| Date.strptime(day['datetime'], '%Y-%m-%d') }
    rescue StandardError => e
      warn "An error occurred in get_daily_datetimes: #{e.message}"
      []
    end

    # Retrieves a list of DateTime objects representing each hour's datetime from the weather data
    #
    # The method combines the 'datetime' from each day with the 'datetime' from each hour within that day
    #
    # @return [Array<DateTime>] A list of DateTime objects parsed from the 'datetime' keys of each day and hour in the weather data
    def get_hourly_datetimes
      @weather_data['days'].flat_map do |day|
        day['hours'].map do |hour|
          DateTime.strptime("#{day['datetime']} #{hour['datetime']}", '%Y-%m-%d %H:%M:%S')
        end
      end
    rescue StandardError => e
      warn "An error occurred in get_hourly_datetimes: #{e.message}"
      []
    end

    # Retrieves the cost of the query from the weather data
    #
    # @return [Float, nil] The cost of the query if available, otherwise nil
    def get_query_cost
      @weather_data['queryCost']
    rescue StandardError => e
      warn "An error occurred in get_query_cost: #{e.message}"
      nil
    end

    # Sets the cost of the query in the weather data
    #
    # @param value [Float] The new cost to be set for the query
    def set_query_cost(value)
      @weather_data['queryCost'] = value
    rescue StandardError => e
      warn "An error occurred in set_query_cost: #{e.message}"
    end

    # Retrieves the latitude from the weather data
    #
    # @return [Float, nil] The latitude if available, otherwise nil
    def get_latitude
      @weather_data['latitude']
    rescue StandardError => e
      warn "An error occurred in get_latitude: #{e.message}"
      nil
    end

    # Sets the latitude in the weather data
    #
    # @param value [Float] The new latitude to be set
    def set_latitude(value)
      @weather_data['latitude'] = value
    rescue StandardError => e
      warn "An error occurred in set_latitude: #{e.message}"
    end

    # Retrieves the longitude from the weather data
    #
    # @return [Float, nil] The longitude if available, otherwise nil
    def get_longitude
      @weather_data['longitude']
    rescue StandardError => e
      warn "An error occurred in get_longitude: #{e.message}"
      nil
    end

    # Sets the longitude in the weather data
    #
    # @param value [Float] The new longitude to be set
    def set_longitude(value)
      @weather_data['longitude'] = value
    rescue StandardError => e
      warn "An error occurred in set_longitude: #{e.message}"
    end

    # Retrieves the resolved address from the weather data
    #
    # @return [String, nil] The resolved address if available, otherwise nil
    def get_resolved_address
      @weather_data['resolvedAddress']
    rescue StandardError => e
      warn "An error occurred in get_resolved_address: #{e.message}"
      nil
    end

    # Sets the resolved address in the weather data
    #
    # @param value [String] The new resolved address to be set
    def set_resolved_address(value)
      @weather_data['resolvedAddress'] = value
    rescue StandardError => e
      warn "An error occurred in set_resolved_address: #{e.message}"
    end

    # Retrieves the address from the weather data
    #
    # @return [String, nil] The address if available, otherwise nil
    def get_address
      @weather_data['address']
    rescue StandardError => e
      warn "An error occurred in get_address: #{e.message}"
      nil
    end

    # Sets the address in the weather data
    #
    # @param value [String] The new address to be set
    def set_address(value)
      @weather_data['address'] = value
    rescue StandardError => e
      warn "An error occurred in set_address: #{e.message}"
    end

    # Retrieves the timezone from the weather data
    #
    # @return [String, nil] The timezone if available, otherwise nil
    def get_timezone
      @weather_data['timezone']
    rescue StandardError => e
      warn "An error occurred in get_timezone: #{e.message}"
      nil
    end

    # Sets the timezone in the weather data
    #
    # @param value [String] The new timezone to be set
    def set_timezone(value)
      @weather_data['timezone'] = value
    rescue StandardError => e
      warn "An error occurred in set_timezone: #{e.message}"
    end

    # Retrieves the timezone offset from the weather data
    #
    # @return [Float, nil] The timezone offset if available, otherwise nil
    def get_tzoffset
      @weather_data['tzoffset']
    rescue StandardError => e
      warn "An error occurred in get_tzoffset: #{e.message}"
      nil
    end

    # Sets the timezone offset in the weather data
    #
    # @param value [Float] The new timezone offset to be set
    def set_tzoffset(value)
      @weather_data['tzoffset'] = value
    rescue StandardError => e
      warn "An error occurred in set_tzoffset: #{e.message}"
    end

    # Retrieves the list of weather stations from the weather data
    #
    # @return [Array] The list of weather stations if available, otherwise an empty array
    def get_stations
      @weather_data['stations'] || []
    rescue StandardError => e
      warn "An error occurred in get_stations: #{e.message}"
      []
    end

    # Sets the list of weather stations in the weather data
    #
    # @param value [Array] The new list of weather stations to be set
    def set_stations(value)
      @weather_data['stations'] = value
    rescue StandardError => e
      warn "An error occurred in set_stations: #{e.message}"
    end

    # ------ retrieve or set element(s) on a specific day ------

    # Retrieves weather data for a specific day based on a date string or index
    #
    # @param day_info [String, Integer] The identifier for the day, which can be a date string (YYYY-MM-DD) or an index of the day list
    # @param elements [Array<String>] Specific weather elements to retrieve
    # @return [Hash, nil] The weather data hash for the specified day or nil if not found
    # @raise [ArgumentError] If the input day_info is neither a string nor an integer
    # @raise [IndexError] If the integer index is out of the range of the days list
    def get_data_on_day(day_info, elements = [])
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      if day_data
        elements.empty? ? day_data : extract_subdict_by_keys(day_data, elements)
      end
    rescue StandardError => e
      warn "Error accessing data on this day: #{e.message}"
      nil
    end

    # Sets weather data for a specific day based on a date string or index
    #
    # @param day_info [String, Integer] The identifier for the day, which can be a date string (YYYY-MM-DD) or an index of the day list
    # @param data [Hash] The new weather data hash to replace the existing day's data
    # @raise [ArgumentError] If the input day_info is neither a string nor an integer, or if data is not a hash
    # @raise [IndexError] If the integer index is out of the range of the days list
    def set_data_on_day(day_info, data)
      set_item_by_datetime_val(@weather_data['days'], day_info, data)
    rescue StandardError => e
      raise "Error setting data on this day: #{e.message}"
    end

    # Retrieves the temperature for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The temperature for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_temp_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('temp')
    rescue StandardError => e
      warn "Error accessing temperature data: #{e.message}"
      nil
    end

    # Sets the temperature for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new temperature value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_temp_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'temp' => value })
    rescue StandardError => e
      raise "Error setting temperature data: #{e.message}"
    end

    # Retrieves the maximum temperature for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The maximum temperature for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_tempmax_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('tempmax')
    rescue StandardError => e
      warn "Error accessing maximum temperature data: #{e.message}"
      nil
    end

    # Sets the maximum temperature for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new maximum temperature value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_tempmax_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'tempmax' => value })
    rescue StandardError => e
      raise "Error setting maximum temperature data: #{e.message}"
    end

    # Retrieves the minimum temperature for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The minimum temperature for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_tempmin_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('tempmin')
    rescue StandardError => e
      warn "Error accessing minimum temperature data: #{e.message}"
      nil
    end

    # Sets the minimum temperature for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new minimum temperature value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_tempmin_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'tempmin' => value })
    rescue StandardError => e
      raise "Error setting minimum temperature data: #{e.message}"
    end

    # Retrieves the 'feels like' temperature for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The 'feels like' temperature for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_feelslike_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('feelslike')
    rescue StandardError => e
      warn "Error accessing 'feels like' temperature data: #{e.message}"
      nil
    end

    # Sets the 'feels like' temperature for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new 'feels like' temperature value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_feelslike_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'feelslike' => value })
    rescue StandardError => e
      raise "Error setting 'feels like' temperature data: #{e.message}"
    end

    # Retrieves the maximum 'feels like' temperature for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The maximum 'feels like' temperature for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_feelslikemax_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('feelslikemax')
    rescue StandardError => e
      warn "Error accessing 'feels like max' temperature data: #{e.message}"
      nil
    end

    # Sets the maximum 'feels like' temperature for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new maximum 'feels like' temperature value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_feelslikemax_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'feelslikemax' => value })
    rescue StandardError => e
      raise "Error setting 'feels like max' temperature data: #{e.message}"
    end

    # Retrieves the minimum 'feels like' temperature for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The minimum 'feels like' temperature for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_feelslikemin_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('feelslikemin')
    rescue StandardError => e
      warn "Error accessing 'feels like min' temperature data: #{e.message}"
      nil
    end

    # Sets the minimum 'feels like' temperature for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new minimum temperature value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_feelslikemin_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'feelslikemin' => value })
    rescue StandardError => e
      raise "Error setting 'feels like min' temperature data: #{e.message}"
    end

    # Retrieves dew point for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The dew point for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_dew_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('dew')
    rescue StandardError => e
      warn "Error accessing dew point data: #{e.message}"
      nil
    end

    # Sets dew point for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new dew point value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_dew_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'dew' => value })
    rescue StandardError => e
      raise "Error setting dew point data: #{e.message}"
    end

    # Retrieves humidity percentage for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The humidity percentage for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_humidity_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('humidity')
    rescue StandardError => e
      warn "Error accessing humidity data: #{e.message}"
      nil
    end

    # Sets humidity percentage for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new humidity percentage value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_humidity_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'humidity' => value })
    rescue StandardError => e
      raise "Error setting humidity data: #{e.message}"
    end

    # Retrieves precipitation amount for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The precipitation amount for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_precip_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('precip')
    rescue StandardError => e
      warn "Error accessing precipitation data: #{e.message}"
      nil
    end

    # Sets precipitation amount for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new precipitation amount value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_precip_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'precip' => value })
    rescue StandardError => e
      raise "Error setting precipitation data: #{e.message}"
    end

    # Retrieves probability of precipitation for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The probability of precipitation for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_precipprob_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('precipprob')
    rescue StandardError => e
      warn "Error accessing precipitation probability data: #{e.message}"
      nil
    end

    # Sets probability of precipitation for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new probability of precipitation value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_precipprob_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'precipprob' => value })
    rescue StandardError => e
      raise "Error setting precipitation probability data: #{e.message}"
    end

    # Retrieves precipitation coverage for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The precipitation coverage for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_precipcover_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('precipcover')
    rescue StandardError => e
      warn "Error accessing precipitation coverage data: #{e.message}"
      nil
    end

    # Sets precipitation coverage for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new precipitation coverage value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_precipcover_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'precipcover' => value })
    rescue StandardError => e
      raise "Error setting precipitation coverage data: #{e.message}"
    end

    # Retrieves precipitation type for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [String, nil] The type of precipitation for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_preciptype_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('preciptype')
    rescue StandardError => e
      warn "Error accessing precipitation type data: #{e.message}"
      nil
    end

    # Sets precipitation type for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [String] The new precipitation type to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_preciptype_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'preciptype' => value })
    rescue StandardError => e
      raise "Error setting precipitation type data: #{e.message}"
    end

    # Retrieves snowfall amount for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The snowfall amount for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_snow_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('snow')
    rescue StandardError => e
      warn "Error accessing snow data: #{e.message}"
      nil
    end

    # Sets snowfall amount for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new snowfall amount to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_snow_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'snow' => value })
    rescue StandardError => e
      raise "Error setting snow data: #{e.message}"
    end

    # Retrieves snow depth for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The snow depth for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_snowdepth_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('snowdepth')
    rescue StandardError => e
      warn "Error accessing snow depth data: #{e.message}"
      nil
    end

    # Sets snow depth for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new snow depth to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_snowdepth_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'snowdepth' => value })
    rescue StandardError => e
      raise "Error setting snow depth data: #{e.message}"
    end

    # Retrieves wind gust value for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The wind gust value for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_windgust_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('windgust')
    rescue StandardError => e
      warn "Error accessing wind gust data: #{e.message}"
      nil
    end

    # Sets wind gust value for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new wind gust value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_windgust_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'windgust' => value })
    rescue StandardError => e
      raise "Error setting wind gust data: #{e.message}"
    end

    # Retrieves wind speed for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The wind speed for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_windspeed_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('windspeed')
    rescue StandardError => e
      warn "Error accessing wind speed data: #{e.message}"
      nil
    end

    # Sets wind speed for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new wind speed value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_windspeed_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'windspeed' => value })
    rescue StandardError => e
      raise "Error setting wind speed data: #{e.message}"
    end

    # Retrieves wind direction for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The wind direction for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_winddir_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('winddir')
    rescue StandardError => e
      warn "Error accessing wind direction data: #{e.message}"
      nil
    end

    # Sets wind direction for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new wind direction value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_winddir_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'winddir' => value })
    rescue StandardError => e
      raise "Error setting wind direction data: #{e.message}"
    end

    # Retrieves atmospheric pressure for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The atmospheric pressure for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_pressure_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('pressure')
    rescue StandardError => e
      warn "Error accessing pressure data: #{e.message}"
      nil
    end

    # Sets atmospheric pressure for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new pressure value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_pressure_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'pressure' => value })
    rescue StandardError => e
      raise "Error setting pressure data: #{e.message}"
    end

    # Retrieves cloud cover percentage for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The cloud cover percentage for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_cloudcover_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('cloudcover')
    rescue StandardError => e
      warn "Error accessing cloud cover data: #{e.message}"
      nil
    end

    # Sets cloud cover percentage for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new cloud cover percentage value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_cloudcover_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'cloudcover' => value })
    rescue StandardError => e
      raise "Error setting cloud cover data: #{e.message}"
    end

    # Retrieves visibility distance for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The visibility distance for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_visibility_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('visibility')
    rescue StandardError => e
      warn "Error accessing visibility data: #{e.message}"
      nil
    end

    # Sets visibility distance for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new visibility distance value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_visibility_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'visibility' => value })
    rescue StandardError => e
      raise "Error setting visibility data: #{e.message}"
    end

    # Retrieves solar radiation level for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The solar radiation level for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_solarradiation_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('solarradiation')
    rescue StandardError => e
      warn "Error accessing solar radiation data: #{e.message}"
      nil
    end

    # Sets solar radiation level for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new solar radiation level to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_solarradiation_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'solarradiation' => value })
    rescue StandardError => e
      raise "Error setting solar radiation data: #{e.message}"
    end

    # Retrieves solar energy generated for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The solar energy generated on the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_solarenergy_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('solarenergy')
    rescue StandardError => e
      warn "Error accessing solar energy data: #{e.message}"
      nil
    end

    # Sets solar energy generated for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new solar energy generated value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_solarenergy_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'solarenergy' => value })
    rescue StandardError => e
      raise "Error setting solar energy data: #{e.message}"
    end

    # Retrieves UV index for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The UV index for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_uvindex_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('uvindex')
    rescue StandardError => e
      warn "Error accessing UV index data: #{e.message}"
      nil
    end

    # Sets UV index for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new UV index value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_uvindex_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'uvindex' => value })
    rescue StandardError => e
      raise "Error setting UV index data: #{e.message}"
    end

    # Retrieves severe weather risk level for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The severe weather risk level for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_severerisk_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('severerisk')
    rescue StandardError => e
      warn "Error accessing severe risk data: #{e.message}"
      nil
    end

    # Sets severe weather risk level for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new severe weather risk level to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_severerisk_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'severerisk' => value })
    rescue StandardError => e
      raise "Error setting severe risk data: #{e.message}"
    end

    # Retrieves sunrise time for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [String, nil] The sunrise time for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_sunrise_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('sunrise')
    rescue StandardError => e
      warn "Error accessing sunrise data: #{e.message}"
      nil
    end

    # Sets sunrise time for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [String] The new sunrise time value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_sunrise_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'sunrise' => value })
    rescue StandardError => e
      raise "Error setting sunrise data: #{e.message}"
    end

    # Retrieves Unix timestamp for the sunrise time for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Integer, nil] The sunrise Unix timestamp for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_sunriseEpoch_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('sunriseEpoch')
    rescue StandardError => e
      warn "Error accessing sunrise epoch data: #{e.message}"
      nil
    end

    # Sets Unix timestamp for the sunrise time for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Integer] The new sunrise Unix timestamp value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_sunriseEpoch_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'sunriseEpoch' => value })
    rescue StandardError => e
      raise "Error setting sunrise epoch data: #{e.message}"
    end

    # Retrieves sunset time for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [String, nil] The sunset time for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_sunset_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('sunset')
    rescue StandardError => e
      warn "Error accessing sunset data: #{e.message}"
      nil
    end

    # Sets sunset time for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [String] The new sunset time value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_sunset_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'sunset' => value })
    rescue StandardError => e
      raise "Error setting sunset data: #{e.message}"
    end

    # Retrieves Unix timestamp for the sunset time for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Integer, nil] The sunset Unix timestamp for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_sunsetEpoch_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('sunsetEpoch')
    rescue StandardError => e
      warn "Error accessing sunset epoch data: #{e.message}"
      nil
    end

    # Sets Unix timestamp for the sunset time for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Integer] The new sunset Unix timestamp value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_sunsetEpoch_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'sunsetEpoch' => value })
    rescue StandardError => e
      raise "Error setting sunset epoch data: #{e.message}"
    end

    # Retrieves moon phase for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Float, nil] The moon phase for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_moonphase_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('moonphase')
    rescue StandardError => e
      warn "Error accessing moon phase data: #{e.message}"
      nil
    end

    # Sets moon phase for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Float] The new moon phase value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_moonphase_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'moonphase' => value })
    rescue StandardError => e
      raise "Error setting moon phase data: #{e.message}"
    end

    # Retrieves weather conditions for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [String, nil] The weather conditions for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_conditions_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('conditions')
    rescue StandardError => e
      warn "Error accessing conditions data: #{e.message}"
      nil
    end

    # Sets weather conditions for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [String] The new conditions value to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_conditions_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'conditions' => value })
    rescue StandardError => e
      raise "Error setting conditions data: #{e.message}"
    end

    # Retrieves weather description for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [String, nil] The weather description for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_description_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('description')
    rescue StandardError => e
      warn "Error accessing description data: #{e.message}"
      nil
    end

    # Sets weather description for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [String] The new description to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_description_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'description' => value })
    rescue StandardError => e
      raise "Error setting description data: #{e.message}"
    end

    # Retrieves weather icon for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [String, nil] The weather icon for the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_icon_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('icon')
    rescue StandardError => e
      warn "Error accessing icon data: #{e.message}"
      nil
    end

    # Sets weather icon for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [String] The new icon to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_icon_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'icon' => value })
    rescue StandardError => e
      raise "Error setting icon data: #{e.message}"
    end

    # Retrieves weather stations data for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @return [Array, nil] The list of weather stations active on the specified day or nil if not found
    # @raise [ArgumentError] If the input is not a string or integer
    def get_stations_on_day(day_info)
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      day_data&.dig('stations')
    rescue StandardError => e
      warn "Error accessing stations data: #{e.message}"
      nil
    end

    # Sets weather stations data for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param value [Array] The new list of weather stations to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_stations_on_day(day_info, value)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'stations' => value })
    rescue StandardError => e
      raise "Error setting stations data: #{e.message}"
    end

    # Retrieves hourly weather data for a specific day identified by date or index. Optionally filters the data
    # to include only specified elements.
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param elements [Array] Optional list of keys to filter the hourly data
    # @return [Array] A list of hourly data dictionaries for the specified day. If elements are specified,
    #                 returns a list of dictionaries containing only the specified keys.
    # @raise [ArgumentError] If the input is not a string or integer
    def get_hourlyData_on_day(day_info, elements = [])
      day_data = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hourly_data = day_data&.dig('hours') || []

      if elements.any?
        hourly_data.map { |hour| hour.slice(*elements) }
      else
        hourly_data
      end
    rescue StandardError => e
      raise "Error retrieving hourly data: #{e.message}"
    end

    # Sets hourly weather data for a specific day identified by date or index
    #
    # @param day_info [String, Integer] The day's date as a string ('YYYY-MM-DD') or index as an integer
    # @param data [Array] The new list of hourly weather data dictionaries to set
    # @raise [ArgumentError] If the input is not a string or integer
    def set_hourlyData_on_day(day_info, data)
      update_item_by_datetime_val(@weather_data['days'], day_info, { 'hours' => data })
    rescue StandardError => e
      raise "Error setting hourly data: #{e.message}"
    end

    # ------ retrieve or set element(s) on a specific day ------

    # Retrieves weather data for a specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param elements [Array] Specific weather elements to retrieve
    # @return [Hash, nil] The weather data hash for the specified datetime or nil if not found
    # @raise [ArgumentError] If the input day_info or time_info is neither a string nor an integer
    def get_data_at_datetime(day_info, time_info, elements = [])
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      data = filter_item_by_datetime_val(day_item['hours'], time_info)
      if data
        elements.empty? ? data : data.slice(*elements)
      end
    rescue StandardError => e
      warn "Error accessing data at this datetime: #{e.message}"
      nil
    end

    # Sets weather data for a specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param data [Hash] The new weather data hash to replace the existing data for the specified datetime
    # @raise [ArgumentError] If the input day_info or time_info is neither a string nor an integer, or if data is not a hash
    def set_data_at_datetime(day_info, time_info, data)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      set_item_by_datetime_val(day_item['hours'], time_info, data)
    rescue StandardError => e
      raise "Error setting data at this datetime: #{e.message}"
    end

    # Updates weather data for a specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param data [Hash] The weather data hash to update for the specified datetime
    # @raise [ArgumentError] If the input day_info or time_info is neither a string nor an integer, or if data is not a hash
    def update_data_at_datetime(day_info, time_info, data)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      update_item_by_datetime_val(day_item['hours'], time_info, data)
    rescue StandardError => e
      raise "Error updating data at this datetime: #{e.message}"
    end

    # Retrieves epoch time for a specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Integer, nil] The epoch time at the specified datetime or nil if not found
    # @raise [ArgumentError] If the input day_info or time_info is neither a string nor an integer
    def get_datetimeEpoch_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item&.dig('datetimeEpoch')
    rescue StandardError => e
      warn "Error accessing epoch time at this datetime: #{e.message}"
      nil
    end

    # Sets epoch time for a specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Integer] The new epoch time value to set
    # @raise [ArgumentError] If the input day_info or time_info is neither a string nor an integer
    def set_datetimeEpoch_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['datetimeEpoch'] = value
    rescue StandardError => e
      raise "Error setting epoch time at this datetime: #{e.message}"
    end

    # Retrieves temperature at specific datetime
    #
    # @param day_info [Integer] The day index
    # @param time_info [Integer] The hour index
    # @return [Float] The temperature
    def get_temp_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['temp']
    rescue StandardError => e
      warn "An error occurred in get_temp_at_datetime: #{e.message}"
      nil
    end

    # Sets temperature at specific datetime
    #
    # @param day_info [Integer] The day index
    # @param time_info [Integer] The hour index
    # @param value [Float] The temperature value to set
    def set_temp_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['temp'] = value
    rescue StandardError => e
      warn "An error occurred in set_temp_at_datetime: #{e.message}"
    end

        # Retrieves 'feels like' temperature at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The 'feels like' temperature or nil if not found
    def get_feelslike_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['feelslike']
    rescue StandardError => e
      warn "An error occurred in get_feelslike_at_datetime: #{e.message}"
      nil
    end

    # Sets 'feels like' temperature at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The 'feels like' temperature value to set
    def set_feelslike_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['feelslike'] = value
    rescue StandardError => e
      warn "An error occurred in set_feelslike_at_datetime: #{e.message}"
    end

    # Retrieves humidity at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The humidity or nil if not found
    def get_humidity_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['humidity']
    rescue StandardError => e
      warn "An error occurred in get_humidity_at_datetime: #{e.message}"
      nil
    end

    # Sets humidity at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The humidity value to set
    def set_humidity_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['humidity'] = value
    rescue StandardError => e
      warn "An error occurred in set_humidity_at_datetime: #{e.message}"
    end

    # Retrieves dew point at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The dew point or nil if not found
    def get_dew_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['dew']
    rescue StandardError => e
      warn "An error occurred in get_dew_at_datetime: #{e.message}"
      nil
    end

    # Sets dew point at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The dew point value to set
    def set_dew_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['dew'] = value
    rescue StandardError => e
      warn "An error occurred in set_dew_at_datetime: #{e.message}"
    end

    # Retrieves precipitation at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The precipitation or nil if not found
    def get_precip_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['precip']
    rescue StandardError => e
      warn "An error occurred in get_precip_at_datetime: #{e.message}"
      nil
    end

    # Sets precipitation at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The precipitation value to set
    def set_precip_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['precip'] = value
    rescue StandardError => e
      warn "An error occurred in set_precip_at_datetime: #{e.message}"
    end

    # Retrieves probability of precipitation at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The probability of precipitation or nil if not found
    def get_precipprob_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['precipprob']
    rescue StandardError => e
      warn "An error occurred in get_precipprob_at_datetime: #{e.message}"
      nil
    end

    # Sets probability of precipitation at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The probability of precipitation value to set
    def set_precipprob_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['precipprob'] = value
    rescue StandardError => e
      warn "An error occurred in set_precipprob_at_datetime: #{e.message}"
    end

    # Retrieves snow amount at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The snow amount or nil if not found
    def get_snow_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['snow']
    rescue StandardError => e
      warn "An error occurred in get_snow_at_datetime: #{e.message}"
      nil
    end

    # Sets snow amount at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The snow amount value to set
    def set_snow_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['snow'] = value
    rescue StandardError => e
      warn "An error occurred in set_snow_at_datetime: #{e.message}"
    end

    # Retrieves snow depth at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The snow depth or nil if not found
    def get_snowdepth_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['snowdepth']
    rescue StandardError => e
      warn "An error occurred in get_snowdepth_at_datetime: #{e.message}"
      nil
    end

    # Sets snow depth at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The snow depth value to set
    def set_snowdepth_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['snowdepth'] = value
    rescue StandardError => e
      warn "An error occurred in set_snowdepth_at_datetime: #{e.message}"
    end

    # Retrieves precipitation type at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [String, nil] The precipitation type or nil if not found
    def get_preciptype_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['preciptype']
    rescue StandardError => e
      warn "An error occurred in get_preciptype_at_datetime: #{e.message}"
      nil
    end

    # Sets precipitation type at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [String] The precipitation type value to set
    def set_preciptype_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['preciptype'] = value
    rescue StandardError => e
      warn "An error occurred in set_preciptype_at_datetime: #{e.message}"
    end

    # Retrieves wind gust speed at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The wind gust speed or nil if not found
    def get_windgust_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['windgust']
    rescue StandardError => e
      warn "An error occurred in get_windgust_at_datetime: #{e.message}"
      nil
    end

    # Sets wind gust speed at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The wind gust speed value to set
    def set_windgust_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['windgust'] = value
    rescue StandardError => e
      warn "An error occurred in set_windgust_at_datetime: #{e.message}"
    end

    # Retrieves wind speed at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The wind speed or nil if not found
    def get_windspeed_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['windspeed']
    rescue StandardError => e
      warn "An error occurred in get_windspeed_at_datetime: #{e.message}"
      nil
    end

    # Sets wind speed at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The wind speed value to set
    def set_windspeed_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['windspeed'] = value
    rescue StandardError => e
      warn "An error occurred in set_windspeed_at_datetime: #{e.message}"
    end

    # Retrieves wind direction at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The wind direction or nil if not found
    def get_winddir_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['winddir']
    rescue StandardError => e
      warn "An error occurred in get_winddir_at_datetime: #{e.message}"
      nil
    end

    # Sets wind direction at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The wind direction value to set
    def set_winddir_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['winddir'] = value
    rescue StandardError => e
      warn "An error occurred in set_winddir_at_datetime: #{e.message}"
    end

    # Retrieves atmospheric pressure at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The atmospheric pressure or nil if not found
    def get_pressure_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['pressure']
    rescue StandardError => e
      warn "An error occurred in get_pressure_at_datetime: #{e.message}"
      nil
    end

    # Sets atmospheric pressure at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The atmospheric pressure value to set
    def set_pressure_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['pressure'] = value
    rescue StandardError => e
      warn "An error occurred in set_pressure_at_datetime: #{e.message}"
    end

    # Retrieves visibility at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The visibility or nil if not found
    def get_visibility_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['visibility']
    rescue StandardError => e
      warn "An error occurred in get_visibility_at_datetime: #{e.message}"
      nil
    end

    # Sets visibility at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The visibility value to set
    def set_visibility_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['visibility'] = value
    rescue StandardError => e
      warn "An error occurred in set_visibility_at_datetime: #{e.message}"
    end

    # Retrieves cloud cover at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The cloud cover or nil if not found
    def get_cloudcover_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['cloudcover']
    rescue StandardError => e
      warn "An error occurred in get_cloudcover_at_datetime: #{e.message}"
      nil
    end

    # Sets cloud cover at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The cloud cover value to set
    def set_cloudcover_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['cloudcover'] = value
    rescue StandardError => e
      warn "An error occurred in set_cloudcover_at_datetime: #{e.message}"
    end

    # Retrieves solar radiation at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The solar radiation or nil if not found
    def get_solarradiation_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['solarradiation']
    rescue StandardError => e
      warn "An error occurred in get_solarradiation_at_datetime: #{e.message}"
      nil
    end

    # Sets solar radiation at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The solar radiation value to set
    def set_solarradiation_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['solarradiation'] = value
    rescue StandardError => e
      warn "An error occurred in set_solarradiation_at_datetime: #{e.message}"
    end

    # Retrieves solar energy at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The solar energy or nil if not found
    def get_solarenergy_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['solarenergy']
    rescue StandardError => e
      warn "An error occurred in get_solarenergy_at_datetime: #{e.message}"
      nil
    end

    # Sets solar energy at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The solar energy value to set
    def set_solarenergy_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['solarenergy'] = value
    rescue StandardError => e
      warn "An error occurred in set_solarenergy_at_datetime: #{e.message}"
    end

    # Retrieves UV index at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The UV index or nil if not found
    def get_uvindex_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['uvindex']
    rescue StandardError => e
      warn "An error occurred in get_uvindex_at_datetime: #{e.message}"
      nil
    end

    # Sets UV index at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The UV index value to set
    def set_uvindex_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['uvindex'] = value
    rescue StandardError => e
      warn "An error occurred in set_uvindex_at_datetime: #{e.message}"
    end

    # Retrieves severe risk at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Float, nil] The severe risk or nil if not found
    def get_severerisk_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['severerisk']
    rescue StandardError => e
      warn "An error occurred in get_severerisk_at_datetime: #{e.message}"
      nil
    end

    # Sets severe risk at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Float] The severe risk value to set
    def set_severerisk_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['severerisk'] = value
    rescue StandardError => e
      warn "An error occurred in set_severerisk_at_datetime: #{e.message}"
    end

    # Retrieves conditions at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [String, nil] The conditions or nil if not found
    def get_conditions_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['conditions']
    rescue StandardError => e
      warn "An error occurred in get_conditions_at_datetime: #{e.message}"
      nil
    end

    # Sets conditions at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [String] The conditions value to set
    def set_conditions_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['conditions'] = value
    rescue StandardError => e
      warn "An error occurred in set_conditions_at_datetime: #{e.message}"
    end

    # Retrieves weather icon at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [String, nil] The weather icon or nil if not found
    def get_icon_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['icon']
    rescue StandardError => e
      warn "An error occurred in get_icon_at_datetime: #{e.message}"
      nil
    end

    # Sets weather icon at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [String] The weather icon value to set
    def set_icon_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['icon'] = value
    rescue StandardError => e
      warn "An error occurred in set_icon_at_datetime: #{e.message}"
    end

    # Retrieves weather stations at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [Array<String>, nil] The weather stations or nil if not found
    def get_stations_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['stations']
    rescue StandardError => e
      warn "An error occurred in get_stations_at_datetime: #{e.message}"
      nil
    end

    # Sets weather stations at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [Array<String>] The weather stations value to set
    def set_stations_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['stations'] = value
    rescue StandardError => e
      warn "An error occurred in set_stations_at_datetime: #{e.message}"
    end

    # Retrieves data source at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @return [String, nil] The data source or nil if not found
    def get_source_at_datetime(day_info, time_info)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['source']
    rescue StandardError => e
      warn "An error occurred in get_source_at_datetime: #{e.message}"
      nil
    end

    # Sets data source at specific datetime
    #
    # @param day_info [String, Integer] The day identifier, which can be a date string (YYYY-MM-DD) or an index
    # @param time_info [String, Integer] The time identifier, which can be a time string (HH:MM:SS) or an index
    # @param value [String] The data source value to set
    def set_source_at_datetime(day_info, time_info, value)
      day_item = filter_item_by_datetime_val(@weather_data['days'], day_info)
      hour_item = filter_item_by_datetime_val(day_item['hours'], time_info)
      hour_item['source'] = value
    rescue StandardError => e
      warn "An error occurred in set_source_at_datetime: #{e.message}"
    end

    # --- Clears the weather data ---
    def clear_weather_data
      @weather_data = {}
    end

    private

    # Filters an item by its datetime value from a list of dictionaries, each containing a 'datetime' key
    #
    # @param src [Array<Hash>] The source list of dictionaries, each expected to contain a 'datetime' key
    # @param datetime_val [String, Integer] The datetime value used for filtering, which can be a date string or an index
    # @return [Hash, nil] The filtered dictionary item or nil if not found
    # @raise [ArgumentError] If the datetime_val is neither a string nor an integer
    def filter_item_by_datetime_val(src, datetime_val)
      raise 'Source is nil' if src.nil?

      case datetime_val
      when String
        src.find { |item| item[DATETIME] == datetime_val }
      when Integer
        src[datetime_val] # if datetime_val.between?(0, src.size - 1)
      else
        raise ArgumentError, "Invalid input datetime value for filter_item_by_datetime_val with str or int: #{datetime_val}"
      end
    rescue StandardError => e
      warn "An error occurred in filter_item_by_datetime_val: #{e.message}"
      nil
    end

    # Sets an item's data by its datetime value in a list of dictionaries based on the given datetime_val
    #
    # @param src [Array<Hash>] The source list of dictionaries, each expected to contain a 'datetime' key
    # @param datetime_val [String, Integer] The datetime value used for updating, which can be a date string or an index
    # @param data [Hash] The new data hash to replace the old dictionary
    # @raise [ArgumentError] If the input data is not a hash or datetime_val is neither a string nor an integer
    def set_item_by_datetime_val(src, datetime_val, data)
      raise 'Source is nil' if src.nil?
      raise ArgumentError, "Invalid input data value for set_item_by_datetime_val with hash: #{data}" unless data.is_a?(Hash)

      case datetime_val
      when String
        src.each do |item|
          if item[DATETIME] == datetime_val
            data.update({ DATETIME => datetime_val }) # Ensure datetime is not changed
            item.clear
            item.update(data)
            break
          end
        end
      when Integer
        data[DATETIME] = src[datetime_val][DATETIME] # Ensure datetime is not changed
        src[datetime_val] = data
      else
        raise ArgumentError, "Invalid input datetime value for set_item_by_datetime_val with str or int: #{datetime_val}"
      end
    rescue StandardError => e
      warn "An error occurred in filter_item_by_datetime_val: #{e.message}"
      nil
    end

    # Updates an item's data by its datetime value in a list of dictionaries based on the given datetime_val
    #
    # @param src [Array<Hash>] The source list of dictionaries, each expected to contain a 'datetime' key
    # @param datetime_val [String, Integer] The datetime value used for updating, which can be a date string or an index
    # @param data [Hash] The new data hash to update the old dictionary
    # @raise [ArgumentError] If the input data is not a hash or datetime_val is neither a string nor an integer
    def update_item_by_datetime_val(src, datetime_val, data)
      raise 'Source is nil' if src.nil?
      raise ArgumentError, "Invalid input data value for update_item_by_datetime_val with hash: #{data}" unless data.is_a?(Hash)

      case datetime_val
      when String
        src.each do |item|
          if item[DATETIME] == datetime_val
            item.update(data)
            item[DATETIME] = datetime_val # Ensure datetime is not changed
            break
          end
        end
      when Integer
        data[DATETIME] = src[datetime_val][DATETIME] # Ensure datetime is not changed
        src[datetime_val].update(data)
      else
        raise ArgumentError, "Invalid input datetime value for update_item_by_datetime_val with str or int: #{datetime_val}"
      end
    rescue StandardError => e
      warn "An error occurred in filter_item_by_datetime_val: #{e.message}"
      nil
    end
  end
end
