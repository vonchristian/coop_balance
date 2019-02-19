FactoryBot.define do
  factory :cooperative do
    name                { Faker::Name.name }
    address             { Faker::Address.full_address }
    abbreviated_name    { Faker::Name.name }
    registration_number { Faker::Number.number(12) }
  end
end
