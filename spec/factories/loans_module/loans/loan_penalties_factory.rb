FactoryBot.define do 
  factory :loan_penalty, class: LoansModule::Loans::LoanPenalty do 
    association :loan 
    association :employee, factory: :loan_officer 
    amount      { 100 }
    date        { Date.current }
    description { 'loan penalty' }
  end 
end 