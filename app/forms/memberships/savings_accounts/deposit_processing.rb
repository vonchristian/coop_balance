module Memberships
  module SavingsAccounts
    class DepositProcessing
      include ActiveModel::Model
      attr_accessor :saving_id, :employee_id, :amount, :or_number, :date, :payment_type, :offline_receipt
      validates :amount, presence: true, numericality: { greater_than: 0.01 }
      validates :or_number, presence: true

      def save
        ActiveRecord::Base.transaction do
          save_deposit
        end
      end
      def find_saving
        MembershipsModule::Saving.find_by_id(saving_id)
      end
      def find_employee
        User.find_by_id(employee_id)
      end
      private
      def save_deposit
        entry = AccountingModule::Entry.create!(
          origin: find_employee.office,
          commercial_document: find_saving.depositor,
          payment_type: payment_type,
          recorder: find_employee,
          description: 'Savings deposit',
          reference_number: reference_number(entry),
          entry_date: date,
          offline_receipt: offline_receipt,
        debit_amounts_attributes: [
          account: debit_account,
          amount: amount,
          commercial_document: find_saving],
        credit_amounts_attributes: [
          account: credit_account,
          amount: amount,
          commercial_document: find_saving])
      end
      def reference_number(entry)
        if or_number.present?
          or_number
        else
          receipt = OfficialReceipt.generate_receipt
          receipt.number
        end
      end

      def debit_account
        find_employee.cash_on_hand_account
        end
      def credit_account
        find_saving.saving_product_account
      end
    end
  end
end
