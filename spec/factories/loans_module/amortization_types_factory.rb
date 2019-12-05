FactoryBot.define do
  factory :amortization_type, class: LoansModule::AmortizationType do
    calculation_type { 'straight_line' }
    repayment_calculation_type { 'equal_principal' }
  end
end 
