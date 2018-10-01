module Memberships
  module SavingsAccounts
    class BalanceTransferProcessing
      include ActiveModel::Model

      attr_accessor :origin_id, :destination_id, :amount, :date, :employee_id, :reference_number
      validates :destination_id, :date, :reference_number, presence: true
      validate :amount_is_less_than_or_equal_to_balance?

      def process!
        ActiveRecord::Base.transaction do
          save_balance_transfer
        end
      end

      private
      def save_balance_transfer
         AccountingModule::Entry.create!(
        origin: find_employee.office,
        commercial_document: find_origin,
        recorder: find_employee,
        description: "Balance transfer from #{find_origin.name} to #{find_destination.name}",
        reference_number: reference_number,
        entry_date: date,
        debit_amounts_attributes: [
          account: find_origin.saving_product_account,
          amount: amount,
          commercial_document: find_origin],
        credit_amounts_attributes: [
          account: find_destination.saving_product_account,
          amount: amount,
          commercial_document: find_destination])
      end

      def find_employee
        User.find(employee_id)
      end
      def find_origin
        MembershipsModule::Saving.find(origin_id)
      end

      def find_destination
        MembershipsModule::Saving.find(destination_id)
      end

      def amount_is_less_than_or_equal_to_balance?
        errors[:amount] << "exceeded available balance" if amount.to_f > find_origin.balance
      end
    end
  end
end