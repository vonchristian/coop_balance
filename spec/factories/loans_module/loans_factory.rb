FactoryBot.define do
  factory :loan, class: "LoansModule::Loan" do
    association :borrower, factory: :member
    loan_product
    loan_amount 100_000
    application_date Date.today
    term 12
  end
end
