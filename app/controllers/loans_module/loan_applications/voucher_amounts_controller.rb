module LoansModule
  module LoanApplications
    class VoucherAmountsController < ApplicationController
      respond_to :html, :json

      def new
        @loan_application = LoanApplication.find(params[:loan_application_id])
        @charge           = LoanApplications::VoucherAmountProcessing.new
        respond_modal_with @charge
      end

      def create
        @loan_application = LoanApplication.find(params[:loan_application_id])
        @charge           = LoanApplications::VoucherAmountProcessing.new(charge_params)
        @charge.process!
        respond_modal_with @charge, location: loans_module_loan_application_url(@loan_application)
      end

      def destroy
        @loan_application = LoanApplication.find(params[:loan_application_id])
        @voucher_amount = Vouchers::VoucherAmount.find(params[:voucher_amount_id])
        @voucher_amount.destroy
        redirect_to loans_module_loan_application_url(@loan_application), alert: 'Removed successfully.'
      end

      private
      def charge_params
        params.require(:loans_module_loan_applications_voucher_amount_processing).
        permit(:amount, :account_id, :description, :loan_application_id)
      end
    end
  end
end
