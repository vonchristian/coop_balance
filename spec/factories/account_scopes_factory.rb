FactoryBot.define do
  factory :account_scope do
    association :scopeable, factory: :organization
    association :account, factory: :saving
  end
end
