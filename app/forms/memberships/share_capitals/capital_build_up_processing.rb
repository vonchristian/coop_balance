module Memberships
  module ShareCapitals
    class CapitalBuildUpProcessing
      include ActiveModel::Model
      attr_accessor :or_number, :amount, :date, :share_capital_id, :employee_id, :cash_account_id
      validates :amount, presence: true, numericality: { greater_than: 0.01 }
      validates :or_number, presence: true

      def save
        ActiveRecord::Base.transaction do
          save_capital_build_up
          update_share_capital_status
          set_last_transaction_date
        end
      end

      def find_share_capital
        MembershipsModule::ShareCapital.find_by_id(share_capital_id)
      end


      private
      def save_capital_build_up
      AccountingModule::Entry.create!(
        office: find_employee.office,
        cooperative: find_employee.cooperative,
        commercial_document: find_subscriber,
        recorder: find_employee,
        description: 'Payment of capital build up',
        reference_number: or_number,
        entry_date: date,
        debit_amounts_attributes: [
          account: cash_account,
          amount: amount,
          commercial_document: find_share_capital],
        credit_amounts_attributes: [
          account: credit_account,
          amount: amount,
          commercial_document: find_share_capital])
      end

      def cash_account
        AccountingModule::Account.find(cash_account_id)
      end

      def credit_account
        find_share_capital.share_capital_product_paid_up_account
      end

      def find_subscriber
        find_share_capital.subscriber
      end

      def find_employee
        User.find_by_id(employee_id)
      end
      def update_share_capital_status
        find_share_capital.set_balance_status
      end
      def set_last_transaction_date
        find_share_capital.update_attributes!(last_transaction_date: date)
        find_share_capital.subscriber.update_attributes!(last_transaction_date: date)
      end
    end
  end
end
