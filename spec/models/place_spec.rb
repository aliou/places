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

  describe '#places_around' do
    let(:user) { FactoryGirl.create(:user) }
    subject    { FactoryGirl.build_stubbed(:place) }

    it "is empty when there's no Place around" do
      expect(subject.places_around).to be_empty
    end

    context 'with different zoom levels' do
      subject { FactoryGirl.create(:place, :notre_dame) }

      let(:hotel_de_ville) { FactoryGirl.create(:place, :hotel_de_ville) }
      let(:tour_eiffel) { FactoryGirl.create(:place, :tour_eiffel) }
      let(:louvre) { FactoryGirl.create(:place, :louvre) }

      before do
        user.places += [hotel_de_ville, tour_eiffel, louvre]
      end

      it 'returns the Places in the same neighborhood' do
        expect(subject.places_around).to match_array([hotel_de_ville])
      end

      it 'returns the Places in the same town' do
        expect(subject.places_around(MapboxHelper::TOWN_LEVEL_ZOOM)).
          to match_array([hotel_de_ville, tour_eiffel, louvre])
      end

      it 'returns the Places in the same country' do
        expect(subject.places_around(MapboxHelper::COUNTRY_LEVEL_ZOOM)).
          to match_array([hotel_de_ville, tour_eiffel, louvre])
      end

      it 'returns the Places in world' do
        expect(subject.places_around(MapboxHelper::WORLD_LEVEL_ZOOM)).
          to match_array(Place.all - [subject])
      end
    end
  end

  describe 'callbacks' do
    describe '#set_foursquare_url' do
      let(:foursquare_venue_url) { foursquare_venue['shortUrl'] }

      it 'creates a job after the place creation' do
        Place.from_foursquare(foursquare_venue, user)

        expect(ActiveJob::Base.queue_adapter.enqueued_jobs).to_not be_empty
      end
    end
  end
end
