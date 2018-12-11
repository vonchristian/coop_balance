module LoansModule
  module Loans
    class PenaltyPosting
      include ActiveModel::Model
      attr_accessor :date, :description, :amount, :employee_id, :loan_id

      def post!
        ActiveRecord::Base.transaction do
          post_penalty
        end
      end

      private
      def post_penalty
        find_loan.loan_penalties.create(
          date: date,
          description: description,
          amount: amount,
          employee: find_employee)
      end
      def find_employee
        User.find_by_id(employee_id)
      end
      def find_loan
        LoansModule::Loan.find_by_id(loan_id)
      end
    end
  end
end
