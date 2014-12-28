FactoryGirl.define do
  factory :user do
    uid         { ENV['FOURSQUARE_USER_ID'] }
    oauth_token { ENV['FOURSQUARE_USER_TOKEN'] }
    provider    'foursquare'
  end
end
