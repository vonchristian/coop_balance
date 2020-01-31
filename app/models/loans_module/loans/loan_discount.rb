module LoansModule
  module Loans
    class LoanDiscount < ApplicationRecord
      enum discount_type: [:interest, :penalty]
      belongs_to :loan

      def self.total
        sum(:amount)
      end
    end
  end
end
