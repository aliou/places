require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'validations' do
    let (:omniauth_data) { {
        'provider'    => 'foursquare',
        'uid'         => '0',
        'name'        => Faker::Name.name,
        'credentials' => { 'token'  => Faker::Internet.password,
                           'secret' => Faker::Internet.password }
      }
    }

    it 'should have its omniauth attributes set' do
      user = User.new

      expect(user).to_not be_valid
    end
    it 'should only be created using the create_with_omniauth method' do
      user = User.create_with_omniauth(omniauth_data)

      expect(user).to be_valid
    end
  end
end
