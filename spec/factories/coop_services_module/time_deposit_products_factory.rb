FactoryBot.define do
  factory :time_deposit_product, class: "CoopServicesModule::TimeDepositProduct" do
    minimum_deposit "9.99"
    maximum_deposit "9.99"
    annual_interest_rate 2
    break_contract_fee 150
    break_contract_rate 5
    time_deposit_product_type 'for_member'
    name  { Faker::Company.catch_phrase }
    association :account, factory: :liability
    association :interest_expense_account, factory: :expense
    association :break_contract_account, factory: :revenue

  end
end
