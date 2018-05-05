module LoansModule
  module Loans
    class InterestPosting
      include ActiveModel::Model
      attr_accessor :date, :reference_number, :description, :amount, :employee_id, :loan_id

      def post!
        ActiveRecord::Base.transaction do
          post_interest
          create_schedule_fo_posting
        end
      end

      private
      def post_interest
        AccountingModule::Entry.create(
          origin: find_employee.office,
          recorder: find_employee,
          entry_date: date,
          reference_number: reference_number,
          description: description,
          commercial_document: find_borrower,
          credit_amounts_attributes: [
            amount: amount,
            account: interest_income_account,
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
      def find_employee
        User.find_by_id(employee_id)
      end

      def find_loan
        LoansModule::Loan.find_by_id(loan_id)
      end
      def interest_income_account
        find_loan.loan_product.interest_revenue_account
      end
      def interest_receivable_account
        find_loan.loan_product.interest_receivable_account
      end
    end
  end
end
