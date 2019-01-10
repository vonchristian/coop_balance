FactoryBot.define do
  factory :interest_prededuction, class: LoansModule::LoanProducts::InterestPrededuction do
    loan_product 
    calculation_type { 1 }
    rate { "9.99" }
    amount { "9.99" }
    number_of_payments { 1 }
  end
end
