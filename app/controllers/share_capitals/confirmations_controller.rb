module ShareCapitals
  class ConfirmationsController < ApplicationController
    def create
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      @share_capital = current_cooperative.share_capitals.find(params[:share_capital_id])
      Vouchers::EntryProcessing.new(updateable: @share_capital, voucher: @voucher, employee: current_user, updateable: @share_capital).process!
      redirect_to share_capital_url(@share_capital), notice: "Capital build up transaction saved successfully."
    end
  end
end
