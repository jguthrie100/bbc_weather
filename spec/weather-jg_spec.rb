require 'spec_helper'

describe Weather do
  describe '.city' do
    context 'when given no arguments' do
      it 'should throw exception' do
        expect {Weather.city}.to raise_error(ArgumentError)
      end
    end

    context 'when given an invalid numeric city ID' do
      it 'should return an ArgumentError' do
        expect {Weather.city(1)}.to raise_error(ArgumentError, "City ID: 1 not found")
      end
    end

    context 'when given an invalid city ID string' do
      it 'should return an ArgumentError' do
        expect {Weather.city("Nowheresville, Nowheresakhstan")}.to raise_error(ArgumentError, "City ID: 'Nowheresville, Nowheresakhstan' could not be located")
      end
    end

    context 'when given a not specific-enough city ID string' do
      it 'should return an ArgumentError' do
        expect { Weather.city("Halifax") }.to raise_error(ArgumentError, 'City ID: \'Halifax\' returned more than one matching city ([{"id"=>"2647632", "name"=>"Halifax", "fullName"=>"Halifax, Calderdale"}, {"id"=>"6324729", "name"=>"Halifax", "fullName"=>"Halifax, Canada"}, {"id"=>"6296207", "name"=>"Halifax International Airport", "fullName"=>"Halifax International Airport, Canada"}]). Please refine your search term')
      end
    end

    context 'when given a valid numeric city ID' do
      let(:weather) { Weather.city(2647632) }

      it 'should return a valid WeatherResult object' do
        expect(weather.class).to eql(WeatherResult)
        expect(weather.location).to eql("Halifax")
      end
    end

    context 'when given a valid city ID string' do
      let(:weather_numeric) { Weather.city(2647632) }
      let(:weather_string) { Weather.city("Halifax, Calderdale") }

      it 'should return the same values as when passing a numeric city ID' do
        expect(weather_string.class).to eql(WeatherResult)
        expect(weather_numeric.location).to eql(weather_string.location)
        expect(weather_numeric.tomorrow.low).to eql(weather_string.tomorrow.low)
        expect(weather_numeric.days_forward(2).sunrise).to eql(weather_string.days_forward(2).sunrise)
      end
    end

    context 'when given an invalid temperature unit' do
      it 'should return an ArgumentError' do
        expect {Weather.city(2647632, unit: "boogie")}.to raise_error(ArgumentError, "'boogie' is not a recognised unit of temperature. Unit must be either 'c' or 'f' (celcius or fahrenheit)")
      end
    end
  end
end
