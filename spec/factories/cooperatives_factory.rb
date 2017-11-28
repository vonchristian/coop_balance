FactoryBot.define do
  factory :cooperative do
    sequence(:name) { |n| "Cooperative " +  ('a'..'z').to_a.shuffle.join }
    registration_number   { Faker::Business.credit_card_number }
  end
end
