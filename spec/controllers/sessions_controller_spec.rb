require 'rails_helper'

RSpec.describe SessionsController do
  describe 'GET /auth/foursquare/callback' do
    context 'with the wrong omniauth credentials' do

      before do
        request.env['omniauth.auth'] = stub_oauth(
          uid:   Faker::Number.number(6),
          token: Faker::Internet.password
        )
      end

      it "doesn't save the user" do
        expect { get :create, provider: 'foursquare' }.to_not change { User.count }
      end

      it 'redirects to the auth failure path' do
        get :create, provider: 'foursquare'

        expect(response).to redirect_to(auth_failure_path)
      end
    end
  end

  describe 'GET /signout' do
    it 'resets the session' do
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to the root path' do
      get :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end
