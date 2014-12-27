require 'rails_helper'

RSpec.describe User::PlaceImporter, type: :model do
  it { should belong_to :user }

  let(:user) { FactoryGirl.create(:user) }

  describe '.create' do
    let (:last_import_date) { 2.days.ago }

    it 'should set a default last imported date to a day ago' do
      importer = user.create_place_importer

      expect(importer.last_imported_at).to_not be_nil
      expect(importer.last_imported_at).to eq(Date.yesterday)
    end

    it "shouldn't set a default last imported date if one is provided" do
      importer = user.create_place_importer(last_imported_at: last_import_date)

      expect(importer.last_imported_at).to_not be_nil
      expect(importer.last_imported_at).to_not eq(Date.yesterday)
      expect(importer.last_imported_at).to eq(last_import_date)
    end
  end
end
