require 'rails_helper'

RSpec.describe Place, :type => :model do
  describe 'validations' do

    it 'must have a name, latitude and longitude' do
      place = Place.new

      expect(place).to_not be_valid
    end

  end
end
