FactoryBot.define do
  factory :savings_account_aging, class: SavingsModule::SavingsAccountAging do
    association :savings_account, factory: :saving
    association :savings_aging_group 
    date { Date.current }
  end
end
