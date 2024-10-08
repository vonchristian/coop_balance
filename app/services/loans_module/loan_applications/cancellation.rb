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
          delete_accounts
          delete_loan_application
        end
      end

      private

      def delete_voucher_amounts
        loan_application.voucher.voucher_amounts.destroy_all if loan_application.voucher.present?
        loan_application.voucher_amounts.destroy_all
      end

      def delete_accounts
        loan_application.receivable_account.destroy
        loan_application.interest_revenue_account.destroy
      end

      def delete_loan_application
        loan_application.voucher_amounts.destroy_all
        loan_application.destroy
      end
    end
  end
end
