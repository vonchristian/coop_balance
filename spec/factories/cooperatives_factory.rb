FactoryBot.define do
  factory :cooperative do
    name                  { Faker::Bank.name }
    registration_number   { Faker::Business.credit_card_number }
  end
end
