module LoansModule
  module LoanProducts
    class PenaltyConfig < ApplicationRecord
      belongs_to :loan_product, class_name: "LoansModule::LoanProduct"

      def self.current
        order(created_at: :desc).first
      end

      def self.penalty_revenue_accounts
        AccountingModule::Account.where(id: pluck(:penalty_revenue_account_id))
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
