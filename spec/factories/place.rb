FactoryGirl.define do
  factory :place do
    name                { Faker::Name.name }
    lat                 { Faker::Address.latitude }
    lng                 { Faker::Address.longitude }
    foursquare_venue_id { Faker::Internet.password }
    category            { FactoryGirl.create(:category) }
  end
end
