FactoryBot.define do
  factory :interest_config, class: "LoansModule::LoanProducts::InterestConfig" do
    loan_product nil

    association :unearned_interest_income_account, factory: :asset
    association :interest_revenue_account, factory: :asset
    rate 0.12
  end
end
