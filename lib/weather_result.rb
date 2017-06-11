require 'nokogiri'
require 'date'
require 'day'
require 'timeslot'

class WeatherResult
  attr_reader :location, :current_time, :current_temp, :current_humidity, :days
  def initialize(html)
    @location = html[:main].css("span.location-name")[0].children[0].text
    @current_temp = html[:main].css("span.temperature-value")[0].children[0].text.to_i
    @current_humidity = html[:main].css("p.humidity > span")[0].children[0].text[/\d+/].to_i  # In %

    timezone = html[:main].css("div.ack > p")[1].children[0].text[/GMT[+-]\d{4}/]
    @current_time = DateTime.now.new_offset(timezone).to_s

    @days = []
    nextday_timeslots = []

    5.times do |i|
      date = html[:main].css("div.daily-window > ul > li > a")[i].attributes["data-ajax-href"].value[/\d{4}-\d{2}-\d{2}/]
      day = Day.new(html[i], date)

      # Transfer 'yesterdays' next_day timeslots to today and link up next and prev links
      unless nextday_timeslots.empty?
        nextday_timeslots[-1].next = day.timeslots[0]
        day.timeslots[0].prev = nextday_timeslots[-1]
        day.timeslots = nextday_timeslots.concat(day.timeslots)
      end
      nextday_timeslots = day.nextday_timeslots.dup
      day.nextday_timeslots.clear
      @days.push day
    end

    @days.shift if @days[0].timeslots.empty?
  end

  # Returns today of the city location, _not_ today of the user
  # i.e. a user in Canada wants the forecast for Auckland, New Zealand..
  #  .today then refers to Auckland's today, which may well be one day ahead of Canada
  def today
    return @days[0]
  end

  def tomorrow
    return @days[1]
  end

  def days_forward(i)
    return nil unless i.is_a?(Integer)
    return @days[i]
  end
end
