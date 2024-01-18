module Vouchers
  class DisbursementsController < ApplicationController
    def create
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
      redirect_to vouchers_url, notice: 'Transaction confirmed successfully.'
    end
  end
end
