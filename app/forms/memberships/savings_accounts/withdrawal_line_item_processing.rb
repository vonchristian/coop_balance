module Memberships
  module SavingsAccounts
    class WithdrawalLineItemProcessing
      include ActiveModel::Model
      attr_accessor :saving_id, :employee_id, :amount, :or_number, :account_number, :date, :payment_type, :offline_receipt, :cash_account_id, :account_number
      validates :amount, presence: true, numericality: { greater_than: 0.01 }
      validates :or_number, presence: true
      validate :amount_does_not_exceed_balance?
      def save
        ActiveRecord::Base.transaction do
          create_deposit_voucher
        end
      end

      def find_voucher
        Voucher.find_by(account_number: account_number)
      end

      def find_saving
        MembershipsModule::Saving.find_by_id(saving_id)
      end
      def find_employee
        User.find_by_id(employee_id)
      end
      private
      def create_deposit_voucher
        voucher = Voucher.new(
          payee: find_saving.depositor,
          office: find_employee.office,
          cooperative: find_employee.cooperative,
          preparer: find_employee,
          description: "Savings withdrawal transaction of #{find_saving.depositor.name}",
          reference_number: or_number,
          account_number: account_number,
          date: date)
        voucher.voucher_amounts.debit.build(
          cooperative: find_employee.cooperative,
          account: debit_account,
          amount: amount,
          commercial_document: find_saving)
        voucher.voucher_amounts.credit.build(
          cooperative: find_employee.cooperative,
          account: credit_account,
          amount: amount,
          commercial_document: find_saving)
        voucher.save!
      end


      def credit_account
        AccountingModule::Account.find(cash_account_id)
      end

      def debit_account
        find_saving.saving_product_account
      end

      def amount_does_not_exceed_balance?
        errors[:amount] << "Exceeded available balance" if amount.to_f > find_saving.balance
      end
    end
  end
end
