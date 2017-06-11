require 'spec_helper'
require 'date'

describe WeatherResult do
  let(:weather) { Weather.city("Halifax, Calderdale")}

  describe '#new' do
    it 'creates new WeatherResult object with initial variables set' do
      expect(weather.location).to eql("Halifax")
      expect(weather.current_temp).to eq(18)
      expect(weather.current_humidity).to eq(73)
    end
  end
  describe '#today' do
    it 'returns the Day object relating to the current day in the searched city' do
      expect(weather.today.class).to eql(Day)
      expect(weather.today.date).to eql(Date.parse("2017-06-11"))
    end
  end

  describe '#tomorrow' do
    it 'returns the Day object relating to the next day in the searched city' do
      expect(weather.tomorrow.class).to eql(Day)
      expect(weather.tomorrow.date).to eql(Date.parse("2017-06-12"))
    end
  end

  describe '#days_forward' do
    it 'returns the Day object from the relevant number of days in the future' do
      expect(weather.days_forward(0).class).to eql(Day)
      expect(weather.days_forward(3).class).to eql(Day)
      expect(weather.days_forward(2).date).to eql(Date.parse("2017-06-13"))
      expect(weather.days_forward(4).date).to eql(Date.parse("2017-06-15"))
    end
  end
end
