module LoansModule
  module LoanProducts
    class PenaltyConfig < ApplicationRecord
      belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
      belongs_to :penalty_revenue_account, class_name: "AccountingModule::Account", foreign_key: 'penalty_revenue_account_id'
      belongs_to :penalty_receivable_account, class_name: "AccountingModule::Account", foreign_key: 'penalty_receivable_account_id'
      belongs_to :penalty_discount_account, class_name: "AccountingModule::Account", foreign_key: 'penalty_discount_account_id'

      def self.current
        order(created_at: :desc).first
      end
    end
  end
end
