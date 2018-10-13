module TimeDepositApplications
  class VoucherConfirmationsController < ApplicationController
    def create
      @time_deposit_application = TimeDepositApplication.find(params[:time_deposit_application_id])
      @voucher = Voucher.find(params[:voucher_id])
      ActiveRecord::Base.transaction do
        TimeDeposits::Opening.new(time_deposit_application: @time_deposit_application, employee: current_user, voucher: @voucher).process!
        Vouchers::DisbursementProcessing.new(voucher_id: @voucher.id, employee_id: current_user.id).process!
        redirect_to vouchers_url, notice: "confirmed successfully."
      end
    end
  end
end
