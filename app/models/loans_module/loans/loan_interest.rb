module LoansModule
  module Loans
    class LoanInterest < ApplicationRecord
      belongs_to :loan
      belongs_to :computed_by, class_name: "User", foreign_key: 'computed_by_id', optional: true

      def self.total
        sum(:amount)
      end

      def self.balance
        total - loan_discounts.total
      end

    end
  end
end
