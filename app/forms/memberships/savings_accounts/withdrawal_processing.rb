module Memberships
  module SavingsAccounts
    class WithdrawalProcessing
      include ActiveModel::Model
      include ActiveModel::Validations::Callbacks
      attr_accessor :saving_id, :amount, :or_number, :date, :employee_id, :payment_type
      validates :amount, presence: true, numericality: true
      validates :or_number, presence: true
      validate :amount_less_than_current_cash_on_hand?
      validate :amount_is_less_than_balance?

      def save
        ActiveRecord::Base.transaction do
          save_withdraw
          set_last_transaction_date
        end
      end
      def find_saving
        MembershipsModule::Saving.find_by_id(saving_id)
      end
      def find_employee
        User.find_by(id: employee_id)
      end
      private
      def save_withdraw
        AccountingModule::Entry.create!(
          origin: find_employee.office,
          commercial_document: find_saving.depositor,
          payment_type: payment_type,
          recorder: find_employee,
          description: "Withdraw transaction of #{find_saving.depositor.try(:name)}",
          reference_number: or_number,
          entry_date: date,
        debit_amounts_attributes: [
          account: debit_account,
          amount: amount,
          commercial_document: find_saving],
        credit_amounts_attributes: [
          account: credit_account,
          amount: amount,
          commercial_document: find_saving])
      end

      def credit_account
        find_employee.cash_on_hand_account
      end

      def debit_account
        find_saving.saving_product_account
      end

      private
      def amount_is_less_than_balance?
        errors[:amount] << "Amount exceeded balance"  if (amount.to_i) > find_saving.balance
      end

      def amount_less_than_current_cash_on_hand?
        errors[:amount] << "Amount exceeded current cash on hand" if (amount.to_i) > find_employee.cash_on_hand_account_balance
      end

      def set_last_transaction_date
        find_saving.update_attributes!(last_transaction_date: date)
      end
    end
  end
end
