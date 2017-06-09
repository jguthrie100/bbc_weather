require 'spec_helper'

describe Weather do
  describe '.city' do
    context 'when given no arguments' do
      it 'should throw exception' do
        expect {Weather.city}.to raise_error(ArgumentError)
      end
    end

    context 'when given a valid numeric city ID' do
      let(:weather) { Weather.city(2647632) }

      it 'should return a Hash containing todays weather data' do

        expect(weather[:location]).to eql("Halifax")
        expect(weather[:current_temp]).to match(/^[0-9]+$/)
        expect(weather[:current_humidity]).to match(/^[0-9]+%$/)
        expect(weather[:high]).to match(/^[0-9]+$/)
        expect(weather[:low]).to match(/^[0-9]+$/)
        expect(weather[:sunrise]).to match(/^[0-9]{2}:[0-9]{2}$/)
        expect(weather[:sunset]).to match(/^[0-9]{2}:[0-9]{2}$/)
      end
    end

    context 'when given an invalid numeric city ID' do
      it 'should return an ArgumentError' do
        expect {Weather.city(1)}.to raise_error(ArgumentError, "City ID: 1 not found")
        expect {Weather.city("Nowheresville, Nowheresakhstan")}.to raise_error(ArgumentError, "'Nowheresville, Nowheresakhstan' could not be located")
      end
    end
  end
end
