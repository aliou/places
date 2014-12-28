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

  describe '#run' do
    context 'first import' do
      subject { user.create_place_importer }

      around do |example|
        VCR.use_cassette('place_importer.first_import') do
          example.run
        end
      end

      it 'imports all of the user places' do
        expect { subject.run }.to change { Place.count }.by(144)
      end

      it 'sets the last import date' do
        subject.run
        subject.reload

        expect(subject.last_imported_at).to_not be_nil
      end
    end

    context 'multiple imports' do
      subject { user.create_place_importer }

      around do |example|
        VCR.use_cassette('place_importer.multiple_import') do
          example.run
        end
      end

      before do
        subject.last_imported_at = Time.now
        subject.save
      end

      it 'only imports the new places since the last import' do
        subject.run(limit: 100, offset: 44)

        expect { subject.run }.to change { Place.count }.by(44)
      end
    end
  end
end
