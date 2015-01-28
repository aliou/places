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

  context 'not authenticated' do
    it 'redirect to the root_path' do
      get :index

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET .index' do
    let(:current_user) { FactoryGirl.create(:user_with_places) }

    it 'renders the index template' do
      get :index, nil, user_id: current_user.id

      expect(response).to render_template('index')
    end

    context 'with JSON format' do
      it 'seriazes the places' do
        places = ActiveModel::ArraySerializer.
          new(current_user.places, each_serializer: PlaceSerializer).to_json
        get :index, { format: :json }, user_id: current_user.id

        expect(response.body).to eq(places)
      end
    end

    context 'with an origin point' do
      let(:origin) { [48.8530, 2.3498] }

      before do
        @places = []
        @places << FactoryGirl.create(:place, user: current_user,
                                              lat: 48.8530, lng: 2.3498)
        @places << FactoryGirl.create(:place, user: current_user,
                                              lat: 48.8530, lng: 2.3498)
        @places << FactoryGirl.create(:place, user: current_user,
                                              lat: 48.8530, lng: 2.3498)
      end

      # TODO: This could be way better.
      xit 'assigns the places within 10 kms of the origin point' do
        get :index, { format: :json, origin: origin }, user_id: current_user.id

        response_ids = response_body.map { |p| p["id"] }
        expect(response_ids).to match_array(@places.map(&:id))
      end
    end
  end

  describe 'GET .new' do
    let(:current_user) { FactoryGirl.create(:user_with_places) }

    it 'builds a new place' do
      get :new, nil, user_id: current_user.id

      expect(assigns(:place)).to be_a_new(Place)
    end

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

  describe 'POST .create' do
    let(:current_user) { FactoryGirl.create(:user) }

    context 'with valid attributes' do
      let(:place_params) { { place: FactoryGirl.build(:place).attributes } }

      it 'creates a new place' do
        expect { post :create, place_params, { user_id: current_user.id } }.
          to change { Place.count }.by(1)
      end

      it 'associates the new place with the current user' do
        post :create, place_params, { user_id: current_user.id }

        expect(assigns(:place).user).to eq(current_user)
      end

      it 'redirect to the new place path' do
        post :create, place_params, { user_id: current_user.id }
        place = assigns(:place)

        expect(response).to redirect_to(place_path(place))
      end
    end

    context 'without valid attributes' do
      let(:place_params) { { place: { name: Faker::Name.name } } }

      it "doesn't create a new place" do
        expect { get :create, place_params, { user_id: current_user.id } }.
          to_not change { Place.count }
      end

      it 'renders the edit template' do
        get :create, place_params, { user_id: current_user.id }

        expect(response).to render_template('edit')
      end
    end
  end

  describe 'PUT .update' do
    let(:current_user) { FactoryGirl.create(:user) }
    let(:place) { FactoryGirl.create(:place, user_id: current_user.id) }

    context 'with valid params' do

      it 'updates the place' do
        old_name = place.name
        put :update, updated_place_params(place), { user_id: current_user.id }

        expect(place.reload.name).to eq(old_name + ' updated')
      end

      it 'redirect to the updated place path' do
        put :update, updated_place_params(place), { user_id: current_user.id }

        expect(response).to redirect_to(place_path(place))
      end
    end

    context 'without valid params' do
      let(:place_params) { updated_place_params(place) }

      before do
        place_params[:place][:name] = ''
      end

      it "doesn't update the place" do
        old_name = place.name
        put :update, place_params, { user_id: current_user.id }

        expect(place.reload).to eq(place)
        expect(place.name).to   eq(old_name)
      end

      it 'renders the edit template' do
        put :update, place_params, { user_id: current_user.id }

        expect(response).to render_template('edit')
      end
    end

    def updated_place_params(place)
      { id:    place.id,
        place: place.attributes.merge(name: place.name + ' updated') }
    end
  end

  describe 'DELETE .destroy' do
    let!(:current_user) { FactoryGirl.create(:user_with_places) }
    let!(:place) { current_user.places.sample }

    it 'destroys the place' do
      expect {
        delete :destroy, { id: place.id }, { user_id: current_user.id }
      }.to change { Place.count }.by(-1)
      expect(Place.where(id: place.id)).to be_empty
    end

    it 'redirects to the places path' do
      delete :destroy, { id: place.id }, { user_id: current_user.id }

      expect(response).to redirect_to(places_path)
    end
  end

  describe 'GET .import' do
    let(:current_user) { FactoryGirl.create(:user) }

    it 'Creates a job' do
      get :import, nil, { user_id: current_user.id }

      expect(ActiveJob::Base.queue_adapter.enqueued_jobs).to_not be_empty
    end

    it 'redirects to the places path' do
      get :import, nil, { user_id: current_user.id }

      expect(response).to redirect_to(places_path)
    end
  end
end

def response_body
  JSON.parse(response.body)
end
