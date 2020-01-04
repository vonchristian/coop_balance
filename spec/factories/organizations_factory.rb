FactoryBot.define do
  factory :organization do
    name { Faker::Company.bs }
    association :cooperative
  end
end
