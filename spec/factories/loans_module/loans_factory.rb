FactoryBot.define do
  factory :loan, class: "LoansModule::Loan" do
    association :borrower, factory: :member
    loan_product
    loan_amount 100_000
    application_date "2017-06-06 17:11:01"
    term 12
  end
end
