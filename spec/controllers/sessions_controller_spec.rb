require 'rails_helper'

RSpec.describe SessionsController do
  describe 'GET /auth/foursquare/callback' do
    context 'with the wrong omniauth credentials' do

      before do
        request.env['omniauth.auth'] = stub_oauth(
          uid:   Faker::Number.number(6),
          token: Faker::Internet.password)
      end

      it "doesn't save the user" do
        expect { get :create, provider: 'foursquare' }.to_not change { User.count }
      end
    end
  end
end
