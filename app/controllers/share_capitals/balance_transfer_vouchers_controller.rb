module ShareCapitals
  class BalanceTransferVouchersController < ApplicationController
    def show
      @voucher = Voucher.find(params[:id])
      @origin_share_capital = MembershipsModule::ShareCapital.find(params[:origin_share_capital_id])
      @destination_share_capital = MembershipsModule::ShareCapital.find(params[:destination_share_capital_id])

    end
    def destroy
      @voucher = Voucher.find(params[:id])
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      @voucher.destroy
      redirect_to share_capital_url(@share_capital), notice: "Cancelled successfully"
    end
  end
end
