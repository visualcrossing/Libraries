# frozen_string_literal: true

require 'weather_visual'
require 'rspec'

RSpec.describe WeatherVisual::WeatherData do
  let(:api_key) { 'YOUR_API_KEY' }
  let(:weather) { WeatherVisual::WeatherData.new(api_key) }

  it 'fetches weather data successfully' do
    data = weather.fetch_weather_data('New York, NY', '2023-01-01', '2023-01-07', 'us', 'days', ['temp', 'humidity'])
    expect(data).not_to be_empty
  end

  it 'sets and retrieves weather data' do
    data = weather.fetch_weather_data('New York, NY', '2023-01-01', '2023-01-07')
    weather.set_weather_data(data)
    expect(weather.get_weather_data).to eq(data)
  end

  it 'retrieves daily weather data' do
    weather.fetch_weather_data('New York, NY', '2023-01-01', '2023-01-07')
    daily_data = weather.get_weather_daily_data
    expect(daily_data).not_to be_empty
  end

  it 'sets and retrieves daily weather data' do
    weather.fetch_weather_data('New York, NY', '2023-01-01', '2023-01-07')
    daily_data = weather.get_weather_daily_data
    weather.set_weather_daily_data(daily_data)
    expect(weather.get_weather_daily_data).to eq(daily_data)
  end

  it 'retrieves hourly weather data' do
    weather.fetch_weather_data('New York, NY', '2023-01-01', '2023-01-07', 'us', 'hours', ['temp', 'humidity'])
    hourly_data = weather.get_weather_hourly_data
    expect(hourly_data).not_to be_empty
  end

  it 'sets and retrieves temperature at specific datetime' do
    weather.fetch_weather_data('New York, NY', '2023-01-01', '2023-01-07', 'us', 'days,hours', ['temp'])
    day_index = 0
    hour_index = 0

    weather.set_temp_at_datetime(day_index, hour_index, 25)
    temp = weather.get_temp_at_datetime(day_index, hour_index)
    expect(temp).to eq(25)
  end

  it 'clears weather data' do
    weather.clear_weather_data
    expect(weather.get_weather_data).to be_empty
  end
end
