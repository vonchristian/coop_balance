FactoryBot.define do
  factory :interest_prededuction, class: LoansModule::LoanProducts::InterestPrededuction do
    association :loan_product
    calculation_type { 'percent_based' }
    rate { 0.02 }
    amount { 0 }
    number_of_payments { 0 }
  end
end
