module LoansModule
  module Loans
    class LoanInterest < ApplicationRecord
      belongs_to :loan
      belongs_to :computed_by, class_name: "User", foreign_key: 'computed_by_id'
      has_many :loan_discounts, as: :discountable, class_name: "LoansModule::Loans::LoanDiscount"

      def self.total
        sum(:amount)
      end

      def self.balance
        total - loan_discounts.total
      end
    end
  end
end
