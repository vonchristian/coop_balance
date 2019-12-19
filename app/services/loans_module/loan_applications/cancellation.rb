module LoansModule
  module LoanApplications 
    class Cancellation 
      attr_reader :loan_application, :office
      def initialize(loan_application:)
        @loan_application = loan_application
        @office           = @loan_application.office
      end

      def cancel! 
        delete_accountable_accounts
        delete_loan_application
      end

      private 
      def delete_accountable_accounts
        office.accountable_accounts.find_by(account: loan_application.receivable_account).destroy
        office.accountable_accounts.find_by(account: loan_application.interest_revenue_account).destroy
      end
      
      def delete_loan_application
        loan_application.destroy 
      end
    end
  end
end