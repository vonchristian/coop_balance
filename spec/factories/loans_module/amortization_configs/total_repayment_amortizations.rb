FactoryBot.define do
  factory :total_repayment_amortization, class: LoansModule::AmortizationConfigs::TotalRepaymentAmortization do
    calculation_type { 1 }

    factory :equal_principal_total_repayment_amortization, class: LoansModule::AmortizationConfigs::TotalRepaymentAmortization do
      calculation_type { "equal_principal" }
    end
  end
end
