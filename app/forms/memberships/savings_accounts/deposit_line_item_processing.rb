module Memberships
  module SavingsAccounts
    class DepositLineItemProcessing
      include ActiveModel::Model
      attr_accessor :saving_id, :employee_id, :amount, :or_number, :account_number, :description, :date, :offline_receipt, :cash_account_id

      validates :amount, presence: true, numericality: { greater_than: 0.01 }
      validates :or_number, :date, :or_number, :description, :cash_account_id, presence: true

      def save
        ActiveRecord::Base.transaction do
          create_deposit_voucher
        end
      end

      def find_voucher
        TreasuryModule::Voucher.find_by(account_number: account_number)
      end

      def find_saving
        DepositsModule::Saving.find(saving_id)
      end

      def find_employee
        User.find(employee_id)
      end

      private

      def create_deposit_voucher
        voucher = TreasuryModule::Voucher.new(
          payee: find_saving.depositor,
          office: find_employee.office,
          cooperative: find_employee.cooperative,
          preparer: find_employee,
          description: description,
          reference_number: or_number,
          account_number: account_number,
          date: date
        )
        voucher.voucher_amounts.debit.build(
          cooperative: find_employee.cooperative,
          account: debit_account,
          amount: amount
        )
        voucher.voucher_amounts.credit.build(
          cooperative: find_employee.cooperative,
          account: credit_account,
          amount: amount
        )
        voucher.save!
      end

      def debit_account
        AccountingModule::Account.find(cash_account_id)
      end

      def credit_account
        find_saving.liability_account
      end
    end
  end
end
