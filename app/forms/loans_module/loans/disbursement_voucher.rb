module LoansModule
  module Loans
    class DisbursementVoucher
      include ActiveModel::Model
      attr_accessor :loan_application_id, :preparer_id, :date, :description, :number, :account_number, :net_proceed

      def process!
        ActiveRecord::Base.transaction do
          create_loan
          create_voucher
          delete_loan_application
        end
      end
      def find_loan
        LoansModule::Loan.find_by(account_number: account_number)
      end

      private
      def create_loan
        loan = LoansModule::Loan.create!(
          cooperative: find_loan_application.cooperative,
          loan_amount: find_loan_application.loan_amount,
          application_date: find_loan_application.application_date,
          borrower: find_loan_application.borrower,
          loan_product: find_loan_application.loan_product,
          preparer: find_preparer,
          account_number: account_number
          )
        loan.amortization_schedules << find_loan_application.amortization_schedules
        loan.voucher_amounts << find_loan_application.voucher_amounts
      end

      def create_voucher
        voucher = Voucher.create!(
          date: date,
          number: number,
          description: description,
          payee: find_loan,
          preparer: find_preparer)
        add_amounts(voucher)
      end
      def find_loan_application
        LoansModule::LoanApplication.find(loan_application_id)
      end
      def find_preparer
        User.find_by_id(preparer_id)
      end

      def add_amounts(voucher)
        voucher.voucher_amounts.create!(
        amount_type: 'debit',
        amount: find_loan.loan_amount,
        description: 'Loan Amount',
        account: find_loan.loan_product_loans_receivable_current_account,
        commercial_document: find_loan)

        voucher.voucher_amounts.create!(
        amount_type: 'credit',
        amount: net_proceed,
        description: 'Net Proceed',
        account: AccountingModule::Account.find_by(name: "Cash on Hand - Main (Treasury)"),
        commercial_document: find_loan)

        voucher.voucher_amounts << find_loan.voucher_amounts
      end
      def delete_loan_application
        find_loan_application.destroy
      end
    end
  end
end
