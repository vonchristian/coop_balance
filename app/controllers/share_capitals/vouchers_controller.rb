module ShareCapitals
  class VouchersController < ApplicationController
    def show
      @voucher = current_office.vouchers.find(params[:id])
      @share_capital = current_office.share_capitals.find(params[:share_capital_id])
    end
    def destroy
      @voucher = current_office.vouchers.find(params[:id])
      @share_capital = current_office.share_capitals.find(params[:share_capital_id])
      @voucher.destroy
      redirect_to share_capital_url(@share_capital), notice: "Cancelled successfully"
    end
  end
end
