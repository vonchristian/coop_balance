FactoryBot.define do
  factory :municipality, class: Addresses::Municipality do
    name { Faker::Address.street_name }
    association :province
  end
end
