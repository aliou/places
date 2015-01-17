require 'rails_helper'

RSpec.describe PlacesController do
  it { should route(:get,    '/places')       .to(action: :index) }
  it { should route(:get,    '/places/new')   .to(action: :new) }
  it { should route(:get,    '/places/1/edit').to(action: :edit, id: 1) }
  it { should route(:get,    '/places/1')     .to(action: :show, id: 1) }
  it { should route(:post,   '/places')       .to(action: :create) }
  it { should route(:patch,  '/places/1')     .to(action: :update, id: 1) }
  it { should route(:put,    '/places/1')     .to(action: :update, id: 1) }
  it { should route(:delete, '/places/1')     .to(action: :destroy, id: 1) }
  it { should route(:get,    '/places/import').to(action: :import) }

  describe 'GET .index' do
    let(:current_user) { FactoryGirl.create(:user_with_places) }

    it 'assigns the places' do
      places = current_user.places
      get :index, nil, user_id: current_user.id

      expect(assigns(:places)).to eq(places)
    end

    it 'renders the index template' do
      get :index, nil, user_id: current_user.id

      expect(response).to render_template('index')
    end
  end

end
