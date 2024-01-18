module LoansModule
  module AmortizationConfigs
    class TotalRepaymentAmortization < ApplicationRecord
      enum calculation_type: { equal_principal: 0, equal_payment: 1 }

      validates :calculation_type, presence: true

      def total_repayment_amortizer
        "LoansModule::TotalRepaymentAmortizers::#{calculation_type.titleize.delete(' ')}".constantize
      end
    end
  end
end
