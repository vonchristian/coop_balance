module BankAccounts
  class VoucherConfirmationsController < ApplicationController
    def create
      @voucher = current_cooperative.vouchers.find(params[:voucher_id])
      @bank_account = current_cooperative.bank_accounts.find(params[:bank_account_id])
      Vouchers::EntryProcessing.new(voucher: @voucher, employee: current_user).process!
      redirect_to bank_account_url(@bank_account), notice: "Confirmed successfully."
    end
  end
end
