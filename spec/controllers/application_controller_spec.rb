require 'rails_helper'

RSpec.describe ApplicationController do
  it { should use_before_filter(:authenticate!) }

  describe 'authenticate!' do
    controller do
      def index
      end
    end

    context 'the user is not connected' do
      it 'redirects to the root_path' do
        get :index
        expect(response).to redirect_to(root_path)
      end

      it 'shows an error flash message' do
        get :index
        expect(flash[:error]).to be_present
        expect(flash[:error]).to eq(I18n.t('application.authenticate.error'))
      end

      # TODO: Find the name resource for the index action of the anonymous
      # controller.
      it 'saves the request path in the session' do
        get :index
        expect(session[:redirect_to]).to eq('/anonymous')
      end
    end
  end
end
