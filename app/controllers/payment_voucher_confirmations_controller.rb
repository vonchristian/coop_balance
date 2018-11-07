
  class PaymentVoucherConfirmationsController < ApplicationController
    def create
      @loan = current_cooperative.loans.find(params[:loan_id])
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      Vouchers::EntryProcessing.new(
        voucher:    @voucher,
        employee:   current_user,
        updateable: @loan).process!

      redirect_to loan_payments_url(@loan), notice: "Payment saved successfully."
    end
  end
