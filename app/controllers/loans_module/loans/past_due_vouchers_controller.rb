module LoansModule
  module Loans
    class PastDueVouchersController < ApplicationController
      respond_to :html, :json
      def new
        @loan = current_cooperative.loans.find(params[:loan_id])
        @past_due_voucher = LoansModule::Loans::PastDueVoucherProcessing.new
        respond_modal_with @past_due_voucher
      end

      def create
        @loan = current_cooperative.loans.find(params[:loan_id])
        @past_due_voucher = LoansModule::Loans::PastDueVoucherProcessing.new(past_due_voucher_params)
        @past_due_voucher.process!
        respond_modal_with @past_due_voucher, location: loans_module_loan_past_due_voucher_url(loan_id: @loan, id: @past_due_voucher.find_voucher.id), notice: "Past due voucher saved successfully."
      end

      def show
        @loan = current_cooperative.loans.find(params[:loan_id])
        @voucher = current_cooperative.vouchers.find(params[:id])
      end

      def destroy
        @loan = current_cooperative.loans.find(params[:loan_id])
        @voucher = current_cooperative.vouchers.find(params[:id])
        @voucher.destroy
        redirect_to loan_settings_url(@loan), alert: "destroyed successfully."
      end

      private

      def past_due_voucher_params
        params.require(:loans_module_loans_past_due_voucher_processing)
              .permit(:date, :description, :loan_id, :employee_id, :account_number, :cooperative_id, :reference_number)
      end
    end
  end
end
