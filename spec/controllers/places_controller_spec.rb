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

  describe 'GET .new' do
    let(:current_user) { FactoryGirl.create(:user_with_places) }

    # it 'builds a new place' do
    #   place = current_user.places.new
    #   get :new, nil, user_id: current_user.id
    #
    #   expect(assigns(:place)).to eq(place)
    # end

    it 'renders the new template' do
      get :new, nil, user_id: current_user.id

      expect(response).to render_template('new')
    end
  end

  describe 'GET .edit' do
    let(:current_user) { FactoryGirl.create(:user_with_places) }
    let(:place) { current_user.places.sample }

    it 'finds the place to edit' do
      get :edit, { id: place.id }, { user_id: current_user.id }

      expect(assigns(:place)).to eq(place)
    end

    it 'renders the edit template' do
      get :edit, { id: place.id }, { user_id: current_user.id }

      expect(response).to render_template('edit')
    end
  end

  describe 'GET .show' do
    let(:current_user) { FactoryGirl.create(:user_with_places) }
    let(:place) { current_user.places.sample }

    it 'finds the place to show' do
      get :show, { id: place.id }, { user_id: current_user.id }

      expect(assigns(:place)).to eq(place)
    end

    it 'renders the show template' do
      get :show, { id: place.id }, { user_id: current_user.id }

      expect(response).to render_template('show')
    end
  end
end
