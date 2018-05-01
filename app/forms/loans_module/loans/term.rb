module LoansModule
  module Loans
    class Term
      include ActiveModel::Model
      attr_accessor :effectivity_date, :term, :loan_id, :employee_id
      def extend!
        ActiveRecord::Base.transaction do
          save_term_extension
          compute_interest
        end
      end

      private
      def save_term_extension
        find_loan.terms.create(
          effectivity_date: effectivity_date,
          maturity_date: maturity_date,
          term: term)
      end
      def maturity_date
        effectivity_date.to_date + term.to_i.months
      end

      def compute_interest
        AccountingModule::Entry.create(
          origin: find_employee.office,
          recorder: find_employee,
          entry_date: effectivity_date,
          description: "Interest on loan for term extension of #{term} months of #{find_loan.borrower_name}",
          commercial_document: find_borrower,
          credit_amounts_attributes: [
            amount: computed_amount,
            account: find_loan.loan_product_interest_revenue_account,
            commercial_document: find_loan
          ],
          debit_amounts_attributes: [
            amount: computed_amount,
            account: find_loan.loan_product_interest_receivable_account,
            commercial_document: find_loan
          ]
        )
      end
      def find_loan
        LoansModule::Loan.find_by_id(loan_id)
      end
      def find_borrower
        find_loan.borrower
      end
      def computed_amount
        find_loan.loan_product_interest_rate * find_loan.principal_balance
      end
      def find_employee
        User.find_by_id(employee_id)
      end
    end
  end
end