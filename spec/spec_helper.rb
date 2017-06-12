require 'rspec'
require 'webmock/rspec'
require 'bbc-weather'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    ##
    ## 'Halifax, Calderdale' HTML calls
    ##
    stub_request(:get, "http://www.bbc.co.uk/locator/default/en-GB/autocomplete.json?filter=international&search=Halifax,%20Calderdale").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => IO.read("./spec/halifax_html/autocomplete.json"), :headers => {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/2647632").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/halifax_html/main_page.html"), headers: {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/2647632/daily/2017-06-11?day=0").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/halifax_html/ajax_day_0.html"), headers: {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/2647632/daily/2017-06-12?day=1").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/halifax_html/ajax_day_1.html"), headers: {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/2647632/daily/2017-06-13?day=2").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/halifax_html/ajax_day_2.html"), headers: {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/2647632/daily/2017-06-14?day=3").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/halifax_html/ajax_day_3.html"), headers: {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/2647632/daily/2017-06-15?day=4").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/halifax_html/ajax_day_4.html"), headers: {})

    ##
    ## 'Auckland, New Zealand' (at ~1am) HTML calls
    ##
    stub_request(:get, "http://www.bbc.co.uk/locator/default/en-GB/autocomplete.json?filter=international&search=Auckland,%20New%20Zealand").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => IO.read("./spec/auckland_html/autocomplete.json"), :headers => {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/2193733").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/auckland_html/main_page.html"), headers: {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/2193733/daily/2017-06-11?day=0").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/auckland_html/ajax_day_0.html"), headers: {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/2193733/daily/2017-06-12?day=1").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/auckland_html/ajax_day_1.html"), headers: {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/2193733/daily/2017-06-13?day=2").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/auckland_html/ajax_day_2.html"), headers: {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/2193733/daily/2017-06-14?day=3").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/auckland_html/ajax_day_3.html"), headers: {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/2193733/daily/2017-06-15?day=4").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/auckland_html/ajax_day_4.html"), headers: {})

    ##
    ## Failed testcase URL calls
    ##
    stub_request(:get, "http://www.bbc.co.uk/locator/default/en-GB/autocomplete.json?filter=international&search=Halifax").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => IO.read("./spec/fail_html/autocomplete_halifax.json"), :headers => {})

    stub_request(:get, "http://www.bbc.co.uk/locator/default/en-GB/autocomplete.json?filter=international&search=Nowheresville,%20Nowheresakhstan").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => IO.read("./spec/fail_html/autocomplete_nowheresville.json"), :headers => {})

    stub_request(:get, "http://www.bbc.co.uk/weather/en/1").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host'=>'www.bbc.co.uk', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: IO.read("./spec/fail_html/not_found.html"), headers: {})
  end
end
