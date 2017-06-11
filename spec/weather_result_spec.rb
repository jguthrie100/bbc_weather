require 'spec_helper'
require 'date'

describe WeatherResult do
  let(:weather) { Weather.city("Halifax, Calderdale")}

  describe '.new' do
    it 'creates new WeatherResult object with initial variables set' do
      expect(weather.location).to eql("Halifax")
      expect(weather.current_temp).to match(/^[0-9]+$/)
      expect(weather.current_humidity).to match(/^[0-9]+%$/)
    end
  end
  describe '.today' do
    it 'returns the Day object relating to the current day in the searched city' do
      expect(weather.today.class).to eql(Day)

      # For one hour a day during British Summer Time, this test will fail
      expect(weather.today.date).to eql(DateTime.now.new_offset("GMT").to_s[0...10])
    end
  end

  describe '.tomorrow' do
    it 'returns the Day object relating to the next day in the searched city' do
      expect(weather.tomorrow.class).to eql(Day)

      # For one hour a day during British Summer Time, this test will fail
      expect(weather.tomorrow.date).to eql((DateTime.now+1).new_offset("GMT").to_s[0...10])
    end
  end

  describe '.days_forward' do
    it 'returns the Day object from the relevant number of days in the future' do
      expect(weather.days_forward(0).class).to eql(Day)
      expect(weather.days_forward(3).class).to eql(Day)

      # For one hour a day during British Summer Time, this test will fail
      expect(weather.days_forward(2).date).to eql((DateTime.now+2).new_offset("GMT").to_s[0...10])
      expect(weather.days_forward(1).date).to eql((DateTime.now+1).new_offset("GMT").to_s[0...10])
    end
  end
end
