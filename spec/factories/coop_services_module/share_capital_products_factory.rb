FactoryBot.define do
  factory :share_capital_product, class: "CoopServicesModule::ShareCapitalProduct" do
    name { Faker::Name.unique.name }
    cost_per_share 100
    association :account, factory: :equity
  end
end
