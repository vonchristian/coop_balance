module TimeDeposits
  class TransferVouchersController < ApplicationController
    def show
      @time_deposit = current_office.time_deposits.find(params[:time_deposit_id])
      @voucher      = current_office.vouchers.find(params[:id])
    end
  end
end
