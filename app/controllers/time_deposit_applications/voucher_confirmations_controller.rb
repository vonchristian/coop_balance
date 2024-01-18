module TimeDepositApplications
  class VoucherConfirmationsController < ApplicationController
    def create
      @time_deposit_application = current_cooperative.time_deposit_applications.find(params[:time_deposit_application_id])
      @voucher = Voucher.find(params[:voucher_id])
      ActiveRecord::Base.transaction do
        TimeDeposits::Opening.new(time_deposit_application: @time_deposit_application, employee: current_user, voucher: @voucher).process!
        Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
        @time_deposit = current_cooperative.time_deposits.find_by(account_number: @time_deposit_application.account_number)
        redirect_to time_deposit_url(@time_deposit), notice: 'Transaction confirmed successfully.'
      end
    end
  end
end
