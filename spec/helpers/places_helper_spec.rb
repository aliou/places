require 'rails_helper'

RSpec.describe PlacesHelper do
  describe '#venue_primary_category' do
    let(:venue) { stub_foursquare_venue }

    context "the category doesn't exist" do

      it 'creates the primary category for the venue' do
        expect{ venue_primary_category(venue) }.to change { Category.count }.by(1)
      end
    end

    context 'the category already exists' do
      let!(:existing_category) { venue_primary_category(venue) }

      it "doesn't create a new category" do
        expect{ venue_primary_category(venue) }.to_not change { Category.count }
      end

      it 'returns the existing category' do
        category = venue_primary_category(venue)

        expect(category).to eq(existing_category)
      end
    end
  end
end
