module LoansModule
  module LoanProducts
    class LoanProductCharge < ApplicationRecord
      enum charge_type: [:amount_based, :percent_based]
      belongs_to :loan_product, class_name: "LoansModule::LoanProduct"
      belongs_to :account, class_name: "AccountingModule::Account"
      validates :name, :account_id, :amount, :rate, presence: true
      validates :rate, :amount, numericality: true
      def self.except_capital_build_up
        where.not(account: MembershipsModule::ShareCapital.equity_accounts)
      end
      def self.for_capital_build_up
        where(account: MembershipsModule::ShareCapital.equity_accounts)
      end
      def charge_amount(args={})
        charge_calculator.new(args.merge(charge: self)).calculate
      end

      def charge_calculator
        ("LoansModule::LoanProductChargeCalculators::" + charge_type.titleize.gsub(" ", "")).constantize
      end

    end
  end
end
