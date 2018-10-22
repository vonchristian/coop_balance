FactoryBot.define do
  factory :time_deposit_product, class: "CoopServicesModule::TimeDepositProduct" do
    minimum_deposit "9.99"
    maximum_deposit "9.99"
    interest_rate 0.05
    break_contract_fee 150
    break_contract_rate 5
    name  { Faker::Company.catch_phrase }
    association :account, factory: :liability
    association :interest_expense_account, factory: :expense
    association :break_contract_account, factory: :revenue

  end
end
