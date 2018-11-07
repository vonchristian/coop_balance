module SavingsAccounts
  class VoucherConfirmationsController < ApplicationController
    def create
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      @savings_account = current_cooperative.savings.find(params[:savings_account_id])
      Vouchers::EntryProcessing.new(updateable: @savings_account, voucher: @voucher, employee: current_user).process!
      redirect_to savings_account_url(@savings_account), notice: "Confirmed successfully."
    end
  end
end
