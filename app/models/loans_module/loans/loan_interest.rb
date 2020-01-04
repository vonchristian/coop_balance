module LoansModule
  module Loans
    class LoanInterest < ApplicationRecord
      belongs_to :loan
      belongs_to :employee, class_name: "User", foreign_key: 'computed_by_id'
      validates :description, :date, :amount, presence: true
      validates :amount, numericality: true

      delegate :name, to: :employee, prefix: true

      def self.total_interests
        sum(:amount)
      end

      def self.balance
        total_interests -
        total_interest_discounts.total -
        total_interest_payments
      end

      def self.total_interest_payments
        interest_revenue_accounts.balance
      end

      def self.total_interests
        sum(:amount)
      end
    end
  end
end
