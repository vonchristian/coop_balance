FactoryBot.define do
  factory :share_capital_product, class: CoopServicesModule::ShareCapitalProduct do
    association :cooperative
    association :equity_account, factory: :equity
    name { Faker::Company.bs }
    cost_per_share { 50 }
  end
end
