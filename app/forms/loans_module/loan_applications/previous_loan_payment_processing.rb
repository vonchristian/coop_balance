module LoansModule
  module LoanApplications
    class PreviousLoanPaymentProcessing
      include ActiveModel::Model
      attr_accessor :principal_amount, :interest_amount, :penalty_amount, :loan_application_id, :loan_id, :employee_id

      validates :principal_amount, :loan_application_id, :loan_id, presence: true
      validates :principal_amount, :interest_amount, :penalty_amount, numericality: true

      def process!
        return unless valid?

        ActiveRecord::Base.transaction do
          create_principal_amount
          create_interest_amount
          create_penalty_amount
        end
      end

      private

      def create_principal_amount
        find_loan_application.voucher_amounts.credit.create!(
          description: 'Previous Loan Payment (Principal)',
          amount: principal_amount.to_f,
          account: find_loan.principal_account,
          cooperative: find_loan_application.cooperative
        )
      end

      def create_interest_amount
        return unless interest_amount.to_f.positive?

        find_loan_application.voucher_amounts.credit.create!(
          description: 'Previous Loan Payment (Interest)',
          amount: interest_amount.to_f,
          account: find_loan.interest_revenue_account,
          cooperative: find_loan_application.cooperative
        )
      end

      def create_penalty_amount
        return unless penalty_amount.to_f.positive?

        find_loan_application.voucher_amounts.credit.create!(
          description: 'Previous Loan Payment (Penalty)',
          amount: penalty_amount.to_f,
          account: find_loan.penalty_revenue_account,
          cooperative: find_loan_application.cooperative
        )
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
