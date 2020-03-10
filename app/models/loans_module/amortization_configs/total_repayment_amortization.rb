module LoansModule
  module AmortizationConfigs
    class TotalRepaymentAmortization < ApplicationRecord
      enum calculation_type: [:equal_principal, :equal_payment]
      
      validates :calculation_type, presence: true 

      def total_repayment_amortizer
        ("LoansModule::TotalRepaymentAmortizers::" + calculation_type.titleize.gsub(" ", "")).constantize
      end
    end
  end 
end 
