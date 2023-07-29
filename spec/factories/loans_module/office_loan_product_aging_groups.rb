FactoryBot.define do
  factory :office_loan_product_aging_group, class: LoansModule::OfficeLoanProductAgingGroup do
    association :office_loan_product
    association :loan_aging_group
    association :receivable_ledger, factory: :asset_ledger
  end
end
