FactoryBot.define do
  factory :saving, class: MembershipsModule::Saving do
    association :depositor, factory: :member
    association :saving_product
    association :liability_account, factory: :liability
    association :interest_expense_account, factory: :expense
    account_number { SecureRandom.uuid }
  end
end
