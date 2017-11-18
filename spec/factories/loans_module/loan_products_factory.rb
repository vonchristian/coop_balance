FactoryBot.define do
  factory :loan_product, class: "LoansModule::LoanProduct" do
    sequence(:name){|n| "Loan #{n} - #{n} Loan" }
    description "MyString"
    max_loanable_amount 1_000_000
    association :account, factory: :asset

  end
end
