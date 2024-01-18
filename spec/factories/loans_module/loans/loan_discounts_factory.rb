FactoryBot.define do
  factory :loan_discount, class: 'LoansModule::Loans::LoanDiscount' do
    amount { 1000 }
    loan
  end
end
