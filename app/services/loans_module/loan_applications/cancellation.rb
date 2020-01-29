module LoansModule
  module LoanApplications 
    class Cancellation 
      attr_reader :loan_application, :office
      def initialize(loan_application:)
        @loan_application = loan_application
        @office           = @loan_application.office
      end

      def cancel! 
        ApplicationRecord.transaction do 
          delete_voucher_amounts
          delete_accountable_accounts
          delete_loan_application
        end 
      end

      private 
      def delete_voucher_amounts
        if loan_application.voucher.present?
          loan_application.voucher.voucher_amounts.destroy_all
        end
        loan_application.voucher_amounts.destroy_all
      end 

      def delete_accountable_accounts
        receivable_account       = office.accountable_accounts.find_by(account_id: loan_application.receivable_account_id)
        interest_revenue_account = office.accountable_accounts.find_by(account_id: loan_application.interest_revenue_account_id)
        
        if receivable_account.present?
          receivable_account.destroy 
        end 

        if interest_revenue_account.present?
          interest_revenue_account.destroy
        end 
      end
      
      def delete_loan_application
        loan_application.voucher_amounts.destroy_all
        loan_application.destroy 
      end
    end
  end
end