FactoryBot.define do
  factory :barangay, class: Addresses::Barangay do
    name { Faker::Address.street_name }
    association :municipality
  end
end
