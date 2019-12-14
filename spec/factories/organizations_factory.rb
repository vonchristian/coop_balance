FactoryBot.define do
  factory :organization do
    name { Faker::Company.bs }
  end
end 
