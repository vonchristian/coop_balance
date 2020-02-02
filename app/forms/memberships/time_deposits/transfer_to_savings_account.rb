module Memberships
  module TimeDeposits
    class TransferToSavingsAccount
      attr_accessor :time_deposit_id, :employee_id, :date, :saving_product_id, :account_number

      def save
        ActiveRecord::Base.transaction do
          open_savings_account
        end
      end
      private
      def open_savings_account
        savings_account = MembershipsModule::Saving.create(
          depositor: find_depositor,
          saving_product_id: saving_product_id,
          account_number: account_number)
        entry = AccountingModule::Entry.create!(
          office: find_employee.office,
          cooperative: find_employee.cooperative,
          commercial_document: find_depositor,
          recorder: find_employee,
          description: "Time deposit transferred to Savings account of #{find_depositor.name}",
          reference_number: or_number,
          entry_date: find_time_deposit.date_deposited,
        debit_amounts_attributes: [
          account: debit_account,
          amount: amount],
        credit_amounts_attributes: [
          account: credit_account,
          amount: amount])
      end
      def find_depositor
        find_time_deposit.depositor
      end
      def find_time_deposit
        MembershipsModule::TimeDeposit.find(time_deposit_id)
      end
      def debit_account
        find_time_deposit.liability_account
      end
      def credit_account
        find_savings_product.account
      end
    end
  end
end
