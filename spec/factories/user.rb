FactoryGirl.define do
  factory :user do
    uid         { ENV['FOURSQUARE_USER_ID'] }
    oauth_token { Faker::Internet.password }
    provider    'foursquare'
  end
end
