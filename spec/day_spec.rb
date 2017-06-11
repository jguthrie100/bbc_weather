require 'spec_helper'
require 'date'

describe Day do
  let(:weather) { Weather.city("Halifax, Calderdale")}

  describe '.new' do
    it 'creates a new Day object with initial variables set' do
      expect(weather.today.high).to match(/^[0-9]+$/)
      expect(weather.today.low).to match(/^[0-9]+$/)
      expect(weather.today.sunrise).to match(/^[0-9]{2}:[0-9]{2}$/)
      expect(weather.today.sunset).to match(/^[0-9]{2}:[0-9]{2}$/)
    end
  end

  describe '.high' do
    it 'gets the highest temperature value of the day' do
      expect(weather.today.high).to match(/^[0-9]+$/)
    end
  end

  describe '.low' do
    it 'gets the lowest temperature of the day' do
      expect(weather.today.low).to match(/^[0-9]+$/)
    end
  end
end
