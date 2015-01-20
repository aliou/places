require 'rails_helper'

RSpec.describe PlaceCreationJob do

  around do |example|
    VCR.use_cassette('place.foursquare_url') do
      example.run
    end
  end

  describe '.perform' do
    let(:user)                 { FactoryGirl.create(:user) }
    let(:foursquare_venue)     { stub_foursquare_venue }
    let(:foursquare_venue_url) { foursquare_venue['shortUrl'] }
    let(:place) { Place.create_from_foursquare(foursquare_venue, user) }

    it 'sets the foursquare venue url' do
      PlaceCreationJob.perform_now(place)
      place.reload

      expect(place.foursquare_venue_url).to eq(foursquare_venue_url)
    end
  end
end
