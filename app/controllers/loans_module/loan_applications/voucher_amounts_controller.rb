module LoansModule
  module LoanApplications
    class VoucherAmountsController < ApplicationController
      def new
        @loan_application = LoanApplication.find(params[:loan_application_id])
        @charge           = LoanApplications::VoucherAmountProcessing.new
      end

      def create
        @loan_application = LoanApplication.find(params[:loan_application_id])
        @charge           = LoanApplications::VoucherAmountProcessing.new(charge_params)
        if @charge.valid?
          @charge.process!
          redirect_to loans_module_loan_application_url(@loan_application), notice: "Charge added successfully."
        else
          render :new
        end
      end

      private
      def charge_params
        params.require(:loans_module_loan_applications_voucher_amount_processing).
        permit(:amount, :account_id, :description, :loan_application_id)
      end
    end
  end
end
