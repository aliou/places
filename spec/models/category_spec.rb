require 'rails_helper'

RSpec.describe Category do
  context 'on creation' do
    subject { FactoryGirl.create(:category) }

    it 'sets the icon url' do
      expect(subject.icon_url).to_not be_nil
    end
  end
end
