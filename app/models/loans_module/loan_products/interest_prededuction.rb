module LoansModule
  module LoanProducts
    class InterestPrededuction < ApplicationRecord
      belongs_to :loan_product

      enum calculation_type: [:percent_based, :amount_based, :number_of_payments]

      validates :calculation_type, presence: true
      validates :rate, :amount, :number_of_payments, numericality: true

      def self.current
        order(created_at: :desc).first
      end
    end
  end
end
