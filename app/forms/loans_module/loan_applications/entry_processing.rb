module LoansModule
  module LoanApplications
    class EntryProcessing
      include ActiveModel::Model
      attr_reader :voucher, :employee, :loan, :loan_application, :cooperative

      def initialize(args)
        @voucher          = args[:voucher]
        @employee         = args[:employee]
        @loan             = args[:loan]
        @loan_application = args[:loan_application]
        @cooperative      = @employee.cooperative
      end
      def process!
        ActiveRecord::Base.transaction do
          create_entry
          update_last_transaction_date
          update_terms
        end
      end

      private
      def create_entry
        entry = AccountingModule::Entry.new(
          cooperative_service: voucher.cooperative_service,
          office:              voucher.office,
          cooperative:         cooperative,
          commercial_document: voucher.payee,
          description:         voucher.description,
          recorder:            employee,
          reference_number:    voucher.reference_number,
          previous_entry:      find_recent_entry,
          previous_entry_hash: find_recent_entry.encrypted_hash,
          entry_date:          voucher.date)

          voucher.voucher_amounts.debit.excluding_account(account: loan.loan_product_loans_receivable_current_account).each do |amount|
            entry.debit_amounts.build(
              account_id: amount.account_id,
              amount: amount.amount,
              commercial_document: amount.commercial_document)
          end

          voucher.voucher_amounts.credit.excluding_account(account: loan.loan_product_interest_revenue_account).each do |amount|
            entry.credit_amounts.build(
              account: amount.account,
              amount: amount.amount,
              commercial_document: amount.commercial_document)
          end

          voucher.voucher_amounts.credit.for_account(account: loan.loan_product_interest_revenue_account).each do |amount|
            entry.credit_amounts.build(
              account: amount.account,
              amount: amount.amount,
              commercial_document: loan)
          end

          voucher.voucher_amounts.debit.for_account(account: loan.loan_product_loans_receivable_current_account).each do |amount|
            entry.debit_amounts.build(
              account_id: amount.account_id,
              amount: amount.amount,
              commercial_document: loan)
          end

        entry.save!
        voucher.update_attributes!(accounting_entry: entry)
      end

      def update_last_transaction_date
          loan.update_attributes!(last_transaction_date: voucher.date)
          loan.borrower.update_attributes!(last_transaction_date: voucher.date)
      end

      def update_terms
        loan.current_term.update_attributes!(
          effectivity_date: voucher.date,
          maturity_date: proper_date)
      end

      def proper_date
        voucher.date +
        TermParser.new(loan.term).add_months +
        TermParser.new(loan.term).add_days
      end

      def find_recent_entry
        cooperative.entries.recent
      end
    end
  end
end
