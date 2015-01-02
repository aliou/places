require 'rails_helper'

RSpec.describe Category do
  it { should have_many :places }
  it { should validate_presence_of :name }

  let(:foursquare_category) { stub_foursquare_category }

  describe '.from_foursquare' do
    context "the category doesn't exists" do
      it 'creates the new category' do
        category = Category.from_foursquare(foursquare_category)

        expect(category).to be_valid
      end

      it 'saves the foursquare metadata' do
        category = Category.from_foursquare(foursquare_category)

        expect(category.foursquare_data).to eq(foursquare_category.to_json)
      end
    end

    context 'the category exists' do
      let!(:existing_category) { Category.from_foursquare(foursquare_category) }

      it 'returns the existing category' do
        category = Category.from_foursquare(foursquare_category)

        expect(category).to eq(existing_category)
      end

      it "doesn't create a new category" do
        expect { Category.from_foursquare(foursquare_category) }.
          to_not change { Category.count }
      end
    end
  end
end
