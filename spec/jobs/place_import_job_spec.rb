require 'rails_helper'

RSpec.describe PlaceImportJob do
  include ActiveJob::TestHelper

  let(:auth) { stub_auth }

  it "imports the user's place after user creation" do
    User.from_omniauth(auth)

    expect(ActiveJob::Base.queue_adapter.enqueued_jobs).to_not be_empty
  end

  def stub_auth
    stub_oauth(uid: ENV['FOURSQUARE_USER_ID'], token: Faker::Internet.password)
  end
end
