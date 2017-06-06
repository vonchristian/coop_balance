FactoryGirl.define do
  factory :account do
    name   { Faker::Company.name }
    code   { Faker::Bitcoin.address }
    contra false
    type ""
  end
end
