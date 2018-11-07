module LoansModule
  module LoanApplications
    class AmountAdjustmentsController < ApplicationController
      respond_to :html, :json

      def new
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @voucher_amount = current_cooperative.voucher_amounts.find(params[:voucher_amount_id])
        @adjustment = LoansModule::LoanApplications::AmountAdjustmentProcessing.new
        respond_modal_with @adjustment
      end

      def create
        @loan_application = current_cooperative.loan_applications.find(params[:loans_module_loan_applications_amount_adjustment_processing][:loan_application_id])
        @voucher_amount = current_cooperative.voucher_amounts.find(params[:voucher_amount_id])
        @adjustment = LoansModule::LoanApplications::AmountAdjustmentProcessing.new(adjustment_params)
        @adjustment.process!
        respond_modal_with @adjustment,
          location: loans_module_loan_application_url(@loan_application)
      end

      private
      def adjustment_params
        params.require(:loans_module_loan_applications_amount_adjustment_processing).
        permit(:amount, :rate, :adjustment_type, :number_of_payments, :loan_application_id, :voucher_amount_id)
      end
    end
  end
end
