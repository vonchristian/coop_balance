FactoryBot.define do
  factory :bank_account do
    cooperative nil
    bank_name "MyString"
    bank_address "MyString"
    account_number "MyString"
    association :account, factory: :asset
    association :earned_interest_account, factory: :revenue
  end
end
