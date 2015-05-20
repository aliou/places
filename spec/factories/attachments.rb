FactoryGirl.define do
  factory :attachment do
    url  { Faker::Internet.url }
    type { Attachment::ATTACHMENT_TYPES.sample }
  end
end
