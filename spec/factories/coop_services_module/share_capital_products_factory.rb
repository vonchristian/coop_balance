FactoryBot.define do
  factory :share_capital_product, class: "CoopServicesModule::ShareCapitalProduct" do
    name { Faker::Name.unique.name }
    cost_per_share 100
    closing_account_fee 150
    has_closing_account_fee true
    association :paid_up_account, factory: :equity
    association :closing_account, factory: :revenue
    association :subscription_account, factory: :equity

  end
end
