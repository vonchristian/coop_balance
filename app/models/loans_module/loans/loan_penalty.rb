module LoansModule
  module Loans
    class LoanPenalty < ApplicationRecord
      belongs_to :loan
      belongs_to :employee, class_name: "User", foreign_key: 'computed_by_id', optional: true
      delegate :name, to: :employee, prefix: true

      def self.total_amount
        sum(:amount)
      end

    end
  end
end
