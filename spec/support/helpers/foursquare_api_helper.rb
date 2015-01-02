module FoursquareAPIHelper
  def stub_foursquare_venue
    stub_from_file('spec/support/fixtures/place.json')
  end

  def stub_foursquare_category
    stub_from_file('spec/support/fixtures/category.json')
  end

  def stub_from_file(file)
    JSON.parse(File.read(file))
  end
end
