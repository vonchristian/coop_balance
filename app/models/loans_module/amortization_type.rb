module LoansModule
  class AmortizationType < ApplicationRecord
    enum calculation_type: [:straight_line, :declining_balance, :ipsmpc_amortizer]
    enum repayment_calculation_type: [:equal_principal, :equal_payment]
    enum interest_amortization_scope: [:exclude_on_first_year]
    validates :calculation_type, :repayment_calculation_type, presence: true

    def amortizer
      ("LoansModule::Amortizers::" + calculation_type.titleize.pluralize.gsub(" ", "") + "::" + repayment_calculation_type.titleize.gsub(" ", "")).constantize
    end

    def repayment_calculator
      ("LoansModule::Amortizers::RepaymentCalculators::" + repayment_calculation_type.titleize.gsub(" ", "")).constantize
    end

    def amortizeable_principal_calculator
      ("LoansModule::Amortizers::PrincipalCalculators::" + repayment_calculation_type.titleize.gsub(" ", "")).constantize
    end
    
  end
end
