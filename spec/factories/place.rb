FactoryGirl.define do
  factory :place do
    name                { Faker::Name.name }
    lat                 { Faker::Address.latitude }
    lng                 { Faker::Address.longitude }
    foursquare_venue_id { Faker::Internet.password }
    category            { FactoryGirl.create(:category) }

    trait :notre_dame do
      lat 48.8530
      lng 2.3498
    end

    trait :hotel_de_ville do
      lat 48.856389
      lng 2.352222
    end

    trait :tour_eiffel do
      lat 48.858222
      lng 2.2945
    end

    trait :louvre do
      lat 48.860339
      lng 2.337599
    end
  end
end
