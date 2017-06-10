require 'nokogiri'
require 'date'
require 'day'

class WeatherForecast
  attr_reader :location, :current_time, :current_temp, :current_humidity, :days
  def initialize(html, unit)
    @location = html[:main].css("span.location-name")[0].children[0].text
    @current_temp = html[:main].css("span.temperature-value")[0].children[0].text
    @current_humidity = html[:main].css("p.humidity > span")[0].children[0].text

    timezone = html[:main].css("div.ack > p")[1].children[0].text[/GMT[+-]\d{4}/]
    @current_time = DateTime.now.new_offset(timezone).to_s

    @days = Hash.new
    5.times do |i|
      day = Day.new

      day.high = html[:main].css("span.max-temp-value > span > span[data-unit=#{unit}]")[i].children[0].text
      day.low = html[:main].css("span.min-temp-value > span > span[data-unit=#{unit}]")[i].children[0].text

      day.date = (Date.parse(html[:main].css("div.daily-window > ul > li > a")[0].attributes["data-ajax-href"].value[/\d{4}-\d{2}-\d{2}/])+i).to_s
      day.sunrise = html[i].css("span.sunrise")[0].children[0].text[/\d{2}:\d{2}/]
      day.sunset = html[i].css("span.sunset")[0].children[0].text[/\d{2}:\d{2}/]

      @days[i] = day
    end
  end

  def today
    return @days[0]
  end

  def tomorrow
    return @days[1]
  end
end
