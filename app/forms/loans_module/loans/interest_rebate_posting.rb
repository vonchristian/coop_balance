module LoansModule
  module Loans
    class InterestRebatePosting
      include ActiveModel::Model
      attr_accessor :date, :reference_number, :description, :amount, :employee_id, :loan_id

      def save
        ActiveRecord::Base.transaction do
          post_interest_rebate
        end
      end

      private
      def post_interest_rebate
        AccountingModule::Entry.create(
          entry_date: date,
          reference_number: reference_number,
          description: description,
          commercial_document: find_borrower,
          credit_amounts_attributes: [
            amount: amount,
            account: interest_rebate_account,
            commercial_document: find_loan
          ],
          debit_amounts_attributes: [
            amount: amount,
            account: interest_receivable_account,
            commercial_document: find_loan
          ]
        )
      end

      def find_borrower
        find_loan.borrower
      end
      def find_loan
        LoansModule::Loan.find_by_id(loan_id)
      end
      def interest_rebate_account
        find_loan.loan_product_interest_rebate_account
      end
      def interest_receivable_account
        find_loan.loan_product_interest_receivable_account
      end
    end
  end
end
