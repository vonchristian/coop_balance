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
            update_amortization_schedule
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
      def update_amortization_schedule
        if find_loan_application.amortization_schedules.present?
          find_loan_application.amortization_schedules.destroy_all
        end
        LoansModule::AmortizationSchedule.create_amort_schedule_for(find_loan_application)
      end
    end
  end
end
