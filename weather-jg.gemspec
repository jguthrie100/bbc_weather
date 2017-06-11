Gem::Specification.new do |s|
  s.name        = 'weather-jg'
  s.version     = '0.0.1'
  s.date        = '2017-06-09'
  s.summary     = "Get the weather!"
  s.description = "A simple gem to grab the BBC weather forecast for any given city"
  s.authors     = ["Jamie Guthrie"]
  s.email       = 'jamie.guthrie@gmail.com'
  s.files       = ["lib/weather-jg.rb", "lib/weather_result.rb", "lib/day.rb", "lib/timeslot.rb"]
  s.add_runtime_dependency 'nokogiri'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'factory_girl'
  s.homepage    =
    'http://www.github.com/jguthrie100/weather-jg'
  s.license       = 'MIT'
end
