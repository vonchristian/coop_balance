module LoansModule
  module LoanApplications
    class EntryProcessing
      include ActiveModel::Model
      attr_reader :voucher, :employee, :loan, :loan_application, :cooperative
      def initialize(args)
        @employee         = args[:employee]
        @loan_application = args[:loan_application]
        @loan             = @loan_application.loan 
        @voucher          = @loan_application.voucher

        @cooperative      = @employee.cooperative
      end

      def find_entry
        AccountingModule::Entry.find_by(reference_number: voucher.reference_number)
      end

      def process!
        ActiveRecord::Base.transaction do
          create_entry
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
          recorder:            voucher.preparer,
          reference_number:    voucher.reference_number,
          entry_date:          voucher.disbursement_date)

          voucher.voucher_amounts.debit.excluding_account(account: loan.receivable_account).each do |amount|
            entry.debit_amounts.build(
              account_id: amount.account_id,
              amount: amount.amount,
              commercial_document: set_commercial_document(amount)
            )
          end

          voucher.voucher_amounts.credit.each do |amount|
            entry.credit_amounts.build(
              account:             amount.account,
              amount:              amount.amount,
              commercial_document: set_commercial_document(amount)
            )
          end

          voucher.voucher_amounts.debit.for_account(account: loan.receivable_account).each do |amount|
            entry.debit_amounts.build(
              account_id:          amount.account_id,
              amount:              amount.amount,
              commercial_document: loan)
          end

        entry.save!
        voucher.update!(entry_id: entry.id, disburser: employee)
      end

      def set_commercial_document(amount)
        if amount.commercial_document == loan_application
          loan
        else
          amount.commercial_document
        end
      end

    end
  end
end
