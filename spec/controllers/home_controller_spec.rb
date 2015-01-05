require 'rails_helper'

RSpec.describe HomeController do
  it { should route(:get, '/').to(action: :index) }

  describe 'GET index' do

    context 'user is not connected' do
      it 'goes to the index' do
        get :index

        expect(response).to be_success
      end
    end

    context 'user is logged in' do
      let(:current_user) { FactoryGirl.create(:user) }

      it 'redirects' do
        get :index, nil, user_id: current_user.id

        expect(response).to be_redirect
      end
    end

  end
end
