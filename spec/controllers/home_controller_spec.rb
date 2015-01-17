require 'rails_helper'

RSpec.describe HomeController do
  it { should route(:get, '/').to(action: :index) }

  describe 'GET index' do
    context 'user is not connected' do
      it 'renders the index template' do
        get :index

        expect(response).to render_template('index')
      end
    end

    context 'user is logged in' do
      let(:current_user) { FactoryGirl.create(:user) }

      it 'redirects to the places path' do
        get :index, nil, user_id: current_user.id

        expect(response).to redirect_to(places_path)
      end
    end
  end
end
