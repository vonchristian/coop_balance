FactoryBot.define do
  factory :interest_config, class: LoansModule::LoanProducts::InterestConfig do
    association :loan_product
    association :interest_revenue_account, factory: :revenue
    association :unearned_interest_income_account, factory: :revenue
    association :accrued_income_account, factory: :asset
    association :cooperative
    rate { 0.18 }
  end
end
