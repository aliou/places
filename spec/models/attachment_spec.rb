require 'rails_helper'

RSpec.describe Attachment, type: :model do
  context 'association' do
    it { should belong_to :place }
  end

  context 'validations' do
    it { should validate_presence_of :url }
    it { should validate_uniqueness_of(:url).scoped_to(:place_id) }
  end

  describe '#thumbnail_url' do
    subject { FactoryGirl.create(:attachment) }

    it 'raises a not implemented error' do
      expect { subject.thumbnail_url }.
        to raise_error(Errors::NotImplementedError)
    end
  end
end
