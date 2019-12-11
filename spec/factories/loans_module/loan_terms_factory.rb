FactoryBot.define do
  factory :loan_term, class: LoansModule::Loans::LoanTerm do
    association :loan
    association :term
  end
end
