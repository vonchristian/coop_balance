module LoansModule
  class AmortizationType < ApplicationRecord
    enum calculation_type: [:straight_line, :declining_balance]
    enum repayment_calculation_type: [:equal_principal, :equal_payment]

    validates :calculation_type, :repayment_calculation_type, presence: true

    def amortizer
      ("LoansModule::Amortizers::" + calculation_type.titleize.gsub(" ", "")).constantize
    end
    def repayment_calculator
      ("LoansModule::Amortizers::TotalAmountCalculators::" + repayment_calculation_type.titleize.gsub(" ", "")).constantize
    end
    def amortizeable_principal_calculator
      ("LoansModule::Amortizers::PrincipalCalculators::" + repayment_calculation_type.titleize.gsub(" ", "")).constantize
    end
  end
end
