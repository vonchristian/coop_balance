FactoryBot.define do
  factory :saving_product, class: "CoopServicesModule::SavingProduct" do
    sequence(:name) { |n| "Saving Product " +  ('a'..'z').to_a.shuffle.join }
    interest_rate { "9.99" }
    interest_recurrence { 1 }
    association :account, factory: :liability
    association :interest_expense_account, factory: :expense
    association :closing_account, factory: :revenue
    association :cooperative
    minimum_balance { 100 }
  end
end
