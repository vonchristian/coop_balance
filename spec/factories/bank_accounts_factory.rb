FactoryBot.define do
  factory :bank_account do
    cooperative { nil }
    bank_name { "MyString" }
    bank_address { "MyString" }
    account_number { "MyString" }
    association :cash_account, factory: :asset
    association :interest_revenue_account, factory: :revenue
  end
end
