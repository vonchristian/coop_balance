FactoryBot.define do
  factory :loan_product_interest, class: "LoansModule::LoanProductInterest" do
    rate { 12 }
    loan_product
    association :account, factory: :revenue
  end
end
