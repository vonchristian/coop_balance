FactoryBot.define do
  factory :store_front do
    association :cooperative
    association :cooperative_service
    sequence(:name) { |n| "Store front " +  ('a'..'z').to_a.shuffle.join }
    address         { "MyString" }
    contact_number  { "MyString" }
    association :receivable_account,            factory: :asset
    association :payable_account,               factory: :liability
    association :cost_of_goods_sold_account,    factory: :expense
    association :sales_account,                 factory: :revenue
    association :sales_return_account,          factory: :revenue
    association :sales_discount_account,        factory: :revenue
    association :merchandise_inventory_account, factory: :asset
    association :spoilage_account,              factory: :expense
    association :internal_use_account,          factory: :expense
    association :purchase_return_account,       factory: :expense
  end
end
