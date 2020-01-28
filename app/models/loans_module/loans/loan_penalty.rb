module LoansModule
  module Loans
    class LoanPenalty < ApplicationRecord
      belongs_to :loan
      belongs_to :employee, class_name: "User", foreign_key: 'computed_by_id'
    
      delegate :name, to: :employee, prefix: true
      
      validates :date, :description, presence: true
      validates :amount, presence: true, numericality: true 
      
      def self.total_amount
        sum(:amount)
      end

    end
  end
end
