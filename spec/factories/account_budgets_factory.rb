FactoryBot.define do 
  factory :account_budget do 
    association :cooperative
    association :account, factory: :revenue
    proposed_amount { 100_000 }
    year { Date.current.year }
  end 
end 
