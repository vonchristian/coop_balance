FactoryBot.define do
  factory :share_capital_product, class: CoopServicesModule::ShareCapitalProduct do
    association :cooperative
    association :equity_account,           factory: :equity
    association :interest_payable_account, factory: :equity
    association :transfer_fee_account,     factory: :revenue
    transfer_fee   { 100 }
    name           { Faker::Company.bs }
    cost_per_share { 50 }
  end
end
