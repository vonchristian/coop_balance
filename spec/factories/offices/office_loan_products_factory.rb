FactoryBot.define do
  factory :office_loan_product, class: Offices::OfficeLoanProduct do
    association :office
    association :loan_product
    association :interest_revenue_account_category, factory: :revenue_level_one_account_category
    association :penalty_revenue_account_category,  factory: :revenue_level_one_account_category
    association :loan_protection_plan_provider
    association :forwarding_account,                factory: :asset
  end
end
