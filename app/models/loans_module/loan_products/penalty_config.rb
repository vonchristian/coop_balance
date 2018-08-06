module LoansModule
  module LoanProducts
    class PenaltyConfig < ApplicationRecord
      belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
      belongs_to :penalty_revenue_account, class_name: "AccountingModule::Account", foreign_key: 'penalty_revenue_account_id'

      def self.current
        order(created_at: :desc).first
      end

      def daily_rate
        rate / 30.0
      end
    end
  end
end
