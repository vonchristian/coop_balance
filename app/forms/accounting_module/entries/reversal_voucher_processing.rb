module AccountingModule
  module Entries
    class ReversalVoucherProcessing
      include ActiveModel::Model
      attr_accessor :entry_id, :employee_id, :description, :reference_number, :account_number

      validates :entry_id, :employee_id, :description, :account_number, presence: true

      def process!
        if valid?
          ApplicationRecord.transaction do
            create_reversal_entry
          end
        end
      end

      private

      def create_reversal_entry
        reversal_voucher = find_entry.office.vouchers.build(
          account_number: account_number,
          cooperative:    find_employee.cooperative,
          preparer:       find_employee,
          description:    description,
          reference_number: reference_number,
          date:           find_entry.entry_date,
          payee:          find_entry.commercial_document
        )

        find_entry.debit_amounts.each do |debit_amount|
          reversal_voucher.voucher_amounts.credit.build(amount: debit_amount.amount, account: debit_amount.account)
        end

        find_entry.credit_amounts.each do |credit_amount|
          reversal_voucher.voucher_amounts.debit.build(amount: credit_amount.amount, account: credit_amount.account)
        end

        reversal_voucher.save!
      end

      def find_employee
        User.find(employee_id)
      end

      def find_entry
        find_employee.office.entries.find(entry_id)
      end

    end
  end
end
