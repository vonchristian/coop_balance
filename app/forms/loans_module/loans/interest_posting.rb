module LoansModule
  module Loans
    class InterestPosting
      include ActiveModel::Model
      attr_accessor :date, :reference_number, :description, :amount, :employee_id, :loan_id

      def post!
        ActiveRecord::Base.transaction do
          post_interest
        end
      end

      private
      def post_interest
        find_loan.loan_interests.create!(
          amount: amount,
          date: date,
          description: description,
          computed_by: find_employee)
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
