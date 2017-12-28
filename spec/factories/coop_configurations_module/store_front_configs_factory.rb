FactoryBot.define do
  factory :store_front_config, class: "CoopConfigurationsModule::StoreFrontConfig" do
    association :cost_of_goods_sold_account, factory: :expense
    association :accounts_receivable_account, factory: :asset
    association :merchandise_inventory_account, factory: :asset
    association :sales_account, factory: :asset

  end
end
