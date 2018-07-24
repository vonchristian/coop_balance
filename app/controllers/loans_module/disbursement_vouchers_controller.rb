module LoansModule
  class DisbursementVouchersController < ApplicationController
    def create
      @loan = LoansModule::Loan.find(params[:loans_module_loans_disbursement_voucher][:loan_id])
      @voucher = LoansModule::Loans::DisbursementVoucher.new(disbursement_params)
      if @voucher.valid?
        @voucher.process!
        redirect_to loan_url(@loan), notice: "Disbursement Voucher created successfully."
      else
        redirect_to loans_module_loan_application_url(@loan), alert: "Error"
      end
    end

    private
    def disbursement_params
      params.require(:loans_module_loans_disbursement_voucher).
      permit(:date, :loan_id, :description, :number, :preparer_id)
    end
  end
end
