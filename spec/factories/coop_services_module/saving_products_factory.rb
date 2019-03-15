FactoryBot.define do
  factory :saving_product, class: "CoopServicesModule::SavingProduct" do
    interest_rate   { 0.02 }
    interest_recurrence { 'quarterly' }
    minimum_balance { 1_000 }
    sequence(:name) { |n| "#{n}"}
    association :cooperative
    association :account, factory: :liability
    association :interest_expense_account, factory: :expense
    association :closing_account, factory: :revenue


  end
end
