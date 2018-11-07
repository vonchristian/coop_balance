module Vouchers
  class DisbursementsController < ApplicationController
    def create
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
      redirect_to vouchers_url, notice: "Voucher disbursed successfully."
    end
  end
end
