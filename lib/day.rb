require 'timeslot'
require 'date'

class Day
  attr_accessor :date, :sunrise, :sunset, :timeslots, :nextday_timeslots

  def initialize(day_html, date)
    @timeslots = Array.new
    nextday_timeslot_index = nil

    @date = Date.parse(date)
    @sunrise = day_html.css("span.sunrise")[0].children[0].text[/\d{2}:\d{2}/]
    @sunset = day_html.css("span.sunset")[0].children[0].text[/\d{2}:\d{2}/]

###
### START LOOPS
###
    # Get times for each TimeSlot
    day_html.css("table.weather tr.time > th.value").each_with_index do |times_html, i|
      nextday_timeslot_index = i if times_html.attributes["class"].value.include?("next-day") && !nextday_timeslot_index

      # Sort out Timeslot time
      ts = TimeSlot.new
      time = "#{times_html.css("span[class='hour']").text}:#{times_html.css("span[class='mins']").text}"
      ts.time = DateTime.parse("#{@date}T#{time}")
      ts.time += 1 if nextday_timeslot_index

      # Sort out prev and next Timelots
      unless @timeslots[-1].nil?
        ts.prev = @timeslots[-1]
        @timeslots[-1].next = ts
      end

      @timeslots.push(ts)
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

  def at(time)
    if time.is_a?(DateTime) || time.is_a?(Time) || (time.is_a?(String) && time =~ /\d{2}:\d{2}/ && time[0..1].to_i >= 0 && time[0..1].to_i <= 23 && time[2..3].to_i >= 0 && time[2..3].to_i <= 59)
      curr_slot = self.timeslot(0)
      time = "#{@date}T#{time}" if time.is_a?(String)
      search_time = DateTime.parse(time.to_s).strftime("%s").to_i
      curr_slot_time = curr_slot.time.strftime("%s").to_i

      curr_diff = (search_time - curr_slot_time).abs

      loop do
        if search_time > curr_slot_time
          if !curr_slot.next.nil? && (curr_slot.next.time.strftime("%s").to_i - search_time).abs < curr_diff
            curr_slot = curr_slot.next
            curr_diff = (search_time - curr_slot.time.strftime("%s").to_i).abs
          else
            return curr_slot
          end
        elsif search_time <= curr_slot_time
          if !curr_slot.prev.nil? && ((curr_slot.prev.time-1).strftime("%s").to_i - search_time).abs < curr_diff
            return curr_slot.prev
          else
            return curr_slot
          end
        end
      end
    else
      raise ArgumentError, "Time must be in the format 'HH:MM' (00-23) i.e. '23:45' or as a DateTime/Time object"
    end
  end
end
