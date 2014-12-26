require 'rails_helper'

RSpec.describe ApplicationController do
  describe 'authenticate!' do

    controller(ApplicationController) do
      def index
      end
    end

    context 'the user is not connected' do
      it 'redirects to the root_path' do
        get :index

        expect(response).to redirect_to(root_path)
      end
    end

  end
end
