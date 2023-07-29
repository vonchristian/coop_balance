FactoryBot.define do
  factory :office_loan_product, class: Offices::OfficeLoanProduct do
    association :office
    association :loan_product
    association :interest_revenue_ledger, factory: :revenue_ledger
    association :penalty_revenue_ledger,  factory: :revenue_ledger
    association :loan_protection_plan_provider
    association :forwarding_account,                factory: :asset
  end
end
