module SavingsAccounts
  class BalanceTransferVouchersController < ApplicationController
    def show
      @origin_saving      = current_cooperative.savings.find(params[:id])
      @destination_saving = current_cooperative.savings.find(params[:destination_saving_id])
      @voucher            = current_cooperative.vouchers.find(params[:voucher_id])
    end
  end
end
