FactoryBot.define do
  factory :share_capital_product, class: "CoopServicesModule::ShareCapitalProduct" do
    name { Faker::Name.unique.name }
    cost_per_share 100
    association :paid_up_account, factory: :equity
    association :subscription_account, factory: :equity

  end
end
