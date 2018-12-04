module TimeDeposits
  class TransferVouchersController < ApplicationController
    def show
      @time_deposit = current_cooperative.time_deposits.find(params[:time_deposit_id])
      @voucher = current_cooperative.vouchers.find(params[:id])
      @savings_account_application = current_cooperative.savings_account_applications.find_by(account_number: @voucher.account_number )
    end
  end
end
