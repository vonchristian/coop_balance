module LoansModule
  module Loans
    class TermProcessing
      include ActiveModel::Model
      attr_accessor :effectivity_date, :number_of_days, :loan_id, :employee_id

      validates :number_of_days, presence: true, numericality: { only_integer: true, greater_than: 0 }
      validates :loan_id, :employee_id, :effectivity_date, presence: true

      def process!
        if valid?
          ActiveRecord::Base.transaction do
            create_loan_term
          end
        end
      end

      private
      def create_loan_term
        Term.create!(
          termable:         find_loan,
          effectivity_date: effectivity_date,
          maturity_date:    maturity_date,
          number_of_days:   number_of_days.to_i)
      end
      def maturity_date
        effectivity_date.to_date + number_of_days.to_i.days
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
