require 'nokogiri'
require 'net/http'
require 'json'
require 'weather_forecast'

class Weather
  def self.city(city_id, unit: "c")
    result = Hash.new

    if city_id.is_a?(Integer) || city_id =~ /^[0-9]+$/
      begin
        result = get_weather_from_bbc_url("http://www.bbc.co.uk/weather/en/#{city_id}", unit: unit)
      rescue ArgumentError => e
        if e.to_s[/404/]
          raise ArgumentError, "City ID: #{city_id} not found"
        end
        raise
      end
    else
      city_ids = Weather.get_city_id(city_id)

      if city_ids.length == 0
        raise ArgumentError, "City ID: '#{city_id}' could not be located"
      elsif city_ids.length > 1
        raise ArgumentError, "City ID: '#{city_id}' returned more than one matching city (#{city_ids}). Please refine your search term"
      else
        return Weather.city(city_ids[0]["id"], unit: unit)
      end
    end
    return result
  end

  def self.get_city_id(city_name)
    JSON.parse(Net::HTTP.get(URI("http://www.bbc.co.uk/locator/default/en-GB/autocomplete.json?search=#{city_name}&filter=international")))
  end

  def self.get_weather_from_bbc_url(url, unit: "c")
    if unit == "c" || unit == "celcius"
      unit = "c"
    elsif unit == "f" || unit == "fahrenheit"
      unit = "f"
    else
      raise ArgumentError, "'#{unit}' is not a recognised unit of temperature. Unit must be either 'c' or 'f' (celcius or fahrenheit)"
    end

    html = Hash.new
    html[:main] = Nokogiri::HTML(Net::HTTP.get(URI(url)))

    if html[:main].css("title")[0].children[0].text[/not found/i]
      raise ArgumentError, "The given URL returned a 404 error. Please check the city ID and try again"
    end

####
## - Convert to use threads for each html call
###
html[:main].css("div.daily-window > ul > li > a").each do |day|
   day_url = day.attributes["data-ajax-href"].value
   html[day_url[/[0-9]+$/].to_i] = Nokogiri::HTML(Net::HTTP.get(URI("http://www.bbc.co.uk#{day_url}")))
end

#    html[:main].css("div.daily-window ul") do |i|
#      html[i] = Nokogiri::HTML(Net::HTTP.get(URI("#{url}/daily/000?day=#{i}")))
#    end

    return WeatherForecast.new(html, unit)
  end
end
