FactoryBot.define do
  factory :loan, class: LoansModule::Loan do
    association :loan_product
    association :borrower, factory: :member
  end
end
