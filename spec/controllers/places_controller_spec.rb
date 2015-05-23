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

  let(:current_user) { FactoryGirl.create(:user_with_places) }
  let(:valid_session) { { user_id: current_user.id } }
end

def response_body
  JSON.parse(response.body)
end
