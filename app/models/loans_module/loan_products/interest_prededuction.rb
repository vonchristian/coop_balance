module LoansModule
  module LoanProducts
    class InterestPrededuction < ApplicationRecord
      belongs_to :loan_product

      enum :calculation_type, { percent_based: 0, amount_based: 1, number_of_payments_based: 2 }
      enum :prededuction_scope, { on_first_year: 0 }
      validates :calculation_type, presence: true
      validates :rate, :amount, :number_of_payments, numericality: true

      def self.current
        order(created_at: :desc).first
      end

      def rate_in_percent
        rate * 100
      end

      def calculator
        "LoansModule::InterestPredeductionCalculators::#{calculation_type.titleize.delete(' ')}".constantize
      end
    end
  end
end
