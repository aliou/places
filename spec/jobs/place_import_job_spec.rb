require 'rails_helper'

RSpec.describe PlaceImportJob do
  let(:auth) { stub_auth }

  it "imports the user's place after user creation" do
    User.from_omniauth(auth)

    expect(ActiveJob::Base.queue_adapter.enqueued_jobs).to_not be_empty
  end

  describe '.perform' do
    let (:user) { FactoryGirl.create(:user) }

    around do |example|
      VCR.use_cassette('place_import_job.import') do
        example.run
      end
    end

    it 'imports the user places' do
      expect { PlaceImportJob.perform_now(user) }.to change { Place.count }
    end
  end
end

def stub_auth
  stub_oauth(uid: ENV['FOURSQUARE_USER_ID'], token: Faker::Internet.password)
end
