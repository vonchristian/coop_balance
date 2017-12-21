FactoryBot.define do
  factory :loan_product, class: "LoansModule::LoanProduct" do
    sequence(:name){|n| "Loan #{n} - #{n} Loan" }
    description "MyString"
    maximum_loanable_amount 1_000_000
    association :account, factory: :asset
    association :interest_account, factory: :asset
    association :penalty_account, factory: :asset
    interest_rate 12
    penalty_rate 2
  end
end
