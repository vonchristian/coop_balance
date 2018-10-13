module Vouchers
  class ConfirmationsController < ApplicationController
    def create
      @voucher = Voucher.find(params[:voucher_id])
      Vouchers::DisbursementProcessing.new(voucher_id: @voucher.id, employee_id: current_user.id).process!
      redirect_to vouchers_url, notice: "confirmed successfully."
    end
  end
end
