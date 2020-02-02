module LoansModule
  module Loans
    class PastDueVoucherConfirmationProcessing
      include ActiveModel::Model
      attr_reader :voucher, :employee, :loan

      def initialize(args)
        @voucher    = args[:voucher]
        @employee   = args[:employee]
        @loan = args[:loan]
      end

      def process!
        ActiveRecord::Base.transaction do
          create_entry
          update_last_transaction_date
          update_accounts_last_transaction_date
          update_loan_status
        end
      end

      private
      def create_entry
        entry = AccountingModule::Entry.new(
        cooperative_service: voucher.cooperative_service,
        office:              voucher.office,
        cooperative:         find_cooperative,
        commercial_document: voucher.payee,
        description:         voucher.description,
        recorder:            voucher.preparer,
        reference_number:    voucher.number,
        entry_date:          voucher.date)

        voucher.voucher_amounts.debit.each do |amount|
          entry.debit_amounts.build(
            account: amount.account,
            amount: amount.amount)
        end

        voucher.voucher_amounts.credit.each do |amount|
          entry.credit_amounts.build(
            account: amount.account,
            amount: amount.amount)
        end
        entry.save!
        voucher.update_attributes!(accounting_entry: entry)
      end

      def update_last_transaction_date
        loan.update_attributes!(last_transaction_date: voucher.date)
      end

      def update_loan_status
        loan.past_due!
      end

      def update_accounts_last_transaction_date
        voucher.voucher_amounts.accounts.each do |account|
          account.update_attributes!(last_transaction_date: voucher.date)
        end
      end

      def find_recent_entry
        find_cooperative.entries.recent
      end

      def find_cooperative
        voucher.cooperative
      end
    end
  end
end
