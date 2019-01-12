module LoansModule
  module Loans
    class PastDueVoucherProcessing
      include ActiveModel::Model
      attr_accessor :date, :loan_id, :employee_id, :reference_number, :account_number, :description, :cooperative_id
      def process!
        ActiveRecord::Base.transaction do
          create_past_due_voucher
        end
      end

      def find_voucher
        find_cooperative.vouchers.find_by(account_number: account_number)
      end

      private
      def create_past_due_voucher
        loan        = find_loan
        cooperative = find_cooperative
        voucher =       cooperative.vouchers.new(
        account_number: account_number,
        office:         find_employee.office,
        payee:          loan.borrower,
        number:         reference_number,
        description:    description,
        preparer:       find_employee,
        date:           date)
        voucher.voucher_amounts.debit.build(
          amount: loan.balance,
      account: loan.loan_product_past_due_account,
          commercial_document: loan
        )
        voucher.voucher_amounts.credit.build(
          amount: loan.balance,
          account: loan.loan_product_current_account,
          commercial_document: loan
        )
        voucher.save!
      end
      def find_cooperative
        Cooperative.find(cooperative_id)
      end
      def find_loan
        find_cooperative.loans.find(loan_id)
      end
      def find_employee
        find_cooperative.users.find(employee_id)
      end
    end
  end
end
