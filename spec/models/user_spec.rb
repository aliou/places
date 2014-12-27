require 'rails_helper'

RSpec.describe User do
  include ActiveJob::TestHelper

  it { should have_many(:places) }
  it { should validate_presence_of :provider }
  it { should validate_presence_of :oauth_token }
  it { should validate_presence_of :uid }
  it { should validate_uniqueness_of :uid }
  it { should validate_inclusion_of(:uid).
       in_array([ENV['FOURSQUARE_USER_ID']]) }

  describe '.from_omniauth' do
    context "the user doesn't exist" do
      let(:auth) { stub_oauth(
        uid:   ENV['FOURSQUARE_USER_ID'],
        token: Faker::Internet.password
      )}

      before do
        clear_enqueued_jobs
      end

      it 'creates a new user' do
        user = User.from_omniauth(auth)

        expect(user).to be_valid
      end

      it "imports the user's places in a job" do
        user = User.from_omniauth(auth)

        expect(ActiveJob::Base.queue_adapter.enqueued_jobs).to_not be_empty
      end
    end

    context 'the user exists' do
      let!(:auth) { stub_oauth(
        uid:   ENV['FOURSQUARE_USER_ID'],
        token: Faker::Internet.password
      )}
      let!(:existing_user) { User.from_omniauth(auth) }

      it 'returns the existing user' do
        user = User.from_omniauth(auth)

        expect(user).to eq(existing_user)
      end

      it "doesn't create a new user" do
        expect { User.from_omniauth(auth) }.to_not change { User.count }
      end
    end
  end
end
