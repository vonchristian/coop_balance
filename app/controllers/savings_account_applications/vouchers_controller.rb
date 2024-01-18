module SavingsAccountApplications
  class VouchersController < ApplicationController
    def show
      @savings_account_application = current_cooperative.savings_account_applications.find(params[:savings_account_application_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
    end

    def destroy
      @savings_account_application = current_cooperative.savings_account_applications.find(params[:savings_account_application_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
      @voucher.destroy
      @savings_account_application.destroy
      redirect_to '/', alert: 'Cancelled successfully.'
    end
  end
end
