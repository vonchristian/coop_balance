FactoryBot.define do
  factory :loan, class: LoansModule::Loan do
    association :borrower, factory: :member
    association :loan_product, factory: :loan_product_with_interest_config
    loan_amount 100_000
    application_date Date.today
    term 12

    factory :loan_with_interest_on_loan_charge, class: LoansModule::Loan do |loan|
      loan_amount 100_000
      application_date Date.today
      term 12
      association :loan_product, factory: :loan_product_with_interest_config
      after(:build) do |loan|
        charge = create(:interest_on_loan_charge, account: loan.loan_product_unearned_interest_income_account)
        create(:loan_charge, charge: charge, loan: loan)
      end
    end
  end
end
