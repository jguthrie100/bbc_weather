require 'spec_helper'

describe Day do
  let(:weather_halifax) { BBCWeather.city("Halifax, Calderdale")}

  describe '#new' do
    it 'creates a new Day object' do
      expect(weather_halifax.today.class).to eql(Day)
      expect(weather_halifax.today.date).to eql(Date.parse("2017-06-11"))
      expect(weather_halifax.today.sunrise).to eql("04:37")
      expect(weather_halifax.today.sunset).to eql("21:37")
    end

    it 'populates Timeslots with correct data' do
      expect(weather_halifax.today.timeslot(0).class).to eql(TimeSlot)
      expect(weather_halifax.today.timeslot(0).time).to eql(DateTime.parse("2017-06-11T15:00"))
      expect(weather_halifax.today.timeslot(0).temperature).to eql(17)
      expect(weather_halifax.today.timeslot(0).humidity).to eql(65)
      expect(weather_halifax.today.timeslot(0).wind_speed).to eql(15)
      expect(weather_halifax.today.timeslot(0).wind_direction).to eql("SW")
      expect(weather_halifax.today.timeslot(0).visibility).to eql("Very Good")
      expect(weather_halifax.today.timeslot(0).pressure).to eql(1008)
      expect(weather_halifax.today.timeslot(0).conditions).to eql("Light Cloud")
      expect(weather_halifax.today.timeslot(0).icon_url).to eql("http://static.bbci.co.uk/weather/0.5.4506/images/icons/individual_32_icons/en_on_light_bg/7.png")

      expect(weather_halifax.days_forward(3).timeslot(7).class).to eql(TimeSlot)
      expect(weather_halifax.days_forward(3).timeslot(7).time).to eql(DateTime.parse("2017-06-14T22:00"))
      expect(weather_halifax.days_forward(3).timeslot(7).temperature).to eql(17)
      expect(weather_halifax.days_forward(3).timeslot(7).humidity).to eql(77)
      expect(weather_halifax.days_forward(3).timeslot(7).wind_speed).to eql(5)
      expect(weather_halifax.days_forward(3).timeslot(7).wind_direction).to eql("SSW")
      expect(weather_halifax.days_forward(3).timeslot(7).visibility).to eql("Very Good")
      expect(weather_halifax.days_forward(3).timeslot(7).pressure).to eql(1013)
      expect(weather_halifax.days_forward(3).timeslot(7).conditions).to eql("Partly Cloudy")
      expect(weather_halifax.days_forward(3).timeslot(7).icon_url).to eql("http://static.bbci.co.uk/weather/0.5.4506/images/icons/individual_56_icons/en_on_light_bg/2.gif")
    end

    it 'correctly sets the #next and #prev values for each Timeslot' do
      expect(weather_halifax.days_forward(2).timeslot(2).next).to eql(weather_halifax.days_forward(2).timeslot(3))
      expect(weather_halifax.days_forward(0).timeslot(2).prev).to eql(weather_halifax.days_forward(0).timeslot(1))
      expect(weather_halifax.days_forward(3).timeslot(4).next).to eql(weather_halifax.days_forward(3).timeslot(6).prev)

      expect(weather_halifax.days_forward(2).timeslot(0).prev).to eql(weather_halifax.days_forward(1).timeslot(23))
      expect(weather_halifax.days_forward(3).timeslot(7).next).to eql(weather_halifax.days_forward(4).timeslot(0))
    end
  end

  describe '#high' do
    it 'gets the highest temperature value of the day' do
      expect(weather_halifax.today.high).to eql(17)
    end
  end

  describe '#low' do
    it 'gets the lowest temperature of the day' do
      expect(weather_halifax.today.low).to eql(13)
    end
  end

  describe '#at' do
    it 'gets the timeslot closest to the specified time' do
      expect(weather_halifax.today.at("19:45").time).to eql(DateTime.parse("2017-06-11T20:00"))
      expect(weather_halifax.tomorrow.at("00:25").time).to eql(DateTime.parse("2017-06-12T00:00"))
      expect(weather_halifax.tomorrow.at("23:54").time).to eql(DateTime.parse("2017-06-13T00:00"))
      expect(weather_halifax.tomorrow.at(DateTime.parse("2017-06-12T04:45")).time).to eql(DateTime.parse("2017-06-12T05:00"))
    end

    it 'throws an error when invalid input is passed in' do
      expect {weather_halifax.today.at(321)}.to raise_error(ArgumentError, "Time must be in the format 'HH:MM' (00-23) i.e. '23:45' or as a DateTime/Time object")
      expect {weather_halifax.today.at("24:00")}.to raise_error(ArgumentError, "Time must be in the format 'HH:MM' (00-23) i.e. '23:45' or as a DateTime/Time object")
      expect {weather_halifax.today.at("1945")}.to raise_error(ArgumentError, "Time must be in the format 'HH:MM' (00-23) i.e. '23:45' or as a DateTime/Time object")
    end
  end
end
