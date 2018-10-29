module LoansModule
  module LoanApplications
    class VoucherProcessing
      include ActiveModel::Model
      attr_accessor :loan_application_id, :preparer_id, :date, :description,
      :number, :account_number, :voucher_account_number, :cash_account_id, :borrower_id,
      :borrower_type, :net_proceed

      def process!
        ActiveRecord::Base.transaction do
          create_voucher
        end
      end

      def find_voucher
        Voucher.find_by(account_number: voucher_account_number)
      end
      private
      def create_voucher
        voucher = Voucher.new(
          account_number: voucher_account_number,
          payee_id:       borrower_id,
          payee_type:     borrower_type,
          preparer:       find_employee,
          office:         find_employee.office,
          cooperative:    find_employee.cooperative,
          description:    description,
          number:         number,
          date:           date
        )
        add_amounts(voucher)
        voucher.save!
        find_loan_application.update_attributes!(voucher_id: voucher.id)
      end

      def add_amounts(voucher)
        Vouchers::VoucherAmount.create!(
        voucher: voucher,
        amount_type: 'debit',
        amount: find_loan_application.loan_amount,
        description: 'Loan Amount',
        account: find_loan_application.loan_product_loans_receivable_current_account,
        commercial_document: find_loan_application)

        voucher.voucher_amounts << find_loan_application.voucher_amounts

        Vouchers::VoucherAmount.create!(
        voucher: voucher,
        amount_type: 'credit',
        amount: net_proceed,
        description: 'Net Proceed',
        account_id: cash_account_id,
        commercial_document: find_loan_application)
      end
      def find_loan_application
        LoansModule::LoanApplication.find(loan_application_id)
      end
      def find_employee
        User.find(preparer_id)
      end
    end
  end
end
