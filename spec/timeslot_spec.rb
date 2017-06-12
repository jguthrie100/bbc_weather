require 'spec_helper'

describe TimeSlot do
  let(:weather_halifax) { BBCWeather.city("Halifax, Calderdale")}

  describe '.new' do
    it 'creates a new Day object with initial variables set' do
      expect(weather_halifax.today.sunrise).to eql("04:37")
      expect(weather_halifax.today.sunset).to eql("21:37")
    end
  end

  describe '.high' do
    it 'gets the highest temperature value of the day' do
      expect(weather_halifax.today.high).to eql(17)
    end
  end

  describe '.low' do
    it 'gets the lowest temperature of the day' do
      expect(weather_halifax.today.low).to eql(13)
    end
  end
end
