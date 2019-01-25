module LoansModule
  module LoanProducts
    class InterestPrededuction < ApplicationRecord
      belongs_to :loan_product

      enum calculation_type: [:percent_based, :amount_based, :number_of_payments_based]
      enum prededuction_scope: [:on_first_year]
      validates :calculation_type, presence: true
      validates :rate, :amount, :number_of_payments, numericality: true

      def self.current
        order(created_at: :desc).first
      end
      def rate_in_percent
        rate * 1_00
      end


      def calculator
        ("LoansModule::InterestPredeductionCalculators::" + calculation_type.titleize.gsub(" ", "")).constantize
      end
    end
  end
end
