module ShareCapitals
  class ConfirmationsController < ApplicationController
    def create
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user, updateable: @share_capital).process!
      redirect_to share_capital_url(@share_capital), notice: "Confirmed successfully."
    end
  end
end
