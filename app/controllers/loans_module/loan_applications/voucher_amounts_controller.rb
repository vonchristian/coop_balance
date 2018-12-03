module LoansModule
  module LoanApplications
    class VoucherAmountsController < ApplicationController
      respond_to :html, :json

      def new
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @charge           = LoansModule::LoanApplications::VoucherAmountProcessing.new
        respond_modal_with @charge
      end

      def create
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @charge           = LoansModule::LoanApplications::VoucherAmountProcessing.new(charge_params)
        @charge.process!
        respond_modal_with @charge, location: new_loans_module_loan_application_voucher_url(@loan_application)
      end

      def destroy
        @loan_application = current_cooperative.loan_applications.find(params[:loan_application_id])
        @voucher_amount = @loan_application.voucher_amounts.find(params[:voucher_amount_id])
        @voucher_amount.destroy
        redirect_to new_loans_module_loan_application_voucher_url(@loan_application), alert: 'Removed successfully.'
      end

      private
      def charge_params
        params.require(:loans_module_loan_applications_voucher_amount_processing).
        permit(:amount, :account_id, :description, :loan_application_id)
      end
    end
  end
end
