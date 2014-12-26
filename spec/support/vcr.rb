VCR.configure do |c|
  c.ignore_hosts 'codeclimate.com'
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock

  c.filter_sensitive_data('<FOURSQUARE_USER_ID>')    { ENV['FOURSQUARE_USER_ID'] }
  c.filter_sensitive_data('<FOURSQUARE_USER_TOKEN>') { ENV['FOURSQUARE_USER_TOKEN'] }
  c.filter_sensitive_data('<FOURSQUARE_KEY>')        { ENV['FOURSQUARE_KEY'] }
  c.filter_sensitive_data('<FOURSQUARE_SECRET>')     { ENV['FOURSQUARE_SECRET'] }
end
