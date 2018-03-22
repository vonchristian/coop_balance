FactoryBot.define do
  factory :store_front do
    cooperative
    name "MyString"
    address "MyString"
    contact_number "MyString"
    association :accounts_receivable_account,   factory: :asset
    association :accounts_payable_account,      factory: :liability
    association :cost_of_goods_sold_account,    factory: :expense
    association :sales_account,                 factory: :revenue
    association :sales_return_account,          factory: :revenue
    association :merchandise_inventory_account, factory: :asset
    association :spoilage_account,              factory: :expense

  end
end
