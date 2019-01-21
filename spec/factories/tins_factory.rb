FactoryBot.define do
  factory :tin do
    number { Faker::Number.number(14) }
    tinable { nil }
  end
end
