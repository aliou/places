module FoursquareAPIHelper
  def stub_foursquare_venue
    JSON.parse(File.read('spec/support/fixtures/place.json'))
  end
end
