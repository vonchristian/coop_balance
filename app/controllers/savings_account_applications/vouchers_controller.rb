module SavingsAccountApplications
  class VouchersController < ApplicationController
    def show
      @savings_account_application = SavingsAccountApplication.find(params[:savings_account_application_id])
      @voucher = Voucher.find(params[:id])
    end
    def destroy
      @savings_account_application = SavingsAccountApplication.find(params[:savings_account_application_id])
      @voucher = Voucher.find(params[:id])
      @voucher.destroy
      @savings_account_application.destroy
      redirect_to '/', alert: "Cancelled successfully."
    end
  end
end
