module SavingsAccounts
  class BalanceTransferVouchersController < ApplicationController
    def show
      @origin_saving      = current_office.savings.find(params[:savings_account_id])
      @voucher            = current_office.vouchers.find(params[:id])
    end
  end
end
