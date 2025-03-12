module Vouchers
  class LoanDisbursementsController < ApplicationController
    def new
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      @disbursement = Vouchers::LoanDisbursementForm.new
    end

    def create
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      @disbursement = Vouchers::LoanDisbursementForm.new(disbursement_params)
      if @disbursement.valid?
        @disbursement.save
        redirect_to voucher_url(@voucher), notice: "Loan Disbursement Voucher disbursed successfully"
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def disbursement_params
      params.require(:disbursement_form).permit(:voucher_id, :description, :payee_id, :payee_type, :recorder_id, :amount, :reference_number, :date)
    end
  end
end
