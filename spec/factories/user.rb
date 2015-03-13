FactoryGirl.define do
  factory :user do
    uid         { ENV['FOURSQUARE_USER_ID'] }
    oauth_token { ENV['FOURSQUARE_USER_TOKEN'] }
    provider    'foursquare'

    factory :user_with_places do
      transient do
        places_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:place, evaluator.places_count, user: user)
      end
    end
  end
end
