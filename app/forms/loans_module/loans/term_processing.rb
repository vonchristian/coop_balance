module LoansModule
  module Loans
    class TermProcessing
      include ActiveModel::Model
      attr_accessor :effectivity_date, :term, :loan_id, :employee_id
      validates :term, presence: true, numericality: true
      validates :loan_id, :employee_id, :effectivity_date, presence: true

      def process!
        if valid?
          ActiveRecord::Base.transaction do
            save_term_extension
          end
        end
      end

      private
      def save_term_extension
        find_loan.terms.create!(
          effectivity_date: effectivity_date,
          maturity_date: maturity_date,
          term: term)
      end
      def maturity_date
        effectivity_date.to_date + term.to_i.days
      end

      def find_loan
        LoansModule::Loan.find(loan_id)
      end

      def find_borrower
        find_loan.borrower
      end

      def find_employee
        User.find(employee_id)
      end
    end
  end
end
