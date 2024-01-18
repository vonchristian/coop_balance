module LoansModule
  class AmortizationType < ApplicationRecord
    enum calculation_type: { straight_line: 0, declining_balance: 1, ipsmpc_amortizer: 2 }
    enum repayment_calculation_type: { equal_principal: 0, equal_payment: 1 }
    enum interest_amortization_scope: { exclude_on_first_year: 0 }
    validates :calculation_type, :repayment_calculation_type, presence: true

    def amortizer
      "LoansModule::Amortizers::#{calculation_type.titleize.pluralize.delete(' ')}::#{repayment_calculation_type.titleize.delete(' ')}".constantize
    end

    def repayment_calculator
      "LoansModule::Amortizers::RepaymentCalculators::#{repayment_calculation_type.titleize.delete(' ')}".constantize
    end

    def amortizeable_principal_calculator
      "LoansModule::Amortizers::PrincipalCalculators::#{repayment_calculation_type.titleize.delete(' ')}".constantize
    end
  end
end
