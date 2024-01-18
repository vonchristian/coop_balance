FactoryBot.define do
  factory :office_loan_product_aging_group, class: 'LoansModule::OfficeLoanProductAgingGroup' do
    office_loan_product
    loan_aging_group
    receivable_ledger factory: %i[asset_ledger]
  end
end
