require 'nokogiri'
require 'net/http'
require 'json'

class Weather
  def self.city(city_id, unit: "c")
    result = Hash.new

    if city_id.is_a? Integer || city_id =~ /^[0-9]+$/
      result = get_weather_from_bbc_url("http://www.bbc.co.uk/weather/#{city_id}", unit: unit)
    else
      result[:error] = "Need city id"
    end
    return result
  end

  def self.get_city_id(city_name)
    json = JSON.parse(Net::HTTP.get(URI("http://www.bbc.co.uk/locator/default/en-GB/autocomplete.json?search=#{city_name}&filter=international")))
  end

  def self.get_weather_from_bbc_url(url, unit: "c")
    html = Nokogiri::HTML(Net::HTTP.get(URI(url)))

    result = Hash.new

    result[:location] = html.css("span.location-name")[0].children[0].text
    result[:current_temp] = html.css("span.temperature-value")[0].children[0].text
    result[:current_humidity] = html.css("p.humidity span")[0].children[0].text

    result[:high] = html.css("span.max-temp-value span span[data-unit=#{unit}]")[0].children[0].text
    result[:low] = html.css("span.min-temp-value span span[data-unit=#{unit}]")[0].children[0].text

    result[:sunrise] = html.css("span.sunrise")[0].children[0].text[/\d{2}:\d{2}/]
    result[:sunset] = html.css("span.sunset")[0].children[0].text[/\d{2}:\d{2}/]

    return result
  end
end
