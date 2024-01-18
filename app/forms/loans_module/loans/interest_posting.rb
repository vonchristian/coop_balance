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
          employee: find_employee
        )
      end

      def find_employee
        User.find_by(id: employee_id)
      end

      def find_loan
        LoansModule::Loan.find_by(id: loan_id)
      end
    end
  end
end
