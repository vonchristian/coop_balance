module Vouchers
  class DisbursementsController < ApplicationController
    def new
      @voucher = Voucher.find(params[:voucher_id])
      @disbursement = DisbursementForm.new
    end
    def create
      @voucher = Voucher.find(params[:voucher_id])
      @disbursement = DisbursementForm.new(disbursement_params)
      if @disbursement.valid?
        @disbursement.save
        redirect_to voucher_url(@voucher), notice: "Voucher disbursed successfully"
      else
        render :new
      end
    end

    private
    def disbursement_params
      params.require(:disbursement_form).permit(:voucher_id, :voucherable_id, :recorder_id, :amount, :reference_number, :date, :description, :total_amount)
    end
  end
end
