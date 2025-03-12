module LoansModule
  module LoanProducts
    class Charge < ApplicationRecord
      self.table_name = "loan_product_charges"

      enum :charge_type, { amount_based: 0, percent_based: 1 }
      belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
      belongs_to :account,      class_name: "AccountingModule::Account"
      validates :name, :amount, :rate, presence: true
      validates :rate, :amount, numericality: true

      def self.except_capital_build_up
        where.not(account: DepositsModule::ShareCapital.equity_accounts)
      end

      def self.for_capital_build_up
        where(account: DepositsModule::ShareCapital.equity_accounts)
      end

      def charge_amount(chargeable_amount: nil)
        return amount if amount_based?

        rate * chargeable_amount
      end
    end
  end
end
