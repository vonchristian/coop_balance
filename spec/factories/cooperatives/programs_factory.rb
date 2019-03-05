FactoryBot.define do
  factory :program, class: Cooperatives::Program do
    name   { Faker::Name.name }
    amount { 500 }
    association :account, factory: :liability
    association :cooperative
  end
end
