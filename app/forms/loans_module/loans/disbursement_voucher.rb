module LoansModule
  module Loans
    class DisbursementVoucher
      include ActiveModel::Model
      attr_accessor :loan_id, :preparer_id, :date, :description, :number

      def process!
        ActiveRecord::Base.transaction do
          create_voucher
        end
      end

      private
      def create_voucher
        voucher = Voucher.create!(
          date: date,
          number: number,
          description: description,
          payee: find_loan,
          preparer: find_preparer)
        add_amounts(voucher)
      end
      def find_loan
        LoansModule::Loan.find_by_id(loan_id)
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
        amount: find_loan.net_proceed,
        description: 'Net Proceed',
        account: AccountingModule::Account.find_by(name: "Cash on Hand - Main (Treasury)"),
        commercial_document: find_loan)

        find_loan.loan_charges.credit.each do |charge|
          voucher.voucher_amounts.create!(
          amount_type: 'credit',
          amount: charge.charge_amount_with_adjustment,
          description: charge.name,
          account: charge.account,
          commercial_document: charge.commercial_document)
        end

        find_loan.loan_charges.debit.each do |charge|
          voucher.voucher_amounts.create!(
          amount_type: 'debit',
          amount: charge.charge_amount_with_adjustment,
          description: charge.name,
          account: charge.account,
          commercial_document: charge.commercial_document)
        end
      end
    end
  end
end
