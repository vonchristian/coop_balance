FactoryBot.define do
  factory :office_time_deposit_product, class: Offices::OfficeTimeDepositProduct do
    association :office
    association :time_deposit_product
    association :liability_ledger, factory: :liability_ledger
    association :interest_expense_ledger, factory: :expense_ledger
    association :break_contract_revenue_ledger, factory: :revenue_ledger
    association :forwarding_account, factory: :liability
  end
end
