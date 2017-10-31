FactoryBot.define do
  factory :loan_product, class: "LoansModule::LoanProduct" do
    sequence(:name){|n| "Loan #{n} - #{n} Loan" }
    description "MyString"
    max_loanable_amount 1000
    interest_rate 1
    association :account, factory: :asset

  end
end
