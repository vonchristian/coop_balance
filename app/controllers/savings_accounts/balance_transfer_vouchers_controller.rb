module SavingsAccounts
  class BalanceTransferVouchersController < ApplicationController
    def show
      @origin_saving      = MembershipsModule::Saving.find(params[:id])
      @destination_saving = MembershipsModule::Saving.find(params[:destination_saving_id])
      @voucher            = Voucher.find(params[:voucher_id])
    end
  end
end
