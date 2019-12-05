FactoryBot.define do
  factory :program, class: Cooperatives::Program do
    name   { Faker::Name.name }
    amount { 500 }
    association :level_one_account_category, factory: :liability_level_one_account_category
    association :cooperative
    payment_schedule_type { 'annually' }
  end
end
