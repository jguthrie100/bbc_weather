require 'nokogiri'
require 'net/http'
require 'json'

class Weather
  def self.city(city_id, unit: "c")
    result = Hash.new

    if city_id.is_a?(Integer) || city_id =~ /^[0-9]+$/
      begin
        result = get_weather_from_bbc_url("http://www.bbc.co.uk/weather/#{city_id}", unit: unit)
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

    html = Nokogiri::HTML(Net::HTTP.get(URI(url)))

    if html.css("title")[0].children[0].text[/not found/i]
      raise ArgumentError, "The given URL returned a 404 error. Please check the city ID and try again"
    end

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
