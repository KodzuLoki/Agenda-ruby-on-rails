# app/services/open_weather_service.rb
require 'httparty'

class OpenWeatherService
  include HTTParty
  base_uri 'https://api.openweathermap.org/data/2.5'

  def self.consultar_clima(ciudad)
    api_key = '3a22ea43ba29beea41d5a34992888699' # API Key de OpenWeather
    options = { query: { q: ciudad, appid: api_key, units: 'metric', lang: 'es' } }

    response = get('/weather', options)
    if response.success?
      response.parsed_response
    else
      { error: 'No se pudo obtener la información del clima' }
    end
  end
end
