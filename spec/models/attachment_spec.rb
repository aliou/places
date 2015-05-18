require 'rails_helper'

RSpec.describe Attachment, type: :model do
  context 'association' do
    it { should belong_to :place }
  end

  context 'validations' do
    it { should validate_presence_of :url }
    it { should validate_uniqueness_of(:url).scoped_to(:place_id) }
  end
end
