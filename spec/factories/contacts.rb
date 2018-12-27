FactoryBot.define do
  factory :contact do
    contactable { nil }
    number  { Faker::Number.number(11) }
  end
end
