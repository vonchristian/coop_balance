FactoryBot.define do
  factory :loan_penalty, class: 'LoansModule::Loans::LoanPenalty' do
    loan
    employee factory: %i[loan_officer]
    amount      { 100 }
    date        { Date.current }
    description { 'loan penalty' }
  end
end