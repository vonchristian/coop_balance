FactoryBot.define do
  factory :amortization_type, class: LoansModule::AmortizationType do
    calculation_type { 'straight_line' }
    repayment_calculation_type { 'equal_principal' }

    factory :equal_payment_amortization_type, class: LoansModule::AmortizationType do 
      repayment_calculation_type { 'equal_payment' }
    end

    factory :equal_principal_amortization_type, class: LoansModule::AmortizationType do 
      repayment_calculation_type { 'equal_principal' }
    end

    factory :declining_balance_amortization_type, class: LoansModule::AmortizationType do 
      calculation_type { 'declining_balance' }
    end
  end
end 
