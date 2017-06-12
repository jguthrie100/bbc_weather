require 'spec_helper'

describe BBCWeather do
  describe '#city' do
    context 'when given no arguments' do
      it 'should throw exception' do
        expect {BBCWeather.city}.to raise_error(ArgumentError)
      end
    end

    context 'when given an invalid numeric city ID' do
      it 'should return an ArgumentError' do
        expect {BBCWeather.city(1)}.to raise_error(ArgumentError, "City ID: 1 not found")
      end
    end

    context 'when given an invalid city ID string' do
      it 'should return an ArgumentError' do
        expect {BBCWeather.city("Nowheresville, Nowheresakhstan")}.to raise_error(ArgumentError, "City ID: 'Nowheresville, Nowheresakhstan' could not be located")
      end
    end

    context 'when given a not specific-enough city ID string' do
      it 'should return an ArgumentError' do
        expect { BBCWeather.city("Halifax") }.to raise_error(ArgumentError, 'City ID: \'Halifax\' returned more than one matching city ([{"id"=>"2647632", "name"=>"Halifax", "fullName"=>"Halifax, Calderdale"}, {"id"=>"6324729", "name"=>"Halifax", "fullName"=>"Halifax, Canada"}, {"id"=>"6296207", "name"=>"Halifax International Airport", "fullName"=>"Halifax International Airport, Canada"}]). Please refine your search term')
      end
    end

    context 'when given a valid numeric city ID' do
      let(:weather_halifax) { BBCWeather.city(2647632) }

      it 'should return a valid WeatherResult object' do
        expect(weather_halifax.class).to eql(WeatherResult)
        expect(weather_halifax.location).to eql("Halifax")
      end
    end

    context 'when given a valid city ID string' do
      let(:weather_numeric) { BBCWeather.city(2647632) }
      let(:weather_string) { BBCWeather.city("Halifax, Calderdale") }

      it 'should return the same values as when passing a numeric city ID' do
        expect(weather_string.class).to eql(WeatherResult)
        expect(weather_numeric.location).to eql(weather_string.location)
        expect(weather_numeric.tomorrow.low).to eql(weather_string.tomorrow.low)
        expect(weather_numeric.days_forward(2).sunrise).to eql(weather_string.days_forward(2).sunrise)
      end
    end
  end

  describe '#units' do
    context 'when #set_units has not been called yet' do
      it 'returns the default units' do
        expect(BBCWeather.units).to eql(["c", "mph"])
      end
    end
  end

  describe '#set_unit' do
    it 'sets the specified unit' do
      expect(BBCWeather.set_unit("kph")).to eql(["c", "kph"])
      expect(BBCWeather.set_unit("f")).to eql(["f", "kph"])
      expect(BBCWeather.set_unit("celcius")).to eql(["c", "kph"])
      expect(BBCWeather.set_unit("mph")).to eql(["c", "mph"])
      expect(BBCWeather.set_unit("km/h")).to eql(["c", "kph"])
      expect(BBCWeather.set_unit("fahrenheit")).to eql(["f", "kph"])
    end

    it 'should throw an ArgumentError if unit is not valid' do
      expect {BBCWeather.set_unit("boogietime")}.to raise_error(ArgumentError, "'boogietime' is not a recognised unit of speed/temperature. Unit must be either 'c' or 'f' (celcius or fahrenheit), or 'kph' or 'mph' (kilometers per hour or miles per hour)")
      expect {BBCWeather.set_unit("g")}.to raise_error(ArgumentError, "'g' is not a recognised unit of speed/temperature. Unit must be either 'c' or 'f' (celcius or fahrenheit), or 'kph' or 'mph' (kilometers per hour or miles per hour)")
      expect {BBCWeather.set_unit("belcius")}.to raise_error(ArgumentError, "'belcius' is not a recognised unit of speed/temperature. Unit must be either 'c' or 'f' (celcius or fahrenheit), or 'kph' or 'mph' (kilometers per hour or miles per hour)")
    end
  end

  describe '#units' do
    it 'returns the currently set units' do
      BBCWeather.set_unit("kph")
      BBCWeather.set_unit("c")
      expect(BBCWeather.units).to eql(["c", "kph"])

      BBCWeather.set_unit("mph")
      expect(BBCWeather.units).to eql(["c", "mph"])

      BBCWeather.set_unit("fahrenheit")
      expect(BBCWeather.units).to eql(["f", "mph"])

      BBCWeather.set_unit("km/h")
      expect(BBCWeather.units).to eql(["f", "kph"])
    end
  end

  context 'when changing which units are used' do
    let(:weather) { BBCWeather.city("Halifax, Calderdale") }
    it 'should return measurements according to the specified units' do
      BBCWeather.set_unit("celcius")
      BBCWeather.set_unit("mph")

      expect(weather.today.at("19:45").temperature).to eql(15)
      BBCWeather.set_unit("fahrenheit")
      expect(weather.today.at("19:45").temperature).to eql(59)

      expect(weather.today.at("19:45").wind_speed).to eql(18)
      BBCWeather.set_unit("km/h")
      expect(weather.today.at("19:45").wind_speed).to eql(29)

      expect(weather.tomorrow.low).to eql(53)
      BBCWeather.set_unit("celcius")
      expect(weather.tomorrow.low).to eql(12)

      expect(weather.current_temp).to eql(15)
      BBCWeather.set_unit("fahrenheit")
      expect(weather.current_temp).to eql(59)

      # Reset to default
      BBCWeather.set_unit("celcius")
      BBCWeather.set_unit("mph")
    end
  end
end
