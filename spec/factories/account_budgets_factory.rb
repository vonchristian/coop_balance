FactoryBot.define do
  factory :account_budget do
    association :cooperative
    association :account, factory: :asset
    proposed_amount "9.99"
    year 1
  end
end
