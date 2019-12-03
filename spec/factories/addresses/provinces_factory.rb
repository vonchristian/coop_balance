FactoryBot.define do
  factory :province, class: Addresses::Province do
    name { Faker::Address.street_name }
  end
end
