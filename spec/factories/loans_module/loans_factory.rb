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
      loan.after(:build) do |t|
        charge = create(:interest_on_loan_charge, account: t.loan_product_unearned_interest_income_account)
        t.loan_charges << create(:loan_charge, charge: charge)
      end
    end
  end
end
