require 'rails_helper'

RSpec.describe Place, type: :model do
  it { should belong_to :user }
  it { should belong_to :category }
  it { should validate_presence_of :name }
  it { should validate_presence_of :lat }
  it { should validate_presence_of :lng }
  it { should validate_presence_of :foursquare_venue_id }
  it { should validate_uniqueness_of(:foursquare_venue_id).scoped_to(:user_id) }

  let(:user)             { build_stubbed(:user) }
  let(:foursquare_venue) { stub_foursquare_venue }

  describe '.from_foursquare' do
    context "the place doesn't exist" do
      it 'create the new place' do
        place = Place.from_foursquare(foursquare_venue, user)

        expect(place).to be_valid
      end

      it 'saves foursquare metadata' do
        place = Place.from_foursquare(foursquare_venue, user)

        expect(place.foursquare_data).to eq(foursquare_venue.to_json)
      end
    end

    context 'the place exists' do
      let!(:existing_place) { Place.from_foursquare(foursquare_venue, user) }

      it 'returns the existing place' do
        place = Place.from_foursquare(foursquare_venue, user)

        expect(place).to eq(existing_place)
      end

      it "doesn't create a new place" do
        expect { Place.from_foursquare(foursquare_venue, user) }.
          to_not change { Place.count }
      end

    end
  end

  describe '.create_from_foursquare' do
    context 'with an already existing foursquare_venue_id in the user scope' do

      before do
        Place.create_from_foursquare(foursquare_venue, user)
      end

      it 'return nil' do
        place = Place.create_from_foursquare(foursquare_venue, user)

        expect(place).to be_nil
      end
    end

    it 'returns a new place' do
      place = Place.create_from_foursquare(foursquare_venue, user)

      expect(place).to be_valid
    end

    it 'strips the prefix from the foursquare venue id' do
      place = Place.create_from_foursquare(foursquare_venue, user)

      expect(place.foursquare_venue_id).to_not start_with('v')
    end
  end

  describe 'callbacks' do
    describe '#set_foursquare_url' do
      let(:foursquare_venue_url) { foursquare_venue['shortUrl'] }

      around do |example|
        VCR.use_cassette('place.foursquare_url') do
          example.run
        end
      end

      it 'sets the Foursquare URL' do
        place = Place.from_foursquare(foursquare_venue, user)

        expect(place.foursquare_venue_url).to eq(foursquare_venue_url)
      end
    end
  end

end
