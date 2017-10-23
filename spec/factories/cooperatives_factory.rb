FactoryBot.define do
  factory :cooperative do
    name                  { Faker::Bank.unique.name }
    registration_number   { Faker::Business.unique.credit_card_number }
  end
end
