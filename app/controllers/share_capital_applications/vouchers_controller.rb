module ShareCapitalApplications
  class VouchersController < ApplicationController
    def show
      @share_capital_application = current_cooperative.share_capital_applications.find(params[:share_capital_application_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
    end
    def destroy
      @share_capital_application = current_cooperative.share_capital_applications.find(params[:share_capital_application_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
      @voucher.destroy
      @share_capital_application.destroy
      redirect_to '/', alert: "Cancelled successfully."
    end
  end
end
