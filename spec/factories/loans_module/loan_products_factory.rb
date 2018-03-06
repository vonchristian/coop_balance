FactoryBot.define do
  factory :loan_product, class: "LoansModule::LoanProduct" do
    sequence(:name){|n| "Loan #{n} - #{n} Loan" }
    description "MyString"
    maximum_loanable_amount 1_000_000
    association :loans_receivable_current_account, factory: :asset
    association :loans_receivable_past_due_account, factory: :asset

  end
end
