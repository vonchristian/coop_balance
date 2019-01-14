module LoansModule
  module LoanApplications
    class PreviousLoanPaymentProcessing
      include ActiveModel::Model
      attr_accessor :amount, :loan_application_id, :loan_id, :employee_id
      validates :amount, numericality: true, presence: true
      def process!
        if valid?
          ActiveRecord::Base.transaction do
            save_loan_charge
          end
        end
      end

      private
      def save_loan_charge
        find_loan_application.voucher_amounts.create!(
        description: "Previous Loan Payment",
        amount: amount,
        account: find_loan.principal_account,
        commercial_document: find_loan,
        cooperative: find_loan_application.cooperative,
        amount_type: 'credit')
      end

      def find_loan_application
        LoansModule::LoanApplication.find(loan_application_id)
      end

      def find_loan
        LoansModule::Loan.find(loan_id)
      end
    end
  end
end
