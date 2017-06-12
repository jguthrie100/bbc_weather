Gem::Specification.new do |s|
  s.name        = 'bbc-weather'
  s.version     = '0.1.0'
  s.date        = '2017-06-09'
  s.summary     = "Get the weather!"
  s.description = "A simple gem to grab the BBC weather forecast for any given city"
  s.authors     = ["Jamie Guthrie"]
  s.email       = 'jamie.guthrie@gmail.com'
  s.files       = ["lib/bbc-weather.rb", "lib/weather_result.rb", "lib/day.rb", "lib/timeslot.rb"]
  s.add_runtime_dependency 'nokogiri', '~> 1.8'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.homepage    =
    'http://www.github.com/jguthrie100/bbc-weather'
  s.license       = 'MIT'
end
