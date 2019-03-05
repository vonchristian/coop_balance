module LoansModule
  module LoanApplications
    class ProgramPaymentsController < ApplicationController
      respond_to :html, :json

      def new
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @program = current_cooperative.programs.find(params[:program_id])
        @payment = LoansModule::LoanApplications::ProgramPayment.new
        respond_modal_with @payment
      end
      def create
        @loan_application = current_cooperative.loan_applications.find(params[:loans_module_loan_applications_program_payment][:loan_application_id])
        @program          = current_cooperative.programs.find(params[:loans_module_loan_applications_program_payment][:program_id])
        @payment          = LoansModule::LoanApplications::ProgramPayment.new(program_params)
        @payment.process!
        respond_modal_with @payment,
          location: new_loans_module_loan_application_voucher_url(@loan_application)
      end

      private

      def program_params
        params.require(:loans_module_loan_applications_program_payment).
        permit(:amount, :employee_id, :loan_application_id, :program_id)
      end
    end
  end
end
