module LoansModule
  module Loans
    class LoanPenalty < ApplicationRecord
      belongs_to :loan
      belongs_to :computed_by, class_name: "User", foreign_key: 'computed_by_id', optional: true

      def self.total
        sum(:amount)
      end

    end
  end
end
