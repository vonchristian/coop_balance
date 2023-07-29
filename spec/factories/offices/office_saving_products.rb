FactoryBot.define do
  factory :office_saving_product, class: Offices::OfficeSavingProduct do
    association :liability_ledger, factory: :liability_ledger
    association :interest_expense_ledger, factory: :expense_ledger
    association :office
    association :forwarding_account, factory: :liability
    association :saving_product
  end
end
