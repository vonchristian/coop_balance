module LoansModule
  module LoanApplications
    class PreviousLoanPaymentProcessing
      include ActiveModel::Model
      attr_accessor :principal_amount, :interest_amount, :penalty_amount, :loan_application_id, :loan_id, :employee_id
      validates :principal_amount, numericality: true, presence: true
      validates :interest_amount, :penalty_amount, numericality: true
      def process!
        if valid?
          ActiveRecord::Base.transaction do
            create_voucher_amount
          end
        end
      end

      private
      def create_voucher_amount
        find_loan_application.voucher_amounts.create!(
        description: "Previous Loan Payment (Principal)",
        amount: principal_amount.to_f,
        account: find_loan.principal_account,
        commercial_document: find_loan,
        cooperative: find_loan_application.cooperative,
        amount_type: 'credit')

        if interest_amount.to_f > 0
          find_loan_application.voucher_amounts.create!(
          description: "Previous Loan Payment (Interest)",
          amount: interest_amount.to_f,
          account: find_loan.interest_revenue_account,
          commercial_document: find_loan,
          cooperative: find_loan_application.cooperative,
          amount_type: 'credit')
        end

        if penalty_amount.to_f > 0
          find_loan_application.voucher_amounts.create!(
          description: "Previous Loan Payment (Penalty)",
          amount: penalty_amount.to_f,
          account: find_loan.penalty_revenue_account,
          commercial_document: find_loan,
          cooperative: find_loan_application.cooperative,
          amount_type: 'credit')
        end
      end

      def find_loan_application
        LoansModule::LoanApplication.find(loan_application_id)
      end

      def find_loan
        LoansModule::Loan.find(loan_id)
      end

      def interest_income_account
        if find_loan.loan_product.current_interest_config.past_due_interest_income_account.present?
          find_loan.loan_product.current_interest_config.past_due_interest_income_account
        else
          find_loan.loan_product.current_interest_config.interest_revenue_account
        end
      end
    end
  end
end
