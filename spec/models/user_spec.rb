require 'rails_helper'

RSpec.describe User do
  include ActiveJob::TestHelper

  it { should have_many(:places) }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :oauth_token }
  it { should validate_inclusion_of(:uid).
       in_array([ENV['FOURSQUARE_USER_ID']]) }

  describe '#find_or_create_with_omniauth' do
    context "the user doesn't exist" do

      let(:auth) { stub_oauth(
        uid:   ENV['FOURSQUARE_USER_ID'],
        token: Faker::Internet.password
      )}

      before do
        clear_enqueued_jobs
      end

      it 'creates a new user' do
        user = User.find_or_create_with_omniauth(auth)

        expect(user).to be_valid
      end

      it "imports the user's places in a job" do
        user = User.find_or_create_with_omniauth(auth)

        expect(ActiveJob::Base.queue_adapter.enqueued_jobs).to_not be_empty
      end
    end
  end
end
