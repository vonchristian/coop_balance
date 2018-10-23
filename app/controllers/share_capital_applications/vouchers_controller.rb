module ShareCapitalApplications
  class VouchersController < ApplicationController
    def show
      @share_capital_application = ShareCapitalApplication.find(params[:share_capital_application_id])
      @voucher = Voucher.find(params[:id])
    end
    def destroy
      @share_capital_application = ShareCapitalApplication.find(params[:share_capital_application_id])
      @voucher = Voucher.find(params[:id])
      @voucher.destroy
      @share_capital_application.destroy
      redirect_to '/', alert: "Cancelled successfully."
    end
  end
end
