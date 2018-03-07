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
            account: share_capital_account,
            commercial_document: find_share_capital
          ],
          debit_amounts_attributes: [
            amount: amount,
            account: unearned_interest_income_account,
            commercial_document: find_loan
          ]
        )
      end

      def find_borrower
        find_loan.borrower
      end
      def find_share_capital
        find_borrower.share_capitals.default.first
      end

      def find_loan
        LoansModule::Loan.find_by_id(loan_id)
      end
      def unearned_interest_income_account
        find_loan.loan_product_unearned_interest_income_account
      end
      def share_capital_account
        find_share_capital.share_capital_product_paid_up_account
      end
    end
  end
end
