module LoansModule
  module LoanApplications 
    class Cancellation 
      attr_reader :loan_application
      def initialize(loan_application:)
        @loan_application = loan_application
      end

      def cancel! 
        delete_accounts 
        delete_loan_application
      end

      private 
      def delete_accounts
        loan_application.receivable_account.destroy 
        loan_application.interest_revenue_account.destroy 
      end
      def delete_loan_application
        loan_application.destroy 
      end
    end
  end
end