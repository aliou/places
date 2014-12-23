require 'rails_helper'

RSpec.describe HomeController do

  describe 'GET index' do

    context 'user is not connected' do
      it 'goes to the index' do
        get :index

        expect(response).to be_success
      end
    end

  end
end
