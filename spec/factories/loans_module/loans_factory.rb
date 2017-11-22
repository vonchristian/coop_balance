FactoryBot.define do
  factory :loan, class: "LoansModule::Loan" do
    association :borrower, factory: :member
    loan_product
    loan_amount 100_000
    application_date nil
    term 12
    loan_status nil
  end
end
