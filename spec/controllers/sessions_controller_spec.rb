require 'rails_helper'

RSpec.describe SessionsController do
  it { should route(:get, '/auth/foursquare/callback').
       to(action: :create, provider: 'foursquare') }
  it { should route(:get, '/signout').to(action: :destroy) }
  it { should route(:get, '/auth/failure').to(action: :failure) }

  describe 'GET /auth/foursquare/callback' do
    context 'with the wrong omniauth credentials' do
      before do
        request.env['omniauth.auth'] = stub_oauth(
          uid:   Faker::Number.number(6),
          token: Faker::Internet.password
        )
      end

      it "doesn't save the user" do
        expect { get :create, provider: 'foursquare' }.
          to_not change { User.count }
      end

      it 'redirects to the auth failure path' do
        get :create, provider: 'foursquare'

        expect(response).to redirect_to(auth_failure_path)
      end
    end

    context 'with the right omniauth credentials' do
      before do
        request.env['omniauth.auth'] = stub_oauth(
          uid:   ENV['FOURSQUARE_USER_ID'],
          token: ENV['FOURSQUARE_USER_TOKEN']
        )
      end

      around do |example|
        VCR.use_cassette('foursquare_oauth_authentification') do
          example.run
        end
      end

      it 'creates a new user' do
        expect { get :create, provider: 'foursquare' }.
          to change { User.count }
      end

      it 'saves the user id in the session' do
        get :create, provider: 'foursquare'

        expect(session[:user_id]).to_not be_nil
      end

      it 'redirects to the Places index path' do
        get :create, provider: 'foursquare'

        expect(response).to redirect_to(places_path)
      end
    end
  end

  describe 'GET /signout' do
    let(:user_id) { Faker::Number.number(4) }

    it 'resets the session' do
      get :destroy, nil, user_id: user_id

      expect(session[:user_id]).to be_nil
    end

    it 'redirects to the root path' do
      get :destroy, nil, user_id: user_id

      expect(response).to redirect_to(root_path)
    end
  end
end
