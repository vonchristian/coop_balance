FactoryBot.define do
  factory :loan_interest, class: LoansModule::Loans::LoanInterest do
    association :loan
    amount 1000
    date Date.today
    description "Loan interest"
    association :computed_by, factory: :employee
  end
end
