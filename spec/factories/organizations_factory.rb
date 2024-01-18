FactoryBot.define do
  factory :organization do
    name { Faker::Company.bs }
    cooperative
  end
end
