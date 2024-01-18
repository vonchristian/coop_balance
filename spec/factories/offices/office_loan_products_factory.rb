FactoryBot.define do
  factory :office_loan_product, class: 'Offices::OfficeLoanProduct' do
    office
    loan_product
    interest_revenue_ledger factory: %i[revenue_ledger]
    penalty_revenue_ledger factory: %i[revenue_ledger]
    loan_protection_plan_provider
    forwarding_account factory: %i[asset]
  end
end
