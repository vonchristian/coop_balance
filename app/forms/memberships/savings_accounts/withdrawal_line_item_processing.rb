module Memberships
  module SavingsAccounts
    class WithdrawalLineItemProcessing < ActiveInteraction::Base
      uuid :saving_id, :employee_id, :account_number, :cash_account_id
      float :amount
      string :or_number, :account_number, :description
      date :date
      boolean :offline_receipt, default: true
      validates :amount, presence: true, numericality: { greater_than: 0.01 }
      validates :or_number, :date, :description, :cash_account_id, presence: true

      validate :amount_exceed_balance?

      def execute
        ActiveRecord::Base.transaction do
          create_deposit_voucher
        end
      end

      def find_voucher
        Voucher.find_by(account_number: account_number)
      end

      def saving
        @saving ||= DepositsModule::Saving.find(saving_id)
      end

      def employee
        @empoyee ||= User.find(employee_id)
      end

      private

      def create_deposit_voucher
        voucher = Voucher.new(
          payee: saving.depositor,
          office: employee.office,
          cooperative: employee.cooperative,
          preparer: employee,
          description: description,
          reference_number: or_number,
          account_number: account_number,
          date: date
        )
        voucher.voucher_amounts.debit.build(
          cooperative: employee.cooperative,
          account_id: saving.liability_account_id,
          amount: amount
        )
        voucher.voucher_amounts.credit.build(
          cooperative: employee.cooperative,
          account_id: cash_account_id,
          amount: amount
        )
        voucher.save!
      end

      def amount_exceed_balance?
        errors.add(:base, 'Exceeded available balance') if amount.to_f > saving.balance
      end
    end
  end
end
