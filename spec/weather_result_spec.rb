require 'spec_helper'
require 'date'

describe WeatherResult do
  let(:weather) { BBCWeather.city("Halifax, Calderdale")}

  describe '#new' do
    it 'creates new WeatherResult object with initial variables set' do
      expect(weather.location).to eql("Halifax")
      expect(weather.current_temp).to eq(15)
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

  describe '#on' do
    context 'given the day of the week' do
      it 'returns the forecast for that day' do
        expect(weather.on("Tuesday").date).to eql(Date.parse("2017-06-13"))
        expect(weather.on("Wednesday").at("13:00").humidity).to eql(60)
        expect(weather.on("Thurs").at("23:35").conditions).to eql("Clear Sky")
      end

      it 'throws an Error if the day is not recognised' do
        expect {weather.on("Thursfri")}.to raise_error(ArgumentError, "'Thursfri' is not a valid day")
      end
    end

    context 'given a string date' do
      it 'returns the forecast for that day' do
        expect(weather.on("2017-06-13").high).to eql(16)
        expect(weather.on("2017-06-11").at("19:55").wind_speed).to eql(18)
        expect(weather.on("2017-06-15").at("00:00").wind_direction).to eql("SW")
      end
    end

    context 'given a Date/DateTime object' do
      it 'returns the forecast for that day' do
        expect(weather.on(DateTime.parse("2017-06-14")).low).to eql(12)
        expect(weather.on(Date.parse("2017-06-12")).at("18:00").visibility).to eql("Very Good")
        expect(weather.on(DateTime.parse("2017-06-14T14:00")).at("23:35").pressure).to eql(1012)
      end
    end

    it 'throws an Error if the date is not in range' do
      expect {weather.on("2010-04-23")}.to raise_error(ArgumentError, "'2010-04-23' is not in the forecast range (2017-06-11 - 2017-06-15)")
      expect {weather.on("2017-06-16")}.to raise_error(ArgumentError, "'2017-06-16' is not in the forecast range (2017-06-11 - 2017-06-15)")
      expect {weather.on("Saturday")}.to raise_error(ArgumentError, "'2017-06-17' is not in the forecast range (2017-06-11 - 2017-06-15)")
      expect {weather.on(DateTime.parse("2017-06-10"))}.to raise_error(ArgumentError, "'2017-06-10' is not in the forecast range (2017-06-11 - 2017-06-15)")
    end
  end
end
