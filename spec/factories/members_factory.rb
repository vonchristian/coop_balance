FactoryBot.define do
  factory :member do
    first_name  { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    code        { SecureRandom.uuid }
  end
end
