require 'rails_helper'

RSpec.describe PlacesController do
  context 'routes' do
    it { should route(:get,    '/places')  .to(action: :index) }
    it { should route(:get,    '/places/1').to(action: :show, id: 1) }
    it { should route(:post,   '/places')  .to(action: :create) }
    it { should route(:patch,  '/places/1').to(action: :update, id: 1) }
    it { should route(:put,    '/places/1').to(action: :update, id: 1) }
    it { should route(:delete, '/places/1').to(action: :destroy, id: 1) }
  end

  let!(:current_user) { FactoryGirl.create(:user_with_places) }
  let(:valid_session) { { user_id: current_user.id } }

  describe 'GET #index' do
    it 'assigns the places' do
      places = current_user.places
      get :index, { format: :json }, valid_session

      expect(assigns(:places)).to match_array(places)
    end

    it 'serializes the places' do
      places_ids = current_user.places.map &:id
      get :index, { format: :json }, valid_session

      response_ids = response_body.map { |p| p['id'] }
      expect(response_ids).to match_array(places_ids)
    end

    context 'when the format is HTML' do
      it 'renders the index template' do
        get :index, { format: :html }, valid_session

        expect(response).to render_template('index')
      end
    end

    context 'when there are filtering params' do
      let!(:valid_params) do
        { format: :json,
          origin: [48.85, 2.34],
          zoom:   MapHelper::TOWN_LEVEL_ZOOM }
      end
      let(:notre_dame) do
        FactoryGirl.create(:place, :notre_dame, user: current_user)
      end
      let(:hotel_de_ville) do
        FactoryGirl.create(:place, :hotel_de_ville, user: current_user)
      end
      let(:tour_eiffel) do
        FactoryGirl.create(:place, :tour_eiffel, user: current_user)
      end

      let!(:filtered_places) { [notre_dame, hotel_de_ville, tour_eiffel] }

      it 'assigns the filtered places' do
        get :index, valid_params, valid_session
        expect(assigns(:places)).to match_array(filtered_places)
      end
    end
  end

  describe 'GET #show' do
    let(:place) { current_user.places.sample }
    let!(:valid_params) { { format: :json, id: place.id } }

    it 'assign the place' do
      get :show, valid_params, valid_session

      expect(assigns(:place)).to eq(place)
    end

    it 'serializes the place' do
      get :show, valid_params, valid_session

      expect(response_body['id']).to eq(place.id)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) do
        { place: FactoryGirl.build(:place).attributes, format: :json }
      end

      it 'creates a new place' do
        expect { post :create, valid_params, valid_session }.
          to change { Place.count }.by(1)
      end

      it 'assigns the new place' do
        post :create, valid_params, valid_session
        expect(assigns(:place)).to be_a(Place)
        expect(assigns(:place)).to be_persisted
      end

      it 'responds with the new place' do
        post :create, valid_params, valid_session
        created_place = assigns(:place)
        expect(response_body['id']).to eq(created_place.id)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        { place: { name: Faker::Name.name }, format: :json }
      end

      it "doesn't create a new place" do
        expect { post :create, invalid_params, valid_session }.
          to_not change { Place.count }
      end

      it 'assigns a newly created but unsaved place' do
        post :create, invalid_params, valid_session
        expect(assigns(:place)).to be_a_new(Place)
      end

      it 'responds with the errors' do
        post :create, invalid_params, valid_session
        expect(response_body['errors']).to_not be_nil
        expect(response_body['errors']).to_not be_empty
      end
    end
  end

  describe 'PUT #update' do
    let(:place) { FactoryGirl.create(:place, user: current_user) }

    context 'with valid params' do
      let(:updated_name) { place.name + ' updated' }
      let!(:valid_params) do
        { id: place.id, place: { name: updated_name }, format: :json }
      end

      it 'updates the requested place' do
        patch :update, valid_params, valid_session
        place.reload
        expect(place.name).to eq(updated_name)
      end

      it 'responds with the updated place' do
        patch :update, valid_params, valid_session
        place.reload
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) do
        { id: place.id, place: { name: place.name }, format: :json }
      end

      it "doesn't update the requested placee" do
        expect { patch :update, invalid_params, valid_session; place.reload }.
          to_not change { place.name }
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:place) { FactoryGirl.create(:place, user: current_user) }
    let!(:valid_params) { { id: place.id, format: :json } }

    it 'destroys the requested place' do
      expect { delete :destroy, valid_params, valid_session }.
        to change { Place.count }.by(-1)
    end
  end
end

def response_body
  JSON.parse(response.body)
end
