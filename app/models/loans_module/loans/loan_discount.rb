module LoansModule
  module Loans
    class LoanDiscount < ApplicationRecord
      enum discount_type: [:interest, :penalty]
      belongs_to :loan
      belongs_to :computed_by, class_name: "User", foreign_key: 'computed_by_id'

      def self.total
        sum(:amount)
      end
    end
  end
end