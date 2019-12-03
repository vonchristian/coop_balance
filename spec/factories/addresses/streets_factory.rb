FactoryBot.define do
  factory :street, class: Addresses::Street do
    name { Faker::Address.street_name }
    association :barangay
    association :municipality
  end
end
