FactoryBot.define do
  factory :interest_config, class: "LoansModule::InterestConfig" do
    loan_product nil
    earned_interest_income_account nil
    interest_receivable_account nil
    unearned_interest_income_account nil
    rate "9.99"
  end
end
