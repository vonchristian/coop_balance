module LoansModule
  module LoanProducts
    class PenaltyConfig < ApplicationRecord
      belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
      belongs_to :penalty_revenue_account, class_name: "AccountingModule::Account", foreign_key: 'penalty_revenue_account_id'

      def self.current
        order(created_at: :desc).first
      end

      def self.penalty_revenue_accounts
        AccountingModule::Account.where(id: self.pluck(:penalty_revenue_account_id))
      end

      def daily_rate
        rate / 30.0
      end
      def rate_in_percent
        rate * 100
      end
    end
  end
end
