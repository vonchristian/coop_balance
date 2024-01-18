module TimeDepositApplications
  class VouchersController < ApplicationController
    def show
      @time_deposit_application = current_cooperative.time_deposit_applications.find(params[:time_deposit_application_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
    end

    def destroy
      @time_deposit_application = current_cooperative.time_deposit_applications.find(params[:time_deposit_application_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
      @voucher.destroy
      @time_deposit_application.destroy
      redirect_to '/', alert: 'Voucher cancelled successfully.'
    end
  end
end
