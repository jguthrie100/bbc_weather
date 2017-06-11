require 'timeslot'

class Day
  attr_accessor :date, :sunrise, :sunset, :timeslots, :nextday_timeslots

  def initialize(day_html, return_next_day_timeslots: false)
    @timeslots = Array.new
    nextday_timeslot_index = nil

    @sunrise = day_html.css("span.sunrise")[0].children[0].text[/\d{2}:\d{2}/]
    @sunset = day_html.css("span.sunset")[0].children[0].text[/\d{2}:\d{2}/]

###
### START LOOPS
###
    # Get times for each TimeSlot
    day_html.css("table.weather tr.time > th.value").each_with_index do |times_html, i|
      ts = TimeSlot.new
      ts.time = "#{times_html.css("span[class='hour']").text}:#{times_html.css("span[class='mins']").text}"

      unless @timeslots[-1].nil?
        ts.prev = @timeslots[-1]
        @timeslots[-1].next = ts
      end

      @timeslots.push(ts)

      nextday_timeslot_index = i if times_html.attributes["class"].value.include?("next-day") && !nextday_timeslot_index
    end

    # Get weather conditions for each TimeSlot
    day_html.css("table.weather tr.weather-type > td img").each_with_index do |conditions_html, i|
      @timeslots[i].conditions = conditions_html.attributes["title"].value
      @timeslots[i].icon_url = conditions_html.attributes["src"].value
    end

    # Get temperature for each TimeSlot
    day_html.css("table.weather tr.temperature > td span[data-unit='c']").each_with_index do |temperature_html, i|
      @timeslots[i].temperature = temperature_html.children[0].text.to_i
    end

    # Get wind details for each TimeSlot
    day_html.css("table.weather tr.windspeed > td > span.wind").each_with_index do |wind_html, i|
      wind_data = wind_html.attributes["data-tooltip-mph"].value
      @timeslots[i].wind_speed = wind_data[/\d+/].to_i
      @timeslots[i].wind_direction = wind_data.gsub(/[^A-Z]/, "")
    end

    # Get humidity for each TimeSlot
    day_html.css("table.weather tr.humidity > td.value").each_with_index do |humidity_html, i|
      @timeslots[i].humidity = humidity_html.children[0].text[/\d+/].to_i
    end

    # Get visibility for each TimeSlot
    day_html.css("table.weather tr.visibility > td.value abbr").each_with_index do |visibility_html, i|
      @timeslots[i].visibility = visibility_html.attributes["title"].value
    end

    # Get pressure for each TimeSlot
    day_html.css("table.weather tr.pressure > td.value").each_with_index do |pressure_html, i|
      @timeslots[i].pressure = pressure_html.children[0].text[/\d+/].to_i # In Millibars
    end
###
### END LOOPS
###
    # Shift any timeslots after midnight into the nextday_timeslots
    @nextday_timeslots = @timeslots.slice!(nextday_timeslot_index, @timeslots.length-nextday_timeslot_index)
  end

  def high
    @timeslots.max_by {|ts| ts.temperature}.temperature
  end

  def low
    @timeslots.min_by {|ts| ts.temperature}.temperature
  end

  def timeslot(i)
    return nil unless i.is_a?(Integer)
    @timeslots[i]
  end

  def at_time(time)
    raise RuntimeError, "Need to implement"
  end
end
