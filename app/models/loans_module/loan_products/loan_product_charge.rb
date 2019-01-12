module LoansModule
  module LoanProducts
    class LoanProductCharge < ApplicationRecord
      enum charge_type: [:amount_based, :percent_based]
      belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
      belongs_to :account, class_name: "AccountingModule::Account"
      validates :name, :account_id, :amount, :rate, presence: true
      validates :rate, :amount, numericality: true

      def charge_amount(loan_amount)
        rate * amount
      end
    end
  end
end
