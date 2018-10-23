module ShareCapitals
  class ConfirmationsController < ApplicationController
    def create
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      @share_capital = MembershipsModule::ShareCapital.find(params[:share_capital_id])
      Vouchers::DisbursementProcessing.new(voucher_id: @voucher.id, employee_id: current_user.id).process!
      redirect_to share_capital_url(@share_capital), notice: "Confirmed successfully."
    end
  end
end
