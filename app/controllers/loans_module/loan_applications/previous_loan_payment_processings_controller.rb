module LoansModule
  module LoanApplications
    class PreviousLoanPaymentProcessingsController < ApplicationController
      respond_to :html, :json

      def new
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @loan             = current_cooperative.loans.find(params[:loan_id])
        @payment          = LoansModule::LoanApplications::PreviousLoanPaymentProcessing.new
        respond_modal_with @payment
      end

      def create
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @loan             = current_cooperative.loans.find(params[:loans_module_loan_applications_previous_loan_payment_processing][:loan_id])
        @payment          = LoansModule::LoanApplications::PreviousLoanPaymentProcessing.new(payment_params)
        @payment.process!
        respond_modal_with @payment,
          location: new_loans_module_loan_application_voucher_url(@loan_application)
      end

      private
      def payment_params
        params.require(:loans_module_loan_applications_previous_loan_payment_processing).
        permit(:principal_amount, :interest_amount, :penalty_amount, :employee_id, :loan_application_id, :loan_id)
      end
    end
  end
end
