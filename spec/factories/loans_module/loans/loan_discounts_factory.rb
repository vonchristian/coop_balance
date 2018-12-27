FactoryBot.define do
  factory :loan_discount, class: LoansModule::Loans::LoanDiscount do
    association :loan
    amount { 1000 }
    date { Date.today }
    description { "Loan interest" }
    association :computed_by, factory: :employee

    factory :loan_interest_discount, class: LoansModule::Loans::LoanDiscount do
      discount_type { 'interest' }
    end

    factory :loan_penalty_discount, class: LoansModule::Loans::LoanDiscount do
      discount_type { 'penalty' }
    end
  end
end
