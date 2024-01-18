module LoansModule
  module AmortizationConfigs
    class InterestAmortization < ApplicationRecord
      enum calculation_type: { straight_line: 0, declining_balance: 1 }

      validates :calculation_type, presence: true

      def interest_amortizer
        "LoansModule::InterestAmortizers::#{calculation_type.titleize.delete(' ')}".constantize
      end
    end
  end
end
