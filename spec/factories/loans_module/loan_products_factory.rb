FactoryBot.define do
  factory :loan_product, class: "LoansModule::LoanProduct" do
    name "MyString"
    description "MyString"
    interest_recurrence 1
    max_loanable_amount 1000
    interest_rate 1
    account

  end
end
