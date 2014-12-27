require 'rails_helper'

RSpec.describe User::PlaceImporter, type: :model do
  it { should belong_to :user }

  let(:user) { FactoryGirl.create(:user) }

  describe '#first_import?' do

    context 'when the last import date is not set' do
      subject { user.create_place_importer }

      it 'is the first import' do
        expect(subject.first_import?).to be_truthy
      end
    end

    context 'when the last import date is set' do
      let(:last_import_date) { 2.days.ago }

      subject { user.create_place_importer(last_imported_at: last_import_date) }

      it 'is not the first import' do
        expect(subject.first_import?).to be_falsy
      end
    end
  end
end
