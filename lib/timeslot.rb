class TimeSlot
  attr_accessor :time, :temperature, :humidity, :visibility, :pressure, :wind_speed, :wind_direction, :conditions, :icon_url, :next, :prev

  def initialize
  end

  def temperature
    if $temp_unit.eql?("c")
      return @temperature
    else
      return ((@temperature * 9 / 5) + 32).round
    end
  end

  def wind_speed
    if $speed_unit.eql?("mph")
      return @wind_speed
    else
      return (@wind_speed * 1.609344).round
    end
  end
end
