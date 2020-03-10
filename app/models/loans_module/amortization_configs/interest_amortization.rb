module LoansModule
  module AmortizationConfigs 
    class InterestAmortization < ApplicationRecord
      enum calculation_type: [:straight_line, :declining_balance]
      
      validates :calculation_type, presence: true 

      def interest_amortizer
        ("LoansModule::InterestAmortizers::" + calculation_type.titleize.gsub(" ", "")).constantize
      end 
      
    end
  end 
end 
