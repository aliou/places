FactoryGirl.define do
  factory :category do
    name            { Faker::Name.name }
    foursquare_data { File.read('spec/support/fixtures/category.json') }
  end
end
