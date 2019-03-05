module LoansModule
  module LoanApplications
    class DisbursementsController < ApplicationController
      def new
        @loan_application = current_office.loan_applications.find(params[:loan_application_id])
        @voucher = @loan_application.voucher
        @disbursement = LoansModule::LoanApplications::Disbursement.new
      end
      def create
        @loan_application = current_office.loan_applications.find(params[:loan_application_id])
        @voucher = @loan_application.voucher
        @disbursement = LoansModule::LoanApplications::Disbursement.new(disbursement_params)
        if @disbursement.valid?
          @disbursement.disburse!
          redirect_to loan_url(@loan_application.loan), notice: "Loan disbursed successfully."
        else
          render :new
        end
      end

      private
      
      def disbursement_params
        params.require(:loans_module_loan_applications_disbursement).
        permit(:disbursement_date, :loan_application_id, :employee_id)
      end
    end
  end
end
