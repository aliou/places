require 'rails_helper'

describe PlaceFilterer do
  let(:user) { FactoryGirl.create(:user) }

  describe '#places' do
    context 'when there are no filters' do
      it 'returns all of the user places' do
        expect(PlaceFilterer.new({}, user).places).to match_array(user.places)
      end
    end

    context 'when there are filters' do
      let(:filters) { { origin: [48.85, 2.34], zoom: MapHelper::TOWN_LEVEL_ZOOM } }
      let(:notre_dame) do
        FactoryGirl.create(:place, :notre_dame, user: user)
      end
      let(:hotel_de_ville) do
        FactoryGirl.create(:place, :hotel_de_ville, user: user)
      end
      let(:tour_eiffel) do
        FactoryGirl.create(:place, :tour_eiffel, user: user)
      end

      let!(:filtered_places) { [notre_dame, hotel_de_ville, tour_eiffel] }

      it 'returns the filtered places' do
        expect(PlaceFilterer.new(filters, user).places).
          to match_array(filtered_places)
      end
    end
  end
end
