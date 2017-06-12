### bbc-weather - A wrapper for scraping weather data from the BBC Weather website

## Installation

Latest version `0.1.0`

Add the following to your **Gemfile**
```bash
    gem 'bbc-weather'
```
  or
```bash
    $ gem install bbc-weather
```

## Usage


### Load the weather data for a specific city
A successful search for a city returns a `WeatherResult` object containing forecast data

```ruby
require 'bbc-weather'

# Load city using city name
weather = BBCWeather.city("Amsterdam, Netherlands")

# Load city using city id
weather = BBCWeather.city(2759794)
```

### Access the current weather data for the city

```ruby
# Get current weather in the city (in °C)
weather.current_temp
    > 17

# Get current humidity (in %)
weather.current_humidity
    > 71

# Get timestamp of the current time in the city
weather.current_time
    > "2017-06-12T13:14:56+02:00"
```

## Access forecast data for the current and coming days
 Each day of the forecast is represented as a `Day` object that contains all the weather data for the day, and which can be accessed in a number of ways:

```ruby
# Get today's weather data (today being the selected city's today)
weather.today

# Get tomorrow's weather data
weather.tomorrow

# Get the weather data for two days time
weather.days_forward(2)

# Get the weather data for the 13th June
weather.on("2017-06-13")

# Get the weather data for Wednesday
weather.on("Wednesday")

# Get the weather data for the 12th June
weather.on(DateTime.parse("2017-06-12T23:54"))
```

## Access general data for the selected day
Once you have the `Day` object, you can access various general weather data of the day
```ruby
# Get the date
weather.tomorrow.date
    > <#Date: 2017-06-13>

# Get the sunrise and sunset times for the day
weather.today.sunrise
    > "05:18"

weather.on("Friday").sunset
    > 22:03

# Get the max temperature of the day (in °C)
weather.on("2017-06-13").high
    > 22

# Get the min temperature of the day (in °C)
weather.today.low
    > 13
```

## Accessing more specific weather data
Each `Day` object is split into a number of `TimeSlot` objects. These `TimeSlot` objects each contain weather data for a specific time of the day (timeslots are usually in 1 hour or 3 hour intervals)

The `TimeSlot` objects can be accessed in the following ways..

```ruby
# Get the timeslot closest to 13:00 today
weather.today.at("13:00")

# Get the timeslot closest to 23:45 on the 17th June
weather.on("2017-06-17").at(DateTime.parse("2017-06-17T23:45"))
```

Each `TimeSlot` also contains a reference to the next and previous chronologically order timeslots which can be accessed using the `#next` and `#prev` methods:

```ruby
weather.today.at("23:00").next
weather.tomorrow.at("01:00").prev

weather.today.at("23:00").next == weather.tomorrow.at("01:00").prev
```

Each `TimeSlot` then contains the relevant forecast data for that time

```ruby
# Get the pressure (in millibars) at 12:23 on Tuesday
weather.on("Tues").at("12:23").pressure
    > 1102

# Get the weather conditions at 03:00 on the 12th June
weather.on("2017-06-12").at("03:00").conditions
    > "Light Cloud"
```

The available weather selectors are:

```ruby
ts = weather.on("2017-06-12").at("03:00")

# Get time
ts.time
    > #<DateTime: 2017-06-13T02:00..>

# Get temperature (in °C)
ts.temperature
    > 12

# Get humidity (in %)
ts.humidity
    > 56

# Get visibility
ts.visibility
    > "Very Good"

# Get pressure (in millibars)
ts.pressure
    > 1012

# Get windspeed (in mph)
ts.wind_speed
    > 12

# Get wind direction (as in direction wind is coming from)
ts.wind_direction
    > "SW"

# Get description of conditions
ts.conditions
    > "Light Cloud"

# Get the url of a graphical icon of the weather
ts.icon_url
    > "http://static.bbci.co.uk/weather/.../en_on_light_bg/7.gif"
```

## Changing units from mph to km/h and from °C to °F
The units pertaining to wind speed and temperature can be changed from `mph`/`kph` and `°C`/`°F` using the `BBCWeather.set_unit` static method (which dynamically works out which unit you want to set based on pattern matching your input).
The default units are `°C` and `mph`.

```ruby
# Get units - returns an Array
BBCWeather.units
    > ["c", "mph"]

# Set speed to kph
BBCWeather.set_unit "kph"
    > ["c", "kph"]

# Set temp to °F
BBCWeather.set_unit "f"
    > ["f", "kph"]

BBCWeather.units
    > ["f", "kph"]

# Get a temperature (which is set to °F)
weather.current_temp
    > 59

# Get windspeed (which is set to kph)
weather.today.at("00:00").wind_speed
    > 68
```
