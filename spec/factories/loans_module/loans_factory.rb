FactoryGirl.define do
  factory :loan, class: "LoansModule::Loan" do
    member
    loan_product nil
    loan_amount "9.99"
    application_date "2017-06-06 17:11:01"
  end
end
