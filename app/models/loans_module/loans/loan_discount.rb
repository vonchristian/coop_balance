module LoansModule
  module Loans
    class LoanDiscount < ApplicationRecord
      enum discount_type: { interest: 0, penalty: 1 }
      belongs_to :loan

      def self.total
        sum(:amount)
      end
    end
  end
end
