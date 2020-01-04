FactoryBot.define do
  factory :loan_discount, class: LoansModule::Loans::LoanDiscount do
    amount { 1000 }
    association :loan
    association :discountable, factory: :loan_interest
    association :computed_by, factory: :loan_officer
  end
end 
