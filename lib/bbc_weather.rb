require 'nokogiri'
require 'net/http'
require 'json'
require 'weather_result'

class BBCWeather
  $temp_unit = "c"
  $speed_unit = "mph"

  def self.city(city_id)
    result = {}

    if city_id.is_a?(Integer) || city_id =~ /^[0-9]+$/
      begin
        result = get_weather_from_bbc_url("http://www.bbc.co.uk/weather/en/#{city_id}")
      rescue ArgumentError => e
        if e.to_s[/404/]
          raise ArgumentError, "City ID: #{city_id} not found"
        end
        raise
      end
    else
      # Convert string location to integer city code
      city_ids = BBCWeather.get_city_id(city_id)

      if city_ids.length == 0
        raise ArgumentError, "City ID: '#{city_id}' could not be located"
      elsif city_ids.length > 1
        raise ArgumentError, "City ID: '#{city_id}' returned more than one matching city (#{city_ids}). Please refine your search term"
      else
        # Recursive call using integer city code
        return BBCWeather.city(city_ids[0]["id"])
      end
    end
    return result
  end

  def self.get_city_id(city_name)
    city_name_d = city_name.downcase
    city_ids = JSON.parse(Net::HTTP.get(URI("http://www.bbc.co.uk/locator/default/en-GB/autocomplete.json?search=#{city_name_d}&filter=international")))
    city_id = city_ids.select {|a| a["fullName"].downcase.eql?(city_name_d) || a["fullName"].downcase.eql?("#{city_name_d}, #{city_name_d}") || a["fullName"].downcase.eql?("#{city_name_d}, #{city_name_d} city") }

    city_id.empty? ? (return city_ids) : (return city_id)
  end

  def self.get_weather_from_bbc_url(url)
    html = {}
    html[:main] = Nokogiri::HTML(Net::HTTP.get(URI(url)))

    if html[:main].css("title")[0].children[0].text[/not found/i]
      raise ArgumentError, "The given URL returned a 404 error. Please check the city ID and try again"
    end

    lock = Mutex.new
    connections = []
    html[:main].css("div.daily-window > ul > li > a").each do |day|
       connections << Thread.new {
         day_url = day.attributes["data-ajax-href"].value
         day_html = Nokogiri::HTML(Net::HTTP.get(URI("http://www.bbc.co.uk#{day_url}")))
         lock.synchronize {
           html[day_url[/[0-9]+$/].to_i] = day_html
         }
       }
    end
    connections.each {|conn| conn.join}

    return WeatherResult.new(html)
  end

  def self.set_units(*units)
    curr_units = self.units
    count = {:temp => 0, :speed => 0}

    units.each do |u|
      if u == "c" || u == "celcius"
        $temp_unit = "c"
        count[:temp] += 1
      elsif u == "f" || u == "fahrenheit"
        $temp_unit = "f"
        count[:temp] += 1
      elsif u == "kph" || u == "km/h"
        $speed_unit = "kph"
        count[:speed] += 1
      elsif u == "mph"
        $speed_unit = "mph"
        count[:speed] += 1
      else
        $temp_unit = curr_units[0]
        $speed_unit = curr_units[1]
        raise ArgumentError, "'#{u}' is not a recognised unit of speed/temperature. Unit must be either 'c' or 'f' (celcius or fahrenheit), or 'kph' or 'mph' (kilometers per hour or miles per hour). Units have not been changed"
      end
    end
    if count[:temp] > 1 || count[:speed] > 1
      $temp_unit = curr_units[0]
      $speed_unit = curr_units[1]
      raise ArgumentError, "Cannot pass in two units of the same type (i.e. #set_units('kph', 'mph')). Units have not been changed"
    end

    return [$temp_unit, $speed_unit]
  end

  def self.units
    return [$temp_unit, $speed_unit]
  end
end
