FactoryBot.define do
  factory :banking_agent do
    name { "MyString" }
    account_number { "MyString" }
    association :depository_account, factory: :liability
  end
end
