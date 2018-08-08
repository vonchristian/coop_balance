module LoansModule
  module Loans
    class Term
      include ActiveModel::Model
      attr_accessor :effectivity_date, :term, :loan_id, :employee_id
      def extend!
        ActiveRecord::Base.transaction do
          save_term_extension
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
