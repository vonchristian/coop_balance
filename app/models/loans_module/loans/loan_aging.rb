module LoansModule
  module Loans
    class LoanAging < ApplicationRecord
      belongs_to :loan
      belongs_to :loan_aging_group

      validates :date, presence: true
      validates :loan_aging_group_id, uniqueness: { scope: :loan_id }
      
      def self.current
        order(date: :desc).first
      end
    end
  end
end
