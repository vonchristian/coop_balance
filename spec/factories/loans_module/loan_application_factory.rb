FactoryBot.define do
  factory :loan_application, class: LoansModule::LoanApplication do
    association :borrower, factory: :member
    association :loan_product, factory: :loan_product_with_interest_config
    association :cooperative
    loan_amount 100_000
    application_date Date.today
  end
end
