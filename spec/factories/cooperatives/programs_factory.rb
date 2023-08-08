FactoryBot.define do
  factory :program, class: Cooperatives::Program do
    name   { Faker::Name.name }
    amount { 500 }
    association :cooperative
    payment_schedule_type { 'annually' }
  end
end
