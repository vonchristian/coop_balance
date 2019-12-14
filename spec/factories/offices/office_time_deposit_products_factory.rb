FactoryBot.define do
  factory :office_time_deposit_product, class: Offices::OfficeTimeDepositProduct do
    association :office
    association :time_deposit_product
    association :liability_account_category, factory: :liability_level_one_account_category
    association :interest_expense_account_category, factory: :expense_level_one_account_category
    association :break_contract_account_category, factory: :revenue_level_one_account_category
    association :forwarding_account, factory: :liability
  end
end
