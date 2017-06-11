require 'date'

class TimeSlot
  attr_accessor :time, :temperature, :humidity, :visibility, :pressure, :wind_speed, :wind_direction, :conditions, :icon_url, :next, :prev

  def initialize
  end
end
