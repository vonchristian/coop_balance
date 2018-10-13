module TimeDepositApplications
  class VouchersController < ApplicationController
    def show
      @time_deposit_application = TimeDepositApplication.find(params[:time_deposit_application_id])
      @voucher = Voucher.find(params[:id])
    end
    def destroy
      @time_deposit_application = TimeDepositApplication.find(params[:time_deposit_application_id])
      @voucher = Voucher.find(params[:id])
      @voucher.destroy
      @time_deposit_application.destroy
      redirect_to '/', alert: "Cancelled successfully."
    end
  end
end
