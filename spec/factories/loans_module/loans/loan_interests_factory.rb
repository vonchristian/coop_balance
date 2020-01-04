FactoryBot.define do
  factory :loan_interest, class: LoansModule::Loans::LoanInterest do
    association :loan
    association :employee, factory: :loan_officer
    date        { Date.current }
    description { 'loan interests' }
    amount      { 100 }


  end
end
