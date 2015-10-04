FactoryGirl.define do
  factory :identity do
    uid { Faker::Internet.password }
    oauth_token { Faker::Internet.password }
    provider { Identity::PROVIDERS.sample }
  end
end
