module LoansModule
  module LoanApplications
    class AmountAdjustmentsController < ApplicationController
      def new
        @loan_application = LoansModule::LoanApplication.find(params[:loan_application_id])
        @voucher_amount = Vouchers::VoucherAmount.find(params[:voucher_amount_id])
        @adjustment = LoansModule::LoanApplications::AmountAdjustmentProcessing.new
      end
      def create
        @loan_application = LoansModule::LoanApplication.find(params[:loans_module_loan_applications_amount_adjustment_processing][:loan_application_id])
        @adjustment = LoansModule::LoanApplications::AmountAdjustmentProcessing.new(adjustment_params)
        if @adjustment.valid?
          @adjustment.process!
          redirect_to loans_module_loan_application_url(@loan_application), notice: "Adjustment saved successfully."
        else
          render :new
        end
      end

      private
      def adjustment_params
        params.require(:loans_module_loan_applications_amount_adjustment_processing).
        permit(:amount, :rate, :adjustment_type, :number_of_payments, :loan_application_id, :voucher_amount_id)
      end
    end
  end
end
